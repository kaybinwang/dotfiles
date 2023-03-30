import os, sys, time, getopt
import signal, fcntl, termios, struct
import pexpect
import time


RED = b""
GREEN = "\x1b[0;32m"
YELLOW = "\x1b[0;33m"
RESET = "\x1b[0m"

def test_prompt_on_startup() -> None:
    child = pexpect.spawn("bash", encoding="utf-8")
    prompt = f"\x1b[?2004h{RESET}(dotfiles) {GREEN}[✔]{RESET} {YELLOW}wang.kevin{RESET}@{GREEN}KWang-M-K322P{RESET}:\x1b[0;34m~/projects/personal/dotfiles\x1b[0m \x1b[0;35m(fix-tests)\x1b[0m $ "
    child.expect_exact([prompt], timeout=5)
