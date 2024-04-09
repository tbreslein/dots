package main

var brew_base = []string{
	// core
	"tap \"homebrew/bundle\"",
	"tap \"hombrew/cask-fonts\"",
	"tap \"jstkdng/programs\"",
	"brew \"coreutils\"",
	"brew \"gnu-sed\"",
	"brew \"bash\"",
	"brew \"bash-completion@2\"",
	"brew \"syncthing\", restart_service: true",

	// qmk
	"tap \"qmk/qmk\"",
	"brew \"qmk/qmk/qmk\"",
	"tap \"osx-cross/arm\"",
	"tap \"osx-cross/avr\"",

	// tools, code, terminal
	"brew \"neovim\", args: [\"HEAD\"]",
	"brew \"tmux\"",
	"brew \"tree\"",
	"brew \"tldr\"",
	"brew \"htop\"",
	"brew \"jq\"",
	"brew \"fd\"",
	"brew \"ripgrep\"",
	"brew \"eza\"",
	"brew \"bat\"",
	"brew \"git\"",
	"brew \"git-delta\"",
	"brew \"rm-improved\"",
	"brew \"direnv\"",
	"brew \"tokei\"",
	"brew \"hyperfine\"",
	"brew \"just\"",
	"brew \"starship\"",
	"brew \"fastfetch\"",
	"brew \"editorconfig\"",

	// yazi
	"brew \"yazi\"",
	"brew \"ffmpegthumbnailer\"",
	"brew \"unar\"",
	"brew \"poppler\"",
	"brew \"zoxide\"",

	// GUI
	"cask \"wezterm\"",
	"cask \"amethyst\"",
	"cask \"telegram-desktop\"",
}

func brew() []string {
	return brew_base
}
