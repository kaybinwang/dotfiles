import subprocess
import os, sys, time, getopt
import signal, fcntl, termios, struct
import pexpect
import time


RED = b""
GREEN = "\x1b[0;32m"
YELLOW = "\x1b[0;33m"
BLUE = "\x1b[0;34m"
PURPLE = "\x1b[0;35m"
RESET = "\x1b[0m"

USER = os.environ["USER"]
HOST = subprocess.run(['hostname'], capture_output=True, text=True).stdout.strip()
CWD = os.getcwd()
HOME = os.environ["HOME"]
BRANCH = subprocess.run(["git", "rev-parse", "--abbrev-ref", "HEAD"], capture_output=True, text=True).stdout.strip()


def test_prompt_on_startup() -> None:
    cwd = CWD
    if cwd.startswith(HOME):
        cwd = "~" + CWD.removeprefix(HOME)
    child = pexpect.spawn("bash --rcfile .bashrc", encoding="utf-8")
    prompt = (
        f"\x1b[?2004h{RESET}(dotfiles) "
        f"{GREEN}[✔]{RESET} "
        f"{YELLOW}{USER}{RESET}@{GREEN}{HOST}{RESET}:{BLUE}{cwd}{RESET} "
        f"{PURPLE}({BRANCH}){RESET} $ "
    )
    child.expect_exact([prompt], timeout=5)
