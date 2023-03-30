import os, sys, time, getopt
import signal, fcntl, termios, struct
import pexpect
import time



def test_start_prompt() -> None:
    child = pexpect.spawn("bash")
    prompt = (
        b"\x1b[?2004h\x1b[0m(dotfiles) \x1b[0;32m[\xe2\x9c\x94]\x1b[0m \x1b[0;33mwang.kevin\x1b[0m@\x1b[0;32mKWang-M-K322P\x1b[0m:\x1b[0;34m~/projects/personal/dotfiles\x1b[0m \x1b[0;35m(fix-tests)\x1b[0m $ "
    )
    child.expect_exact([prompt], timeout=5)
