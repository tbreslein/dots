package main

import (
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/joho/godotenv"
)

type (
	Config struct {
		roles   map[string]struct{}
		host    string
		uname   string
		path    string
		colours string
		home    string
		dots    string
		stows   string
		state   string
		repos   []string
		brew    []string
		pacman  []string
		aur     []string
		apt     []string
	}
)

var (
	Reset        = "\033[0m"
	Red          = "\033[31m"
	Green        = "\033[32m"
	Yellow       = "\033[33m"
	Blue         = "\033[34m"
	Purple       = "\033[35m"
	Cyan         = "\033[36m"
	Gray         = "\033[37m"
	White        = "\033[97m"
	BrightRed    = "\033[1;31m"
	BrightGreen  = "\033[1;32m"
	BrightYellow = "\033[1;33m"
	BrightBlue   = "\033[1;34m"
	BrightPurple = "\033[1;35m"
	BrightCyan   = "\033[1;36m"
	BrightGray   = "\033[1;37m"
	BrightWhite  = "\033[1;97m"
	CONFIG       Config
)

func init() {
	bin_path, err := os.Executable()
	if err != nil {
		log.Fatalf("unable to locate executable: %s", err)
	}
	bin_path = filepath.Dir(bin_path)

	err = godotenv.Load(filepath.Join(bin_path, ".env"))
	if err != nil {
		log.Fatalf("Error loading .env file: %s", err)
	}

	roles := make(map[string]struct{})
	for _, r := range strings.Split(os.Getenv("ROLES"), " ") {
		roles[r] = struct{}{}
	}

	host := os.Getenv("_HOST")
	home := os.Getenv("HOME")
	dots := filepath.Join(home, "dots")

	pacman, aur := arch(&roles, &host)
	CONFIG = Config{
		roles:   roles,
		host:    host,
		uname:   os.Getenv("UNAME"),
		path:    os.Getenv("PATH"),
		colours: os.Getenv("COLOURS"),
		home:    home,
		dots:    dots,
		stows:   filepath.Join(dots, "stows"),
		state:   filepath.Join(dots, "state"),
		repos:   strings.Split(os.Getenv("REPOS"), " "),
		brew:    brew(),
		pacman:  pacman,
		aur:     aur,
		apt:     []string{"syncthing", "git", "vim"},
	}
}

// self.command: str = ""
