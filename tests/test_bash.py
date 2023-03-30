import os, sys, time, getopt
import signal, fcntl, termios, struct
import pexpect
import time


RED = b""
GREEN = "\x1b[0;32m"

def test_prompt_on_startup() -> None:
    child = pexpect.spawn("bash", encoding="utf-8")
    prompt = f"\x1b[?2004h\x1b[0m(dotfiles) {GREEN}[✔]\x1b[0m \x1b[0;33mwang.kevin\x1b[0m@\x1b[0;32mKWang-M-K322P\x1b[0m:\x1b[0;34m~/projects/personal/dotfiles\x1b[0m \x1b[0;35m(fix-tests)\x1b[0m $ "
    child.expect_exact([prompt], timeout=5)
