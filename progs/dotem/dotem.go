package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"codeberg.org/tbreslein/dots/progs/dotem/config"
	"github.com/joho/godotenv"
)

func main() {
	bin_path, err := os.Executable()
	if err != nil {
		log.Fatalf("unable to locate executable: %s", err)
	}
	bin_path = filepath.Dir(bin_path)

	err = godotenv.Load(filepath.Join(bin_path, ".env"))
	if err != nil {
		log.Fatalf("Error loading .env file: %s", err)
	}

	config := config.Config{Roles: os.Getenv("ROLES")}

	fmt.Println(config)
}
