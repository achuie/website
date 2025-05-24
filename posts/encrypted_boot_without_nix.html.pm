#lang pollen

◊(define-meta published "24 05 2025")

◊h1{Encrypted Boot Without Nix}

In the past I've done an ◊body-link["./single_password_encrypted_nixos.html"]{encrypted boot setup with NixOS} for my
server, but now I'd like to also harden my laptop since, out of the two computers, that's the more vulnerable one
traveling with me and being out in public spaces. But my laptop needs to work with audio and visual media applications,
hardware interfaces, webcams, etc. I'm still more comfortable debugging/setting up that stuff on Arch than NixOS, so now
I get to dive into how to do all that LVM-on-LUKS configuration manually. It's actually not that complicated, just a few
moving parts that need to be coordinated, but the NixOS config is definitely way more convenient.

Also, beware of being led astray ◊body-link["https://bbs.archlinux.org/viewtopic.php?pid=2233525#p2233525"]{by}
◊body-link["https://bbs.archlinux.org/viewtopic.php?pid=1903509#p1903509"]{troubleshooting}
◊body-link["https://www.reddit.com/r/archlinux/comments/u420m6/luks_btrfs_subvolumes_cant_mount_root_partition/i57trsh/"]{threads}
for LUKS-on-LVM or LUKS-only systems, which somehow seem more common than my setup in this article. I was using
◊code{root=/dev/mapper/vg-root} in the kernel parameters with different combinations of ◊code{cryptkey} paths and
◊code{cryptdevice} names wondering why it wasn't working.

◊h2{Justification}

The main features I want from this setup are the following:

◊ol{
  ◊li{Boot as encrypted as possible (so the images, but not the boot entries)}
  ◊li{Password input only once}
  ◊li{A semblance of rollback-ability akin to NixOS}
}

As far as I can tell, the simplest way (or one of the simplest ways) of doing this is installing to BTRFS subvolumes for
root and home, inside an LVM volume peer with one for swap, on top of a LUKS encrypted partition matched with an
unencrypted partition for EFI. systemd-boot can't deal with initramfs images and boot entries on separate partitions, so
I'm using GRUB, which also forces me to use LUKS1. I think those are the only caveats to accomplishing the first two
points. BTRFS will accomplish the third point its snapshots feature. This can be done just before a ◊code{pacman -Syu}
to provide a point to revert back to if anything goes wrong, in the worst case by a live USB. This is strictly worse
than NixOS' system generations, but it seems like an OK trade-off for the flexibility of modifying the system on the
fly.

◊h2{The Process}

Booting the Arch Linux live image, the first thing I did was connect to the internet. Arch provides ◊code{iwd}, but
I always forget how to use it since I usually prefer Network Manager, so just a reminder:

◊code-block{
# iwctl
[iwd]# station <name like wlan0> scan
[iwd]# station <name> get-networks
[iwd]# station <name> connect <ssid>
}

◊code{scan} and ◊code{get-networks} can be skipped by tab-completing ◊code{station <name> connect}.

◊h3{Partition and Format the Disks}

Next, I partitioned the hard drive with ◊code{gdisk}. EFI partition first, with default start, size ◊code{550Mb}, and
type ◊code{ef00}. Then for the main partition, it can take up the rest of the drive, which is the default, and should be
type ◊code{8300}, also default.

I generated the key file in the same way as before. The name can be anything, though Arch has a naming convention and a
particular spot, ◊code{/etc/cryptsetup-keys.d/}, to store the key. Actually, a lot of this is the same as
◊body-link["./single_password_encrypted_nixos.html"]{last time}, but I'll briefly reproduce it here.

◊code-block{
# dd if=/dev/urandom of=./root.key bs=1024 count=4

# cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/${DISK}2
# cryptsetup luksAddKey /dev/${DISK}2 root.key
# cryptsetup luksOpen /dev/${DISK}2 root --key-file root.key

# pvcreate /dev/mapper/root
# vgcreate vg /dev/mapper/root
# lvcreate -L 8G -n swap vg
# lvcreate -l '100%FREE' -n root vg

# mkswap /dev/mapper/vg-swap
# swapon /dev/mapper/vg-swap

# mkfs.vfat -n boot /dev/${DISK}1
# mkfs.btrfs -L root /dev/mapper/vg-root

# mount /dev/mapper/vg-root /mnt
}

Then I created the subvolumes and re-mounted so the new ◊code{rootfs} subvolume is the root of the eventual Arch system.

◊code-block{
# cd /mnt
# btrfs subvolume create rootfs
# btrfs subvolume create homefs
# cd ..
# umount /mnt
# mount -o subvol=rootfs /dev/mapper/root /mnt
}

◊h3{Normal Setup}

After that I proceeded as normal to assemble the other mountpoints and followed the
◊body-link["https://wiki.archlinux.org/title/Installation_guide#Installation"]{installation guide}, picking up from the
◊code{pacstrap} step.

◊code-block{
# mkdir /mnt/home
# mount -o subvol=homefs /dev/mapper/root /mnt/home
# mkdir /mnt/efi
# mount /dev/sda1 /mnt/efi
# mkdir /mnt/boot

# pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode less man-db man-pages lvm2 btrfs-progs grub efibootmgr vim networkmanager

# cp root.key /mnt/etc/cryptsetup-keys.d
}

I called ◊code{genfstab} as normal in the guide, but I forgot to mount ◊code{/efi} with the proper permissions, so I
edited the ◊code{fstab} at this stage to add the options ◊code{uid=0,gid=0,} and change ◊code{fmask=0022,dmask=0022} to
◊code{0070} each.

The rest of the configuration and setup was the same as in the guide, until the end with the initramfs and boot loader
configs.

◊h3{Initramfs and Boot Loader}

◊code{arch-chroot}'d into ◊code{/mnt}, I changed the ◊code{FILES} and ◊code{HOOKS} lines in
◊code{/etc/mkinitcpio.conf} to the following below. For this setup, LVM-on-LUKS, ◊code{encrypt} should come before
◊code{lvm2} to decrypt the disk.

◊code-block{
FILES=(/etc/cryptsetup-keys.d/root.key)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
}

Next, I changed the following lines in ◊code{/etc/default/grub}:

◊code-block{
GRUB_CMDLINE_LINUX="cryptdevice=UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:root:allow-discards cryptkey=rootfs:/etc/cryptsetup-keys.d/root.key root=/dev/vg/root rootflags=subvol=rootfs rw intel-ucode.img"
GRUB_ENABLE_CRYPTODISK=y
}

◊ul{
  ◊li{◊code{cryptdevice}: colon-separated list of arguments; first the disk partition (use a persistent name like UUID),
    then the name of the decrypted partition, then disk options (◊code{allow-discards} enables TRIM)}
  ◊li{◊code{cryptkey}: path to the key file of the ◊code{cryptdevice} in the format ◊code{<disk>:<path>}; ◊code{rootfs}
    refers to the initramfs image, so in this case the path should be the same as in the ◊code{FILES} line in
    ◊code{/etc/mkinitcpio.conf}}
  ◊li{◊code{root}: the path of the mapped volume after LVM is activated; since I used a volume group it must be
    specified in the path}
  ◊li{◊code{rootflags}: any flags that would be passed to ◊code{mount} manually; in this case I specified the subvolume
    ◊code{rootfs}}
  ◊li{◊code{rw}: kernel-default read-write mode for the root device}
  ◊li{◊code{intel-ucode.img}: additional cpu microcode image}
}

When in doubt, the wiki pages for
◊body-link["https://wiki.archlinux.org/title/Dm-crypt/Device_encryption#With_a_keyfile_embedded_in_the_initramfs"]{device encryption}
and
◊body-link["https://wiki.archlinux.org/title/Dm-crypt/System_configuration#Kernel_parameters"]{encrypted system configuration}
are authoritative.

Then I generated the initramfs image, configured GRUB, and set the root password:

◊code-block{
# mkinitcpio -P
# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
# grub-mkconfig -o /boot/grub/grub.cfg

# passwd
}

◊h3{Finish and Reboot}

With the installation complete, I rebooted into the new system and finished setting it up. I'll leave that for another
time, as many people have different preferences, but if you're totally new I'd start with the
◊body-link["https://wiki.archlinux.org/title/General_recommendations"]{general recommendations}.
