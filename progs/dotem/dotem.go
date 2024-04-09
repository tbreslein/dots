package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

type Command string

var current_command Command

const (
	sync  = Command("sync")
	stow  = Command("stow")
	pkgs  = Command("pkgs")
	nvim  = Command("nvim")
	nix   = Command("nix")
	repos = Command("repos")
)

func main() {
	commands := []Command{}
	for _, arg := range os.Args[1:] {
		commands = append(commands, Command(arg))
	}

	if len(commands) == 0 {
		commands = append(commands, "sync")
	} else {
	}
	for _, arg := range commands {
		switch arg {
		case "stow":
			run_stow()
		case "repos":
			run_repos()
		case "pkgs":
			run_pkgs()
		case "nix":
			run_nix()
		case "nvim":
			run_nvim()
		case "sync":
			run_sync()
		}
	}
}

func _log(msg *string, label string, colour *string) {
	const dotem_string = "dotem"
	const print_len = len(dotem_string) + 6
	foo := ""
	if len(current_command) == 0 {
		foo = "dm"
	} else {
		foo = fmt.Sprint(dotem_string, ":", current_command)
	}
	foo_len := len(foo)
	if foo_len < print_len {
		for i := 0; i < print_len-foo_len; i++ {
			foo += " "
		}
	}
	fmt.Println(*colour, "[", foo, "] ", label, "| ", Reset, *msg)
}

func info(a ...any) {
	msg := fmt.Sprint(a...)
	_log(&msg, "INFO   ", &BrightBlue)
}

func warn(a ...any) {
	msg := fmt.Sprint(a...)
	_log(&msg, "WARN   ", &BrightYellow)
}

func error(a ...any) {
	msg := fmt.Sprint(a...)
	_log(&msg, "ERROR  ", &BrightRed)
}

func success(a ...any) {
	msg := fmt.Sprint(a...)
	_log(&msg, "SUCCESS", &BrightGreen)
}

func init_cmd() {
	pc, _, _, ok := runtime.Caller(1)
	details := runtime.FuncForPC(pc)
	name := ""
	if ok && details != nil {
		name = details.Name()
		index := strings.LastIndex(name, ".")
		if index >= 0 {
			name = name[index+1:]
		}
	}

	if len(name) > 4 {
		current_command = Command(name[4:])
	}

	info("starting ", current_command)
}

func run_stow() {
	init_cmd()
	git_status := exec.Command("git", "status", "--porcelain")
	git_status.Dir = CONFIG.dots
	if out, err := git_status.Output(); len(out) > 0 || err != nil {
		error("Cannot run stow in dirty worktrees.")
		os.Exit(1)
	}

	stows := CONFIG.roles
	stows[CONFIG.host] = struct{}{}
	stows["all"] = struct{}{}
	stows[filepath.Join("colours", CONFIG.colours)] = struct{}{}

	for s := range stows {
		stow_dir := filepath.Join(CONFIG.stows, s)
		if _, err := os.Stat(stow_dir); err != nil {
			error(err)
			os.Exit(1)
		}
		stow_cmd := exec.Command(
			"stow",
			"--no-folding",
			"--adopt",
			"-t",
			CONFIG.home,
			"-d",
			stow_dir,
			".",
		)
		stow_cmd.Dir = CONFIG.dots
		if out, err := stow_cmd.Output(); err != nil {
			error("Stdout: ", string(out[:]), "Stderr: ", err)
			os.Exit(1)
		}
	}

	git_restore := exec.Command("git", "restore", ".")
	git_restore.Dir = CONFIG.dots
	if _, err := git_restore.Output(); err != nil {
		error(err)
	}

	nvim_dir := filepath.Join(CONFIG.config, "nvim")
	if _, err := os.Stat(nvim_dir); err != nil {
		nvim_link_cmd := exec.Command(
			"ln",
			"-s", filepath.Join(CONFIG.dots, "nvim"),
			CONFIG.config,
		)
		if _, err := nvim_link_cmd.Output(); err != nil {
			error(err)
		}
	}

	success("finished!")
}

type Proc struct {
	cmd    *exec.Cmd
	stdout io.ReadCloser
	stderr io.ReadCloser
	error  any
}

func run_repos() {
	init_cmd()
	if _, ok := CONFIG.roles["code"]; !ok {
		warn("Host does not have the \"code\" role; skipping")
		return
	}
	processes := make([]Proc, len(CONFIG.repos))
	foo, _ := exec.Command("whoami").Output()
	fmt.Print(string(foo))
	for i, repo := range CONFIG.repos {
		info("syncing repo: ", repo)
		name_start := strings.LastIndex(repo, "/") + 1
		name_end := strings.LastIndex(repo, ".")
		folder := filepath.Join(CONFIG.home, "code", repo[name_start:name_end])
		if _, err := os.Stat(folder); err != nil {
			// damn, there's a lot shit to do to do this correctly.
			// Unfortunately, just running git clone on an ssh address in these
			// commands does not read my ssh key properly, so I have to to this
			// weird workaround, where I clone via the https address, and then
			// change the remote.
			clone_cmd_string := "git clone " + repo + " " + folder + "; cd " + folder + ";"
			remove_remote_cmd_string := "git remote remove origin;"
			ssh_address := "git@" + strings.TrimLeft(repo, "https://")
			ssh_address = strings.Replace(ssh_address, "/", ":", 1)
			add_remote_cmd_string := "git remote add origin " + ssh_address
			processes[i] = Proc{cmd: exec.Command("bash", "-c", clone_cmd_string+remove_remote_cmd_string+add_remote_cmd_string)}
			processes[i].cmd.Dir = filepath.Join(CONFIG.home, "code")
			processes[i].stdout, err = processes[i].cmd.StdoutPipe()
			if err != nil {
				error(err)
			}
			processes[i].stderr, err = processes[i].cmd.StderrPipe()
			if err != nil {
				error(err)
			}
		} else {
			processes[i] = Proc{cmd: exec.Command("git", "pull")}
			processes[i].cmd.Dir = folder
			processes[i].stdout, err = processes[i].cmd.StdoutPipe()
			if err != nil {
				error(err)
				os.Exit(1)
			}
			processes[i].stderr, err = processes[i].cmd.StderrPipe()
			if err != nil {
				error(err)
				os.Exit(1)
			}
		}
	}
	for _, p := range processes {
		p.cmd.Start()
	}
	for _, p := range processes {
		buf_out := new(bytes.Buffer)
		buf_out.ReadFrom(p.stdout)
		buf_out_str := strings.TrimRight(buf_out.String(), "\n")
		if len(buf_out_str) > 0 {
			info(buf_out_str)
		}

		buf_err := new(bytes.Buffer)
		buf_err.ReadFrom(p.stderr)
		buf_err_str := strings.TrimRight(buf_err.String(), "\n")
		if len(buf_err_str) > 0 {
			info(strings.TrimRight(buf_err.String(), "\n"))
		}

		if err := p.cmd.Wait(); err != nil {
			error(err)
		}
	}
	success("finished!")
}

func run_pkgs() {
	init_cmd()
	switch CONFIG.host {
	case "darwin":
		brewfile_path := filepath.Join(CONFIG.state, "Brewfile")
		if err := os.WriteFile(brewfile_path, []byte(strings.Join(CONFIG.brew, "\n")), 0600); err != nil {
			error(err)
		}
		if out, err := exec.Command("bundle", "--cleanup", "--file", brewfile_path, "install").Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
	case "vorador":
		pkgs_needed, pkgs_remove := manage_pkg_state("apt", CONFIG.apt)
		if out, err := exec.Command("sudo", "apt", "update").Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "apt", "install", strings.Join(pkgs_needed, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "apt", "remove", strings.Join(pkgs_remove, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "apt", "update", "--autoremove").Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if err := os.WriteFile(filepath.Join(CONFIG.state, "apt"), []byte(strings.Join(CONFIG.apt, "\n")), 0644); err != nil {
			error(err)
		}

	default:
		pkgs_needed, pkgs_remove := manage_pkg_state("pacman", CONFIG.pacman)
		if out, err := exec.Command("sudo", "pacman", "-Syu").Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "pacman", "-S", "--needed", strings.Join(pkgs_needed, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "pacman", "-R", strings.Join(pkgs_remove, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if err := os.WriteFile(filepath.Join(CONFIG.state, "pacman"), []byte(strings.Join(CONFIG.pacman, "\n")), 0644); err != nil {
			error(err)
		}

		pkgs_needed, pkgs_remove = manage_pkg_state("aur", CONFIG.aur)
		if out, err := exec.Command("sudo", "paru", "-Syu").Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "paru", "-S", "--needed", strings.Join(pkgs_needed, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if out, err := exec.Command("sudo", "paru", "-R", strings.Join(pkgs_remove, " ")).Output(); err != nil {
			error(err)
		} else {
			info(string(out))
		}
		if err := os.WriteFile(filepath.Join(CONFIG.state, "aur"), []byte(strings.Join(CONFIG.aur, "\n")), 0644); err != nil {
			error(err)
		}
	}
	success("finished!")
}

func manage_pkg_state(pkg_manager string, pkgs []string) ([]string, []string) {
	pkgs_needed := []string{}
	pkgs_remove := []string{}
	pkgs_installed_bytes, err := os.ReadFile(filepath.Join(CONFIG.state, pkg_manager))
	if err != nil {
		error(err)
	}

	pkgs_installed := map[string]struct{}{}
	pkgs_wanted := map[string]struct{}{}
	for _, p := range strings.Split(string(pkgs_installed_bytes), "\n") {
		pkgs_installed[p] = struct{}{}
	}
	for _, p := range pkgs {
		pkgs_wanted[p] = struct{}{}
	}

	for k := range pkgs_installed {
		if _, ok := pkgs_wanted[k]; !ok {
			pkgs_remove = append(pkgs_remove, k)
		}
	}
	for k := range pkgs_wanted {
		if _, ok := pkgs_installed[k]; !ok {
			pkgs_needed = append(pkgs_needed, k)
		}
	}
	return pkgs_needed, pkgs_remove
}

func run_nix() {
	init_cmd()
	out, err := exec.Command("nix-channel", "--update").Output()
	if err != nil {
		error(err)
	}
	info(string(out))

	out, err = exec.Command("nix-store", "--gc", "--optimise").Output()
	if err != nil {
		error(err)
	}
	info(string(out))
	success("finished!")
}

func run_nvim() {
	init_cmd()
	nvim_init := filepath.Join(CONFIG.config, "nvim", "init.lua")
	cmd := exec.Command("nvim", "-u", nvim_init, "--headless", "\"+Lazy! sync\"", "+TSUpdateSync", "+qa")
	cmd.Env = append(cmd.Env, "CC=gcc", "CXX=g++", "PATH="+CONFIG.path)
	info(cmd)

	out, err := cmd.Output()
	if err != nil {
		error(err)
	}
	info(string(out))
	success("finished!")
}

func run_sync() {
	init_cmd()
	run_stow()
	run_repos()
	run_pkgs()
	run_nix()
	run_nvim()
	current_command = "sync"
	success("finished!")
}
