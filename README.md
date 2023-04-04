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

### First boot

```bash
useradd -m -G wheel aur_builder
passwd aur_builder
vim /etc/sudoers.d/11-install-aur_builder
# insert: aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman

su aur_builder
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
  - binds for playerctl, light, and wpctl
- LSPs, linters, etc.
- fprintd
- eww
