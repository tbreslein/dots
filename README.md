# dots

## Setup: moebius (desktop arch) and audron (laptop arch)

### partitioning / formatting

- part1: 1G EFI
- part2: rest

setting up partitions (let X be the device we're installing linux to):

```sh
fdisk -l # set up partitions

mkfs.vfat -F32 -n EFI /dev/X1

cryptsetup luksFormat /dev/X2
cryptsetup open /dev/X2 cryptroot
mkfs.btrfs -L ROOT /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@swap
btrfs sub create /mnt/@home
btrfs sub create /mnt/@var
umount /mnt

mount -o noatime,nodiratime,compress=zstd,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{boot,home,var,swap}
mount -o noatime,nodiratime,compress=zstd,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,ssd,subvol=@var /dev/mapper/luks /mnt/var
mount -o noatime,nodiratime,compress=zstd,ssd,subvol=@swap /dev/mapper/luks /mnt/swap
mount /dev/X1 /mnt/boot

# the size should be proportional to the ram size
btrfs filesystem mkswapfile --size 32g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
```

bootstrapping:

```sh
# amd-ucode needs to be intel-ucode for intel CPUs
pacstrap /mnt linux linux-firmware base base-devel btrfs-progs efibootmgr amd-ucode networkmanager sudo git vim just
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

basic config:

```sh
ln -sf /usr/share/zoneinfo/Europe/Berlin
hwclock --hctosys
vim /etc/systemd/timesyncd.conf
# [TIME]
# NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
# Fallback=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
systemctl enable systemd-timesyncd.service

vim /etc/locale.gen
# uncomment en_US.UTF-8 and de_DE.UTF-8
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

vim /etc/hostname
# just enter the hostname

vim /etc/hosts
# 127.0.0.1 localhost
# ::1       localhost

vim /etc/mkinitcpio.conf
# add btrfs before filesystems and add resume after it
# example:
# HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block btrfs filesystems resume fsck)
mkinitcpio -p linux

passwd

useradd -G wheel,audio,video -m -s/bin/bash tommy
passwd tommy

# efi scripts...

exit
swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close
```

setup efistub:

### links:

- https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/
- https://gist.github.com/noghartt/8388f7d8543e3eb1777cb6ed4a3d7807
- https://root.nix.dk/en/manjaro-cli-install/systemd-boot-luks-btrfs
- https://infertux.com/posts/2023/05/05/how-to-install-linux-systemd-boot-btrfs-luks-together/
- https://btrfs.readthedocs.io/en/latest/Introduction.html

although I might use a simple efistub and stop bothering myself bootloaders:

- https://www.reddit.com/r/archlinux/comments/11aqxnk/install_with_luks_btrfs_efistub_sdencrypt/
- https://linustechtips.com/topic/1490301-arch-install-with-luks-btrf-efistub-and-sd-encrypt-hook/
- https://gist.github.com/jirutka/a914c442f42f78a8a22847d57ba3900d
- https://wiki.archlinux.org/title/EFISTUB

## Setup: macbook

## Setup: moebius-win (wsl)

## Setup: vorador (raspberry pi)

## Just use simple tools

This repo contains my dotfiles and scripts to setup my systems.
At its core is simply a little justfile script that controls everything.
The idea is to use simple tools (only justfile, stow, and pacman/yay/homebrew),
and don't use tools that put on layers upon layers of abstraction upon how the
system is configured.

Just as a reminder to my future self, as to why I no longer use nix(OS) for
package management / system configuration / as an operating system:

- nixOS + home-mananager couples your system configuration and upgrades, to your
  program configuration, and that's BS because you cannot tweak your config if
  your system cannot upgrade (whether that's because something broke upstream,
  or because SOPHOS decides that compiling a program from source should take
  30 minutes instead of 30 seconds)
- it puts a layer on top of system and tool configuration that makes it less
  clear how that configuration actually works, and this lack of clarity and
  knowledge makes it harder to analyse and fix errors
- I don't need a programming language to configure my system

I also used ansible in the past, but the fact that it is a) slow, b) isn't
declarative (otherwise the order of your tasks wouldn't matter), and c) forces
me to have way more structure than I need, makes using it a chore more than
anything else.
