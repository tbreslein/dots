package main

var (
	pacman_base = []string{
		// system
		"base",
		"base-devel",
		"linux",
		"linux-firmware",
		"sudo",
		"man-db",
		"man-pages",

		// networking
		"networkmanager",
		"openssh",
		"ufw",
		"wget",
		"curl",

		// utils
		"moreutils",
		"git",
		"less",
		"tree",
		"sed",
		"awk",
		"parallel",
		"p7zip",
		"texinfo",
		"syncthing",
		"vim",
		"eza",
		"fd",
		"ripgrep",
		"bat",
		"fzf",
		"lazygit",
		"yazi",
		"jq",
		"just",
		"starship",
		"fastfetch",
		"tldr",
		"htop",
		"tmux",

		// compilers
		"gcc",
		"cmake",
	}

	aur_base = []string{
		"ueberzugpp",
		"rm-improved",
	}

	pacman_code = []string{
		"direnv",
		"editorconfig-core-c",
		"git-delta",
		"hyperfine",
		"tokei",
	}

	aur_code = []string{
		"neovim-git",
	}

	pacman_desktop = []string{
		"imv",
		"mpv",
		"wezterm",
		"wezterm-terminfo",
		"vlc",
		"thunar",
		"obsidian",
		"ttf-hack-nerd",
		"telegram-desktop",
		"grub",
		"grub-btrfs",
		"efibootmgr",
		"btrfs-progs",
		"snapper",
		"network-manager-applet",
		"hyprland",
		"hyprpaper",
		"hypridle",
		"hyprlock",
		"xdg-desktop-portal-hyprland",
		"bemenu-wayland",
		"wl-clipboard",
		"wlsunset",
		"grim",
		"slurp",
		"dunst",
		"libnotify",
		"waybar",
		"playerctl",
		"pavucontrol",
		"brightnessctl",
		"polkit-kde-agent",
		"blueman",
		"qt5-wayland",
		"qt6-wayalnd",
		"pipewire",
		"wireplumber",
		"pipewire-alsa",
		"pipewire-jack",
		"pipewire-pulse",
		"greetd",
		"zathura",
		"zathura-ps",
		"zathura-pdf-mupdf",
		"noto-fonts",
		"noto-fonts-cjk",
		"noto-fonts-emoji",
		"noto-fonts-extra",
	}

	aur_desktop = []string{
		"webcord",
		"hyprshot",
		"satty-bin",
		"wdisplays",
		"proton-ge-custom-bin",
		"brave-bin",
		"microsoft-edge-stable-bin",
	}
	pacman_laptop = []string{"tlp"}
	aur_laptop    = []string{}
	pacman_gaming = []string{
		"steam",
		"gamemode",
		"lib32-gamemode",
	}
	aur_gaming     = []string{}
	pacman_moebius = []string{
		"os-prober",
		"mesa",
		"vulkan-radeon",
		"libva-mesa-driver",
		"mesa-vdpau",
		"lib32-mesa",
		"lib32-vulkan-radeon",
		"lib32-libva-mesa-driver",
		"lib32-mesa-vdpau",
	}
	aur_moebius        = []string{}
	pacman_audron      = []string{}
	aur_audron         = []string{}
	pacman_moebius_win = []string{}
	aur_moebius_win    = []string{}
)

func arch(roles *map[string]struct{}, host *string) ([]string, []string) {
	pacman := pacman_base
	aur := aur_base

	if _, ok := (*roles)["code"]; ok {
		pacman = append(pacman, pacman_code...)
		aur = append(aur, aur_code...)
	}
	if _, ok := (*roles)["desktop"]; ok {
		pacman = append(pacman, pacman_desktop...)
		aur = append(aur, aur_desktop...)
	}
	if _, ok := (*roles)["laptop"]; ok {
		pacman = append(pacman, pacman_laptop...)
		aur = append(aur, aur_laptop...)
	}
	if _, ok := (*roles)["gaming"]; ok {
		pacman = append(pacman, pacman_gaming...)
		aur = append(aur, aur_gaming...)
	}

	switch *host {
	case "moebius":
		pacman = append(pacman, pacman_moebius...)
		aur = append(aur, aur_moebius...)
	case "auron":
		pacman = append(pacman, pacman_audron...)
		aur = append(aur, aur_audron...)
	case "moebius-win":
		pacman = append(pacman, pacman_moebius_win...)
		aur = append(aur, aur_moebius_win...)
	}

	return pacman, aur
}
