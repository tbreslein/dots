package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

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

	// Getting and using a value from .env
	roles := os.Getenv("ROLES")

	fmt.Println(roles)
}
