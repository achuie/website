#lang pollen

◊h1{Single-Password Encrypted NixOS}

I recently installed NixOS on my home workstation/server. I've only put /home on ZFS instead of going full root on ZFS,
mainly because I didn't want to deal with swap on ZFS and the root SSD would have been the odd drive out in a ZFS mirror
anyway, so I figured I might as well go with BTRFS+LUKS-on-LVM to try out all the new-to-me technologies at once. I
searched extensively for guides and other troubleshooting threads prior to installing, and I found some pretty
◊body-link[
    "https://blog.kolaente.de/2021/11/installing-nixos-with-encrypted-btrfs-root-device-and-home-manager-from-start-to-finish/"
]{good}
◊body-link["https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f"]{ones}.


◊;;NOTES

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
