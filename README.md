# dots

## Setup: moebius (desktop arch) and audron (laptop arch)

### part 0: prep

```sh
iwctl device list # from now on, assume wlan0 is the wifi device
iwctl station wlan0 scan
iwctl station wlan0 get-networks # grab your network SSID
iwctl station wlan0 connect "YOUR WIFI SSID" -P "wifi passphrase"

timedatectl set-ntp true
timedatectl set-timezone Europe/Berlin

export disk=/dev/nvme0n1 # or whatever your device is

# if you are reinstalling, wipe the disk and fill with random data
wipefs -af $disk
sgdisk --zap-all --clear $disk
partprobe $disk # should return errorcode 0
cryptsetup open --type plain -d /dev/urandom $disk target
# NOTE: cryptsetup already provided the randomness, so dd can just read from /dev/zero
dd if=/dev/zero of=/dev/mapper/target bs=1M status=progress oflag=direct
cryptsetup close target
```

### partitioning / formatting

```sh
# create a 512MB efi partition, and a luks partition for the rest of the system
sgdisk -n 0:0:+512MiB -t 0:ef00 -c 0:esp $disk
sgdisk -n 0:0:0 -t 0:8309 -c 0:luks $disk
partprobe $disk

# check the partition table
sgdisk -p $disk

# open the crypt
# NOTE: the p2 only works on NVME devices, otherwise you need to use ${disk}2
cryptsetup --type luks1 -v -y luksFormat ${disk}p2

# format
cryptsetup open ${disk}p2 crypt
mkfs.vfat -F32 -n ESP ${disk}p1
mkfs.btrfs -L archlinux /dev/mapper/crypt

mount /dev/mapper/crypt /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@libvirt
btrfs subvolume create /mnt/@swap

export sv_opts="rw,noatime,nodiratime,ssd,compress-force=zstd:1,space_cache=v2"

mount -o ${sv_opts},subvol=@ /dev/mapper/crypt /mnt
mkdir -p /mnt/{boot,home,swap,.snapshots,var/{cache,log,tmp,lib/libvirt}}
mount -o ${sv_opts},subvol=@home /dev/mapper/crypt /mnt/home
mount -o ${sv_opts},subvol=@swap /dev/mapper/crypt /mnt/swap
mount -o ${sv_opts},subvol=@snapshots /dev/mapper/crypt /mnt/.snapshots
mount -o ${sv_opts},subvol=@cache /dev/mapper/crypt /mnt/var/cache
mount -o ${sv_opts},subvol=@log /dev/mapper/crypt /mnt/var/log
mount -o ${sv_opts},subvol=@tmp /dev/mapper/crypt /mnt/var/tmp
mount -o ${sv_opts},subvol=@libvirt /dev/mapper/crypt /mnt/var/lib/libvirt
mount ${disk}p1 /mnt/boot

# the size should be proportional to the ram size
btrfs filesystem mkswapfile --size 32g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
```

### system bootstrap

```sh
pacman -Syy
export microcode="amd-ucode" # or intel-ucode respectively
reflector --verbose --protocol https --latest 5 --sort rate --country Germany --country Canada --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel $microcode btrfs-progs linux linux-firmware cryptsetup htop man-db neovim vim networkmanager openssh pacman-contrib pkgfile reflector sudo tmux zsh
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
```

in the chroot:

```sh
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --hctosys # when you don't need to install windows, to --systohc instead?

# assume "foobar" is the name you want your machine to have
echo "foobar" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 foobar.localdomain foobar
EOF

nvim /etc/systemd/timesyncd.conf
# [TIME]
# NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
# FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
systemctl enable systemd-timesyncd.service

export locale="en_US.UTF-8"
sed -i "s/^#\(${locale}\)/\1/" /etc/locale.gen
grep "$locale" /etc/locale.gen # check that you didn't typo the sed command
echo "LANG=${locale}" > /etc/locale.conf
locale-gen

echo "EDITOR=nvim" > /etc/environment && echo "VISUAL=nvim" >> /etc/environment

passwd # root password
useradd -m -G wheel -s /bin/zsh tommy
passwd tommy

sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

systemctl enable NetworkManager

vim /etc/mkinitcpio.conf
# # first, add btrfs to MODULES
# MODULES=(btrfs)
# # then, add encrypt hook before filesystems, and resume after it
# HOOKS=(base udev ... consolefont block encrypt filesystems resume fsck)
mkinitcpio -P

pacman -S grub efibootmgr
__blkid=$(blkid -s UUID -o value ${disk}p2)
echo "${__blkid}" >> /etc/default/grub
vim /etc/default/grub
# # move the blkid to the GRUB_CMDLINE_LINUX_DEFAULT so that it looks like:
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=YOUR_BLKID:crypt:allow-discards"
# # for example, if the blkid was 3456sdg-j4j4-234a-jkl3-45fsajl8, then the line should read:
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=3456sdg-j4j4-234a-jkl3-45fsajl8:crypt:allow-discards"

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
efibootmgr # check that the GRUB entry has been created
grub-mkconfig -o /boot/grub/grub.cfg

exit
swapoff -a
umount -R /mnt
reboot
```

### first boot

login into user

```sh
nmtui # setup wifi
sudo vim /etc/pacman.conf # enable verbosepkgslist, paralleldownloads, color, and multilib
sudo pacman -Syu
sudo systemctl enable fstrim.timer
sudo vim /etc/xdg/reflector/reflector.conf # set countries to France,Germany
sudo systemctl enable reflector.service
sudo systemctl start reflector.service
sudo systemctl enable reflector.timer
sudo systemctl start reflector.timer

sudo pacman -S git
cd
git clone https://github.com/tbreslein/dots.git
~/dots/dm/bootstrap.bash

reboot # just see that everything works and that wifi connects automatically
```

```sh
~/dots/dm/dm stow nix pkgs

# re-login, then startx, setup brave, extensions, bitwarden, syncthing...
dm # sync
```

### first snapshot

when everything is up and running, it's time to configure btrfs snapshots

```sh
sudo pacman -S snapper snap-pac

# snapper assumes that the snapshots subvolume is not mounted when creating the
# config
sudo umount /.snapshots
sudo rm -fr /.snapshots # BE VERY CAREFUL NOT TO MISTYPE THIS ONE!
sudo snapper -c root create-config /

sudo btrfs subvolume list /
# as you can see, it created a new subvolume called .snapshots, but we want our
# subvolume from earlier
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount /.snapshots # mount config still exists if /etc/fstab after all
sudo chmod 750 /.snapshots
sudo chown :wheel /.snapshots

# create the first snapshot
sudo snapper -c root create -d "**BASE INSTALL**"

sudo vim /etc/snapper/configs/root
# ALLOW_USERS="tommy"
# ...
# TIMELINE_MIN_AGE="1800"
# TIMELINE_LIMIT_HOURLY="5"
# TIMELINE_LIMIT_DAILY="7"
# TIMELINE_LIMIT_WEEKLY="0"
# TIMELINE_LIMIT_MONTHLY="0"
# TIMELINE_LIMIT_YEARLY="0"

sudo systemctl enable snapper-timeline.timer
sudo systemctl enable snapper-cleanup.timer

# EXAMPLES
snapper -c root list # list all current snapshots

sudo pacman -S md-tui

# should now list a pre and post snapshot for the pacman command, thanks to the
# snap-pac pacman hooks
snapper -c root list

sudo btrfs subvolume list / # now also lists our snapshots
```

now, set up grub-btrfs

```sh
sudo pacman -S grub-btrfs

# in case your grub config does not live in /boot/grub...
sudo vim /etc/default/grub-btrfs/config
# #edit GRUB_BTRFS_GRUB_DIRNAME to point at the correct directory

# this enables automatically adding snapshots to the boot menu
sudo systemctl enable --now grub-btrfsd.service
```

### in case of emergency

when you cannot boot into your system due to an update and want to roll back,
boot into an old snapshot using grub and see if it works.
Take note of the snapshot number, you need it for later!

Then boot into a live usb and...

```sh
cryptsetup open /dev/nvme1n1p2 crypt

# mount WITHOUT the @
mount -t btrfs -o subvol=/ /dev/mapper/crypt /mnt

# check whether any snapper-unit.timer services are running and stop them!

# move the broken subvolume out of the way (that's why we didn't include the @)
mv /mnt/@ /mnt/@borked

# search for the snapshot you wanted to boot into in /.snapshots/
# you can look through their info.xml files to find the snapshot you are looking
# for, if you didn't remember the snapshot number from earlier.
# let's say the snapshot number is 69

# snapshot that snapshot into place
btrfs subvolume snapshot /mnt/@snapshots/69/snapshot /mnt/@

umount -R /mnt
reboot

# and after the reboot, if everything worked, remember to remove @borked
```

## links:

### setup with grub

- https://www.dwarmstrong.org/archlinux-install/

### setup with systemdboot

- https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/
- https://gist.github.com/noghartt/8388f7d8543e3eb1777cb6ed4a3d7807
- https://root.nix.dk/en/manjaro-cli-install/systemd-boot-luks-btrfs
- https://infertux.com/posts/2023/05/05/how-to-install-linux-systemd-boot-btrfs-luks-together/
- https://btrfs.readthedocs.io/en/latest/Introduction.html

### setup with efistub

- https://www.reddit.com/r/archlinux/comments/11aqxnk/install_with_luks_btrfs_efistub_sdencrypt/
- https://linustechtips.com/topic/1490301-arch-install-with-luks-btrf-efistub-and-sd-encrypt-hook/
- https://gist.github.com/jirutka/a914c442f42f78a8a22847d57ba3900d
- https://wiki.archlinux.org/title/EFISTUB

## Setup: macbook

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
