# dots

My dotfiles using ansible and stow, where the ansible bits are used by my Fedora workstations, `audron` and `moebius`.

To deploy, clone this repo, and activate RPM Fusion, and install something from those repos so that the RPM fusion gpg keys can be accepted (in this example: megasync).
Then install `ansible`, and run the playbook.

```bash
sudo dnf update
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install megasync
sudo ansible-playbook "$(cat /etc/hostname).yml"
```

## TODO

- wlsunset
- kanshi
- playerctl & volume control keybinds
- screenlock
- my repos
- LSPs, linters, etc.
- sway keybinds
- fprintd
- eww
