# dots

## Fedora

My dotfiles using ansible and stow, where the ansible bits are used by my Fedora workstations, `audron` and `moebius`.

To deploy:

- make sure these options are set to the btrfs partitions in fstab:
  - `ssd,noatime,discard=async,compress=zstd:1`
  - make sure that `discard` is passed to `/etc/crypttab` too
  - reload daemon files with: `sudo systemctl daemon-reload`
- install brave according to the install instructions outlined on the brave website
- clone this repo
- activate RPM Fusion, and install something from those repos so that the RPM fusion gpg keys can be accepted (in this example: megasync).
  Then install `ansible`, and run the playbook.
- install `rustup` components

```bash
sudo dnf update
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install megasync
sudo ansible-playbook "$(cat /etc/hostname)-init.yml --ask-vault-pass"

# resource your shell, then:
rustup default stable
rustup toolchain install nightly
```

## Arch

### Base install

Follow base install guide.
When partitioning, make one 512M EFI partition (fdisk type 1), and a Linux Filesystem (fdisk type 20) for the rest of the disk.

Then, format the partitions:

```bash
mfks.fat -F32 /path/to/partition1
mkfs.btrfs /path/to/partition2
```

When using LUKS, now would be the time to format the second partition into a LUKS crypt instead of the btrfs.
After the cryptformat, format the mapped device as btrfs and continue.

```bash
# mount device and create subvolumes
mount /path/to/btfs/part /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@snapshots

# unmount and remount with mount options
umount /mnt
mount -o defaults,ssd,noatime,discard=async,compress=zstd,commit=120,subvol=@ /path/to/partition2 /mnt
mkdir -p /mnt/{home,tmp,log,.snapshots,boot}
mount -o defaults,ssd,noatime,discard=async,compress=zstd,commit=120,subvol=@home /path/to/partition2 /mnt/home
mount -o defaults,ssd,noatime,discard=async,compress=zstd,commit=120,subvol=@log /path/to/partition2 /mnt/log
mount -o defaults,ssd,noatime,discard=async,compress=zstd,commit=120,subvol=@tmp /path/to/partition2 /mnt/tmp
mount -o defaults,ssd,noatime,discard=async,compress=zstd,commit=120,subvol=@snapshots /path/to/partition2 /mnt/.snapshots
mount /path/to/partition1 /mnt/boot

# bootstrap the system
pacstrap /mnt base base-devel linux linux-firmware vim networkmanager btrfs-progs zsh sudo polkit !!amd-ucode OR intel-ucode!!
genfstab -U /mnt >> /mnt/etc/fstab
vim /mnt/etc/fstab # check for errors

arch-chroot /mnt
hwclock --systohc # this assumes that the system clock is UTC
vim /etc/locale.gen # uncomment en_US.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost localhost.localdomain" >> /etc/hosts
echo "::1       localhost localhost.localdomain" >> /etc/hosts
echo "127.0.1.1 HOSTNAME HOSTNAME.localdomain" >> /etc/hosts
systemctl enable NetworkManager
passwd # root password

pacman -Syu grub efibootmgr os-prober ntfs-3g
vim /etc/default/grub # uncomment GRUB_DISABLE_OS_PROBER=false
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg # last time I had to boot into Arch once because the USB drive stopped os-prober
```

### First boot

```bash
useradd -m -G tommy -s/bin/zsh
passwd tommy

useradd -m -G wheel kain
passwd kain
vim /etc/sudoers.d/11-install-kain
# insert: kain ALL=(ALL) NOPASSWD: /usr/bin/pacman

su kain
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepgk -si
exit

sudo pacman -S --needed ansible
ansible-galaxy collection install -r requirements.yml

sudo ansible-playbook "$(cat /etc/hostname)"-init.yml --ask-vault-pass
```

## TODO

- hyprland config:
  - add auto-start for polkit-kde-agent (see [Link](https://wiki.hyprland.org/Useful-Utilities/Must-have/)
  - mouse cursor config: [Link](https://wiki.hyprland.org/FAQ/#how-do-i-change-me-mouse-cursor)
- LSPs, linters, etc.
- fprintd
- eww
