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

def test_prompt_on_startup() -> None:
    child = pexpect.spawn("bash", encoding="utf-8")
    prompt = (
        f"\x1b[?2004h{RESET}(dotfiles) "
        f"{GREEN}[✔]{RESET} "
        f"{YELLOW}wang.kevin{RESET}@{GREEN}KWang-M-K322P{RESET}:{BLUE}~/projects/personal/dotfiles{RESET} "
        f"{PURPLE}(fix-tests){RESET} $ "
    )
    child.expect_exact([prompt], timeout=5)
