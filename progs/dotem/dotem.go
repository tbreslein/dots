package main

import (
	"fmt"
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

	info("starting", name)
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

func run_repos() {
	init_cmd()
	if _, ok := CONFIG.roles["code"]; !ok {
		warn("Host does not have the \"code\" role; skipping")
		return
	}
	processes := [](*exec.Cmd){}
	errors := []any{}
	for _, repo := range CONFIG.repos {
		info("syncing repo: ", repo)
		name_start := strings.LastIndex(repo, "/") + 1
		name_end := strings.LastIndex(repo, ".")
		folder := filepath.Join(CONFIG.home, "code", repo[name_start:name_end])
		if _, err := os.Stat(folder); err != nil {
			// ran_into_error := exec.Command("git", "clone", repo, folder).Start() == nil
			processes = append(processes, exec.Command("git", "clone", repo, folder))
			if err := processes[len(processes)-1].Start(); err != nil {
				errors = append(errors, err)
			}
		} else {
			processes = append(processes, exec.Command("git", "pull"))
			processes[len(processes)-1].Dir = folder
			if err := processes[len(processes)-1].Start(); err != nil {
				errors = append(errors, err)
			}
		}
	}
	for _, p := range processes {
		if err := p.Wait(); err != nil {
			error(err)
		}
	}
	for _, e := range errors {
		error(e)
	}
	success("finished!")
}

func run_pkgs() {
	init_cmd()
	success("finished!")
}

func run_nix() {
	init_cmd()
	success("finished!")
}

func run_nvim() {
	init_cmd()
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

// @app.command()
// def stow():
//     """Ensures all necessary stows are up-to-date."""
//     init_cmd()
//
//     gstatus = sprun(["git", "status", "--porcelain"], cwd=CONFIG.dots)
//     if gstatus.returncode != 0:
//         err("Cannot run dm stow in dirty worktrees.")
//         exit(1)
//
//     stows = deepcopy(CONFIG.roles)
//     stows.add(CONFIG.host)
//     stows.add("all")
//     stows.add(os.path.join("colours", CONFIG.colours))
//     for stow in stows:
//         stow_dir = os.path.join(CONFIG.stows, stow)
//         if not os.path.isdir(stow_dir):
//             continue
//         sprun(
//             [
//                 "stow",
//                 "--no-folding",
//                 "--adopt",
//                 "-t",
//                 CONFIG.home,
//                 "-d",
//                 stow_dir,
//                 ".",
//             ],
//         )
//     sprun(["git", "restore", "."])
//
//     nvim_config_dir = os.path.join(CONFIG.home, ".config", "nvim")
//     if not os.path.islink(nvim_config_dir):
//         sprun(
//             [
//                 "ln",
//                 "-s",
//                 os.path.join(CONFIG.home, "dots", "nvim"),
//                 nvim_config_dir,
//             ]
//         )
//     success("finished!")
//
//
// @app.command()
// def nix():
//     """Syncs nix channels."""
//
//     init_cmd()
//     sprun(["nix-channel", "--update"])
//     # sprun(["nix-store", "--gc"])
//     # sprun(["nix-store", "--optimise"])
//     sprun(["nix-store", "--gc", "--optimise"])
//     success("finished!")
//
//
// @app.command()
// def repos():
//     """Ensures all necessary git repos are cloned and up-to-date."""
//
//     init_cmd()
//     if "code" not in CONFIG.roles:
//         warn(f'host {CONFIG.host} does not have "code" role; skipping')
//         return
//     ps = []
//     for repo in CONFIG.repos:
//         info(f"syncing repo: {repo}")
//         name_start = repo.rfind("/") + 1
//         name_end = repo.rfind(".")
//         folder = os.path.join(CONFIG.home, "code", repo[name_start:name_end])
//         if os.path.isdir(folder):
//             ps.append(sp.Popen(["git", "pull"], cwd=folder))
//         else:
//             ps.append(sp.Popen(["git", "clone", repo, folder]))
//     while not all(p.poll() is not None for p in ps):
//         pass
//     success("finished!")
//
//
// @app.command()
// def pkgs():
//     """Ensures all necessary packages are installed and up-to-date."""
//
//     init_cmd()
//     match CONFIG.host:
//         case "darwin":
//             brewfile_path = os.path.join(CONFIG.state, "Brewfile")
//             with open(brewfile_path, mode="w+") as f:
//                 f.write("\n".join(CONFIG.brew))
//             sprun(["brew", "bundle", "--cleanup", "--file", brewfile_path, "install"])
//         case "vorador":
//             (pkgs_needed, pkgs_remove) = _manage_pkg_state("apt", CONFIG.apt)
//             sprun(["sudo", "update"])
//             sprun(["sudo", "apt", "install", " ".join(pkgs_needed)])
//             sprun(["sudo", "apt", "remove", " ".join(pkgs_remove)])
//             sprun(["sudo", "upgrade", "--autoremove"])
//         case _:
//             (pacman_needed, pacman_remove) = _manage_pkg_state("pacman", CONFIG.pacman)
//             sprun(["sudo", "pacman", "-Syu"])
//             sprun(["sudo", "pacman", "-S", "--needed", " ".join(pacman_needed)])
//             sprun(["sudo", "pacman", "-R", " ".join(pacman_remove)])
//             with open(os.path.join(CONFIG.state, "pacman"), mode="w+") as f:
//                 f.write("\n".join(CONFIG.pacman))
//
//             (paru_needed, paru_remove) = _manage_pkg_state("aur", CONFIG.pacman)
//             sprun(["sudo", "paru", "-Syu"])
//             sprun(["sudo", "paru", "-S", "--needed", " ".join(paru_needed)])
//             sprun(["sudo", "paru", "-R", " ".join(paru_remove)])
//             with open(os.path.join(CONFIG.state, "aur"), mode="w+") as f:
//                 f.write("\n".join(CONFIG.aur))
//     success("finished!")
//
//
// def _manage_pkg_state(pkg_manager: str, pkgs: set[str]) -> Tuple[list[str], list[str]]:
//     """
//     Calculates the lists of packages that need to be installed and removed.
//
//     It reads the current state file at ~/dots/state/{pkg_manager}, which acts as
//     the list of currently user-installed packages. It compares that set to the
//     set of packages we want to have installed now, and calculates and returns
//     two lists: missing packages that need to be installed, and packages that can
//     be removed.
//     """
//
//     pkgs_installed = set[str]()
//     pkgs_installed_file = os.path.join(CONFIG.state, pkg_manager)
//     if os.path.isfile(pkgs_installed_file):
//         with open(os.path.join(CONFIG.state, pkg_manager), mode="r") as f:
//             pkgs_installed.update(set(f.readlines()))
//     pkgs_needed = [p for p in pkgs if p not in pkgs_installed]
//     pkgs_remove = [p for p in pkgs_installed if p not in pkgs]
//     return (pkgs_needed, pkgs_remove)
//
//
// @app.command()
// def nvim():
//     """Syncs nvim plugins."""
//
//     init_cmd()
//     sp.run(
//         ["nvim", "--headless", '"Lazy! sync"', "TSUpdateSync", "+qa"],
//         env={"CC": "gcc", "CXX": "g++", "PATH": CONFIG.path},
//         check=True,
//     )
//     success("finished!")
//
//
// @app.command()
// def tpm():
//     """Syncs tmux plugins."""
//
//     init_cmd()
//     tpm_dir = os.path.join(CONFIG.home, ".tmux", "plugins", "tpm")
//     if not os.path.isdir(tpm_dir):
//         sprun(["git", "clone", "https://github.com/tmux-plugins/tpm", tpm_dir])
//     # NOTE: for some reason these tpm commands are trying to run relative to /,
//     # so they fail because that's read-only...
//     # sprun([os.path.join(tpm_dir, "bin", "install_plugins")], cwd=CONFIG.home)
//     # sprun([os.path.join(tpm_dir, "bin", "update_plugins"), "all"])
//     success("finished!")
//
//
// @app.command()
// def sync():
//     """Runs all maintenance commands: stow, nix, repos, pkgs, nvim, tpm"""
//
//     init_cmd()
//     stow()
//     # nix()
//     repos()
//     # pkgs()
//     nvim()
//     tpm()
//     CONFIG.command = "sync"
//     success("finished!")
//
//
// if __name__ == "__main__":
//     app()
