#lang pollen

◊(define-meta published "24 12 2024")

◊h1{Single-Password Encrypted NixOS}

I recently installed NixOS on my homelab. The setup is a mix of ZFS for home and BTRFS for root, so the process was a
bit non-standard and I wanted to write down what I did.

◊h2{Motivation}

As with most upgrades and re-tooling, at least for me it seems, I came to want a solution for disk failure ◊em{after} a
disk failed when my computer case got jostled.

Enter ZFS. Mainly I just wanted something stable with redundancy.

However, I didn't want to have to coordinate out-of-tree kernel updates and worry about producing a working system at
the end of every update, even though Arch Linux is probably the nicest and easiest distro to do it on. I'd like this
machine to always be in a bootable, working state, as it will be the backstop to my unstable and experimental laptop.

Enter NixOS. Though rife with sharp edges from a usability perspective and reprehensible bad-actors from a community
perspective, I've enjoyed using project-scoped flakes for a while. I think it will help prevent me from forgetting
things I might set up and then never touch again until it's time to update.

I've only put ◊code{/home} on ZFS instead of going full root on ZFS, mainly because I didn't want to deal with swap on
ZFS and the root SSD would have been the odd drive out in a ZFS mirror anyway, so I figured I might as well go with
BTRFS to try out all the new technologies at once. BTRFS has its own subvolume management, but I found that people
recommend using LVM if the system is to be encrypted, so LVM-on-LUKS it is.

◊h2{Step-by-Step}

I'll add comments where I can, but obviously I'm no expert.

◊h3{Create the Installation Media}

As always, we start by creating a bootable disk. Below is my normal go-to:

◊code-block{
# dd bs=4M if=path/to/nixos-minimal-version-x86_64-linux.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress
}

◊h3{Partition the Root Drive}

Boot from the disk we just created. Ethernet should already be set up, but wifi requires extra steps:

◊code-block{
# wpa_passphrase $SSID $PASSWORD >/etc/wpa_supplicant.conf
# systemctl start wpa_supplicant
}

Identify the drives (◊code{fdisk -l}), and start with what will be the OS drive. Run ◊code{gdisk} on it, no partition
numbers since we'll be using the whole drive.

◊code-block{# gdisk /dev/$DISK}

Instead of the normal ◊code{/boot} partition, we'll create a partition for just the EFI bootloader entries mounted at
◊code{/boot/efi}. That way we can keep the kernel images encrypted. Create the ESP with size anywhere from ◊code{550Mb}
to ◊code{1Gb}, and with type ◊code{ef00}. The LUKS partition can use the rest of the space on the drive and
should be type ◊code{8300}.

◊h3{Generate the Volume Keys}

So far we've only dealt with the root drive. The home drive will be ZFS so the partitioning and formatting are done
together, but before we get to that we need to create the encryption keys. We'll use keyfiles to decrypt each drive, and
both keys will be stored on the root drive. LUKS supports encryption with both a key and a password, so GRUB can
initially prompt us for the password, then NixOS can include the keyfile in the initial ramdisk for Stage 1 of the boot
process to use. First, we'll generate a random, four kilobyte keyfile for LUKS:

◊code-block{
# dd if=/dev/urandom of=./keyfile0.bin bs=1024 count=4
}

and then a random key for ZFS, which requires the keyfile be thirty-two bytes:

◊code-block{
# dd if=/dev/urandom of=./keyfile1.bin bs=32 count=1
}

◊h3{Format and Mount the Drives}

This step will be the bulk of the work, with important decisions to be made about filesystem attributes like
compression, mountpoints, and caching.

◊h4{OS Drive}

Let's set up the OS partition. LUKS first; the password we set here will be the one needed at boot:

◊code-block{
# cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/${DISK}2
}

Now we can add a second key for Stage 1 to use, entering the password we just set:

◊code-block{
# cryptsetup luksAddKey /dev/${DISK}2 keyfile0.bin
# cryptsetup luksOpen /dev/${DISK}2 root --key-file keyfile0.bin
}

We need to use LUKS version 1 in order to work with GRUB. Also, we're using GRUB instead of systemd-boot because GRUB is
able to work with an encrypted ◊code{/boot} (as long as ◊code{/boot/efi} is unencrypted). Set up LVM with the following:

◊code-block{
# pvcreate /dev/mapper/root
# vgcreate vg /dev/mapper/root
# lvcreate -L 8G -n swap vg
# lvcreate -l '100%FREE' -n root vg
}

Now we can format each logical volume. We'll start with swap, and activate it:

◊code-block{
# mkswap /dev/mapper/vg-swap
# swapon /dev/mapper/vg-swap
}

Then the root volume:

◊code-block{
# mkfs.btrfs -L root /dev/mapper/vg-root
}

And the EFI partition:

◊code-block{
# mkfs.vfat -n boot /dev/${DISK}1
}

As a last step before moving on, we can start assembling our target filesystem:

◊code-block{
# mount /dev/mapper/vg-root /mnt
# mkdir -p /mnt/boot/efi
# mount /dev/${DISK}1 /mnt/boot/efi
}

◊h4{Home Drive}

First we need to identify our disks in a persistent way, as the ZFS utility may get confused at boot just using
bus-based names. We'll use ◊code{/dev/disk/by-id} for this. We can get around having to deal with the drives' unique IDs
by selecting on some other identifying feature, such as brand name in the following:

◊code-block{
$ DISKS=$(ls /dev/disk/by-id/ata-TOSHIBA_* | grep -v 'part' | tr '\n' ' ')
}

Now we can assemble the ZFS options for our pool. I consulted this
◊body-link["https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/"]{older guide}, which still seems applicable, and
created the pool as below:

◊code-block{
# zpool create \
  -O encryption=on \
  -O keyformat=raw \
  -O keylocation=file:///keyfile1.bin \
  -O compression=zstd \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posix \
  -O atime=off \
  -O secondarycache=none \
  -o ashift=12 ztank mirror $DISKS
}

◊code{ztank} is the name of the pool. ◊code{mountpoint} is ◊code{none} because we'll use NixOS to manage the
mountpoints. It's possible to instead configure NixOS to play nicely with ZFS' mountpoint management, but I consider it
worth the extra typing to have the mountpoints enumerated in the configuration in case I need to refer to it later. In
either case, we can create and mount the ZFS volumes now since we know what directories we'll put on the pool. To use
NixOS management as we just discussed, these need to be legacy mountpoints:

◊code-block{
# zfs create -o mountpoint=legacy ztank/home
# zfs create -o mountpoint=legacy ztank/media
# zfs create -o mountpoint=legacy ztank/share

# mkdir /mnt/home
# mkdir /mnt/media
# mkdir /mnt/share
# mount -t zfs ztank/home /mnt/home
# mount -t zfs ztank/media /mnt/media
# mount -t zfs ztank/share /mnt/share
}

◊h4{Move the Keys into Place}

Now we need a permanent home for the keys. It can be anywhere, as the location will be specified in
◊code{configuration.nix} later, but I think a good practice is somewhere isolated and clear:

◊code-block{
# mkdir -p /mnt/etc/secrets/initrd
# chmod 500 /mnt/etc/secrets/initrd
# mv keyfile0.bin /mnt/etc/secrets/initrd
# chmod 400 /mnt/etc/secrets/initrd/keyfile0.bin
# mv keyfile1.bin /mnt/etc/secrets
# chmod 400 /mnt/etc/secrets/keyfile1.bin
}

For the zpool, we'll have to change the ◊code{keylocation} later when we're chroot'd into the system because ZFS needs
to be given the absolute path from the system's perspective at boot, and this won't include ◊code{/mnt}.

Regarding the permissions: ◊code{500} is read and execute (because it's a directory) only for the owner, ◊code{root}.
◊code{400} is just read.

◊h3{Generate the System Configuration}

NixOS can help us generate a starting point for our configuration, ◊code{/etc/nixos/configuration.nix} and
◊code{/etc/nixos/hardware-configuration.nix}, which we can embellish and add to later. In fact, the point of creating
the filesystem hierarchy above was to hint the generator as much as possible.

◊code-block{
# nixos-generate-config --root /mnt
}

Still, it's necessary to double-check the options. I added the following for ZFS support:

◊code-block{
  boot.initrd.kernelModules = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs.allowHibernation = false;
  boot.zfs.devNodes = "/dev/disk/by-id";

  networking.hostId = "<your ID>";

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
}

The ◊code{hostId} is required by ZFS to make sure the system using the pool is the same as the last time the pool was
used. Per ◊body-link["https://search.nixos.org/options"]{search.nixos.org}, use
◊code{head -c4 /dev/urandom | od -A none -t x4} to generate a random ID.

Below are the options for our boot process:

◊code-block{

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    enableCryptodisk = true;
    configurationLimit = 20;
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;

  boot.initrd = {
    luks.devices.root = {
      device = "/dev/disk/by-uuid/<some UUID>";
      preLVM = true;
      keyFile = "/keyfile0.bin";
      allowDiscards = true;
    };
    secrets = {
      "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
    };
  };
}

The keyfile will be copied to a top-level path in the ramdisk at the name configured by ◊code{boot.initrd.secrets}. Thus
the path at ◊code{boot.initrd.luks.devices.root.keyFile} should match the ◊code{boot.initrd.secrets} attribute, but
prepended with ◊code{"/"}.

◊code{boot.loader.efi.canTouchEfiVariables} depends on your hardware, it seems not to work on my motherboard so I'm
using ◊code{boot.loader.grub.efiInstallAsRemovable} instead. I think setting ◊code{canTouchEfiVariables = true} and
omitting ◊code{efiInstallAsRemovable} is preferred.

The hardware configuration file has a warning not to edit it, as the changes may be overwritten by future calls to
◊code{nixos-generate-config}, but we're going to make this a flake, and therefore tracked by git, so I think the risk is
minimal. There are some options we want to set here, like turning on compression for BTRFS and mounting the legacy ZFS
mountpoints.

◊code-block{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/<some UUID>";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "ztank/home";
      fsType = "zfs";
    };

  (...)
}

These options could also go in ◊code{configuration.nix}, but I think the conceptual separation is nice. With all the
prepartion complete, we can now install:

◊code-block{
# nixos-install
}

The last thing to do is to update ZFS with the new key location. NixOS' special chroot command is ◊code{nixos-enter}.
Call it without ◊code{-c} to start an interactive prompt.

◊code-block{
# nixos-enter --root /mnt -c 'zfs set keylocation=file:///etc/secrets/keyfile1.bin ztank'
}

Now we can reboot and enjoy the new system.

◊h3{Reboot}

On the off chance the disk password is input incorrectly, the following steps must be done to get back to the password
prompt for another shot:

◊code-block{
cryptomount -a <ENTER>
insmod normal <ENTER>
normal <ENTER>
}

◊h2{Wrap Up}

For reference the full config for my setup can be found
◊body-link["https://github.com/achuie/nixos-config/tree/ecda293753d3da659e3be4a025efef6dfc7f8dd7/nixos/svalbard"]{
  on GitHub
}.

I also recommend reading the following references: ◊body-link["https://wiki.nixos.org/wiki/ZFS"]{
  the NixOS wiki for ZFS
}, and ◊body-link["https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f"]{ladinu's encrypted install guide}.
