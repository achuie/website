#lang pollen

◊h1{Single-Password Encrypted NixOS}

I recently installed NixOS on my home workstation/server. I've only put ◊code{/home} on ZFS instead of going full root
on ZFS, mainly because I didn't want to deal with swap on ZFS and the root SSD would have been the odd drive out in a
ZFS mirror anyway, so I figured I might as well go with BTRFS+LVM-on-LUKS to try out all the new-to-me technologies at
once. I found some ◊body-link["https://astrid.tech/2021/12/17/0/two-disk-encrypted-zfs/"]{pretty} ◊body-link[
  "https://blog.kolaente.de/2021/11/installing-nixos-with-encrypted-btrfs-root-device-and-home-manager-from-start-to-finish/"
]{good} ◊body-link["https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f"]{guides}, but there were some steps
that were different so I wanted to write down what I did for future reference.

◊h2{Create the Installation Media}

As always, we start by creating a bootable disk. Below is my normal go-to:

◊code-block{
# dd bs=4M if=path/to/nixos-minimal-version-x86_64-linux.iso of=/dev/disk/by-id/usb-My_flash_drive
conv=fsync oflag=direct status=progress
}

◊h2{Partition the Root Drive}

Boot from the disk we just created. Ethernet should already be set up, but wifi requires extra steps:

◊code-block{
# wpa_passphrase $SSID $PASSWORD >/etc/wpa_supplicant.conf \\
# systemctl start wpa_supplicant
}

Identify your drives (◊code{fdisk -l}), and start with what will be the OS drive. Run ◊code{gdisk} on it, no partition
numbers since we'll be using the whole drive.

◊code-block{# gdisk /dev/$DISK}

Instead of the normal ◊code{/boot} partition, we'll create a partition for just the EFI bootloader entries mounted at
◊code{/boot/efi}. That way we can keep the kernel images encrypted. Create the ESP with size anywhere from ◊code{550Mb}
to ◊code{1Gb}, and with type ◊code{ef00}. The ◊code{/root} partition can use the rest of the space on the drive and
should be type ◊code{8300}.

◊h2{Generate the Volume Keys}

So far we've only dealt with the root drive. The home drive will be ZFS, so the partitioning and formatting are done
together. We'll use keyfiles to decrypt each drive, and both keys will be stored on the root drive. LUKS supports
encryption with both a key and a password, so GRUB can initially prompt us for the password, then NixOS can include the
keyfile in the initial ramdisk for Stage 1 of the boot process to use. First, we'll generate a random, four kilobyte
keyfile for LUKS:

◊code-block{
# dd if=/dev/urandom of=./keyfile0.bin bs=1024 count=4
}

ZFS requires a thirty-two byte keyfile:

◊code-block{
# dd if=/dev/urandom of=./keyfile1.bin bs=32 count=1
}

◊h2{Format the Drives}

First let's format the root drive with LUKS. The password we set here will be the one needed at boot:

◊code-block{
# cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/$DISK \\
# cryptsetup luksAddKey /dev/$DISK keyfile0.bin \\
# cryptsetup luksOpen /dev/$DISK root --key-file keyfile0.bin
}

We need to use LUKS version 1 in order to work with GRUB. Also, we're using GRUB instead of systemd-boot because GRUB is
able to work with an encrypted ◊code{/boot} (as long as ◊code{/boot/efi} is unencrypted).


◊h6{---

NOTES}

$ DISKS=$(ls /dev/disk/by-id/ata-TOSHIBA_MN06ACA10T_14K0A06* | grep -v 'part' | tr '\n' ' ')
# zpool create -O encryption=on -O keyformat=raw -O keylocation=file:///mnt-root/etc/secrets/initrd/keyfile1.bin -O compression=zstd -O mountpoint=none -O xattr=sa -O acltype=posix -O atime=off -O secondarycache=none -o ashift=12 ztank mirror $DISKS -f
# zfs create -o mountpoint=legacy ztank/home

# mkdir volkeys
# mv mnt-root/etc/secrets/initrd/keyfile1.bin volkeys/
# zfs set keylocation=file:///volkeys/keyfile1.bin ztank

https://discourse.nixos.org/t/systemd-boot-root-zfs-native-zfs-encryption-with-keylocation-file/26446
- details boot stage 1 initrd secret files
- zfs keylocation=file:// must be accessible during the stage when the system attempts to mount the pool
- our case is different, as attached storage with mountpoints is mounted during stage 2

https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f
- the main guide
- does not say about stage 2 key availability

https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
- zfs tuning reference

https://discourse.nixos.org/t/how-to-run-init-stage-2-manually/38625
- info about stage 2 root path

https://astrid.tech/2021/12/17/0/two-disk-encrypted-zfs/
- guide with multiple zpools
- some info about keylocation

https://old.reddit.com/r/zfs/comments/bnvdco/zol_080_encryption_dont_encrypt_the_pool_root/
- future work
