# dots

My dotfiles using ansible and stow, where the ansible bits are used by my Fedora workstations, `audron` and `moebius`.

To deploy:

- make sure these options are set to the btrfs partitions in fstab:
  - ssd,noatime,discard=async,compress=zstd:1
  - make sure that `discard` is passed to `/etc/crypttab` too
  - reload daemon files with: `sudo systemctl daemon-reload`
- clone this repo
- activate RPM Fusion, and install something from those repos so that the RPM fusion gpg keys can be accepted (in this example: megasync).
  Then install `ansible`, and run the playbook.

```bash
sudo dnf update
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install megasync
sudo ansible-playbook "$(cat /etc/hostname)-init.yml --ask-vault-pass"
```

## TODO

- playerctl & volume control keybinds
- my repos
- LSPs, linters, etc.
- hyprland config
- fprintd
- eww
- DVORAK
