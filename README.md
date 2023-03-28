# dots

My dotfiles using ansible and stow, where the ansible bits are used by my Fedora workstations, `audron` and `moebius`.

To deploy, clone this repo, install `ansible`, and run the playbook.

```bash
sudo ansible-playbook "$(cat /etc/hostname).yml"
```
