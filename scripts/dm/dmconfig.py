import os
from dotenv import load_dotenv
from brew import brew
from arch import arch


os.system("")


class Config:
    def __init__(self):
        self.roles: set[str] = {r for r in (os.environ.get("ROLES") or "").split()}
        self.host: str = os.environ.get("_HOST") or ""
        self.uname: str = os.environ.get("UNAME_S") or ""
        self.path: str = os.environ.get("PATH") or ""
        self.home: str = os.environ.get("HOME") or ""
        self.colours: str = os.environ.get("COLOURS") or ""
        self.dots: str = os.path.join(self.home, "dots")
        self.stows: str = os.path.join(self.dots, "stows")
        self.state: str = os.path.join(self.dots, "state")
        self.repos: list[str] = (os.environ.get("REPOS") or "").split()
        self.red: str = "\033[0;31m"
        self.green: str = "\033[0;32m"
        self.yellow: str = "\033[0;33m"
        self.blue: str = "\033[0;34m"
        self.bright_red: str = "\033[1;31m"
        self.bright_green: str = "\033[1;32m"
        self.bright_yellow: str = "\033[1;33m"
        self.bright_blue: str = "\033[1;34m"
        self.no_color: str = "\033[0m"
        self.command: str = ""
        self.allowed_hosts: set[str] = {
            h for h in (os.environ.get("ALLOWED_HOSTS") or "")
        }

        self.brew = brew()
        self.apt: set[str] = {"syncthing", "git", "vim"}
        (self.pacman, self.aur) = arch(self.roles, self.host)


load_dotenv()
CONFIG = Config()
