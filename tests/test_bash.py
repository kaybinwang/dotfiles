import subprocess
import os, sys, time, getopt
import signal, fcntl, termios, struct
import pexpect
import time
from typing import Optional


RED = b""
GREEN = "\x1b[0;32m"
YELLOW = "\x1b[0;33m"
BLUE = "\x1b[0;34m"
PURPLE = "\x1b[0;35m"
RESET = "\x1b[0m"

USER = os.environ["USER"]
HOST = subprocess.run(['hostname'], capture_output=True, text=True).stdout.strip()
HOME = os.environ["HOME"]
BRANCH = subprocess.run(["git", "rev-parse", "--abbrev-ref", "HEAD"], capture_output=True, text=True).stdout.strip()


def test_prompt_on_startup() -> None:
    cwd = get_cwd(expand_home=False)
    branch = get_git_branch()
    virtualenv = get_virtualenv()

    child = pexpect.spawn("bash --rcfile .bashrc", encoding="utf-8")
    prompt = "".join([
        f"\x1b[?2004h",
        (f"{RESET}({virtualenv}) " if virtualenv else ""),
        f"{GREEN}[✔]{RESET} ",
        f"{YELLOW}{USER}{RESET}@{GREEN}{HOST}{RESET}:{BLUE}{cwd}{RESET} ",
        (f"{PURPLE}({branch}){RESET} " if branch else ""),
        "$ ",
    ])
    child.expect_exact([prompt], timeout=5)


def get_cwd(expand_home: bool = True) -> str:
    cwd = os.getcwd()
    if expand_home:
        return cwd
    if cwd.startswith(HOME):
        cwd = "~" + cwd.removeprefix(HOME)
    return cwd


def get_git_branch() -> Optional[str]:
    branch = subprocess.run(["git", "rev-parse", "--abbrev-ref", "HEAD"], capture_output=True, text=True).stdout.strip()
    if not branch:
        return None
    return branch


def get_virtualenv() -> Optional[str]:
    path = os.environ.get("VIRTUAL_ENV")
    if path is None:
        return None
    return os.path.basename(path)
