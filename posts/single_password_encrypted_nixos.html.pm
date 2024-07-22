#lang pollen

◊h1{Single-Password Encrypted NixOS}

I recently installed NixOS on my home workstation/server. I've only put ◊code{/home} on ZFS instead of going full root
on ZFS, mainly because I didn't want to deal with swap on ZFS and the root SSD would have been the odd drive out in a
ZFS mirror anyway, so I figured I might as well go with BTRFS+LUKS-on-LVM to try out all the new-to-me technologies at
once. I found some ◊body-link["https://astrid.tech/2021/12/17/0/two-disk-encrypted-zfs/"]{pretty} ◊body-link[
  "https://blog.kolaente.de/2021/11/installing-nixos-with-encrypted-btrfs-root-device-and-home-manager-from-start-to-finish/"
]{good} ◊body-link["https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f"]{guides}, but there were some steps
that were different so I wanted to write down what I did for future reference.

◊h2{Installation Media}

As always, we start by creating a bootable disk. Below is my normal go-to:

◊code-block{
# dd bs=4M if=path/to/nixos-minimal-version-x86_64-linux.iso of=/dev/disk/by-id/usb-My_flash_drive
conv=fsync oflag=direct status=progress
}

◊h2{Formatting the Drives}

Boot from the disk we just created. Ethernet should already be set up, but wifi requires extra steps:

◊code-block{
# wpa_passphrase $SSID $PASSWORD >/etc/wpa_supplicant.conf \\
# systemctl start wpa_supplicant
}

Identify your drives (◊code{fdisk -l}), and start with what will be the OS drive. Run ◊code{gdisk} on it, no partition
numbers since we'll be using the whole drive.

◊code-block{# gdisk /dev/$DISK}

Instead of the normal ◊code{/boot} partition, we'll create a partition for just the EFI bootloaders mounted at
◊code{/boot/efi}. That way we can keep the kernel images encrypted.


◊h6{---

NOTES}

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
