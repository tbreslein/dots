import subprocess as sp
import inspect

from dmconfig import CONFIG


def _log(msg: str, label: str, color: str):
    foo = ""
    if CONFIG.command is None:
        foo = "dm"
    else:
        foo = f"dm: {CONFIG.command}"
    print(f"{color}[ {foo.ljust(9, ' ')} ] {label} | {CONFIG.no_color} {msg}")


def info(msg: str):
    _log(msg, "INFO   ", CONFIG.bright_blue)


def warn(msg: str):
    _log(msg, "WARN   ", CONFIG.bright_yellow)


def success(msg: str):
    _log(msg, "SUCCESS", CONFIG.bright_green)


def err(msg: str):
    _log(msg, "ERROR  ", CONFIG.bright_red)


def sprun(cmd: list[str], **kwargs) -> sp.CompletedProcess[bytes]:
    """Wrapper function around subprocess.run setting some defaults."""
    return sp.run(cmd, env={"PATH": CONFIG.path}, check=True, **kwargs)


def init_cmd():
    name = inspect.stack()[1][3]
    CONFIG.command = name
    info(f"starting {name}")
