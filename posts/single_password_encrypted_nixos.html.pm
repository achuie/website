#lang pollen

◊h1{Single-Password Encrypted NixOS}

I recently installed NixOS on my home workstation. It's root-on-BTRFS with home-on-ZFS, mainly because I didn't want to
deal with swap on ZFS and the root SSD would have been a separate pool anyway, so I figured I might as well go with
BTRFS+LUKS-on-LVM to try out all the new-to-me technologies at once. I searched extensively for guides and other
troubleshooting threads prior to installing, and I found some pretty good ones

◊h2{TL;DR}

The code is ◊body-link[https://github.com/achuie/dotfiles/tree/master/nix-flakes/firacode]{here}, and can be built with
the following command if one has Nix installed:
◊shell-cmd{nix build github:achuie/dotfiles?dir=nix-flakes/firacode}


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
