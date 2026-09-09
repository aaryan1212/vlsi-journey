#!/usr/bin/env python3
"""
run_all.py — run every testbench in the repo and print one summary table.

This is a 60-line script and it is worth more to you than it looks. Two reasons:

  1. It removes the excuse. Running one testbench is a chore, so people stop
     doing it. Running all of them is one command, so you keep doing it, and
     you find out the day you break something rather than the week after.

  2. It is the "scripting" line on your resume. Every single job posting you
     are targeting — NVIDIA, Qualcomm, Google — lists Python, Tcl or shell.
     Not as a nice-to-have. In the required section. "I wrote a regression
     runner for my own designs" is a real answer to a real interview question,
     and you got it for an afternoon's work.

Extend it as you go: add a timer, add a JUnit XML writer, wire it to a
GitHub Action. By month six it should refuse to let you commit a broken build.
"""

import glob
import os
import re
import subprocess
import sys
import time

BUILD = "build"
IVFLAGS = ["-g2012", "-Wall", "-Irtl"]


def discover():
    """Find every design that has a matching testbench."""
    mods = []
    for tb in sorted(glob.glob("tb/tb_*.sv")):
        name = re.sub(r"^tb/tb_(.*)\.sv$", r"\1", tb)
        if os.path.exists(f"rtl/{name}.sv"):
            mods.append(name)
        else:
            print(f"  warning: {tb} has no rtl/{name}.sv — skipping")
    return mods


def run_one(mod):
    """Compile and run one testbench. Returns (ok, checks, failures, seconds)."""
    vvp = f"{BUILD}/{mod}.vvp"
    t0 = time.time()

    compile_cmd = ["iverilog"] + IVFLAGS + ["-o", vvp, f"rtl/{mod}.sv", f"tb/tb_{mod}.sv"]
    c = subprocess.run(compile_cmd, capture_output=True, text=True)
    if c.returncode != 0:
        print(c.stderr.rstrip())
        return False, 0, 0, time.time() - t0, "compile error"

    r = subprocess.run(["vvp", vvp], capture_output=True, text=True)
    out = r.stdout
    elapsed = time.time() - t0

    m = re.search(r"---\s+(\d+) checks, (\d+) failures", out)
    checks, failures = (int(m.group(1)), int(m.group(2))) if m else (0, 0)

    ok = ("PASS" in out) and failures == 0 and r.returncode == 0

    if not ok:
        for line in out.splitlines():
            if "FAIL" in line:
                print("   " + line.strip())

    return ok, checks, failures, elapsed, ""


def main():
    os.makedirs(BUILD, exist_ok=True)
    mods = discover()

    if not mods:
        print("No testbenches found. Expected tb/tb_<name>.sv alongside rtl/<name>.sv")
        return 1

    print()
    print(f"{'MODULE':<24} {'RESULT':<8} {'CHECKS':>7} {'FAILED':>7} {'TIME':>7}")
    print("-" * 58)

    total_fail = 0
    for mod in mods:
        ok, checks, failures, elapsed, note = run_one(mod)
        status = "PASS" if ok else "FAIL"
        if not ok:
            total_fail += 1
        print(f"{mod:<24} {status:<8} {checks:>7} {failures:>7} {elapsed:>6.2f}s"
              + (f"  {note}" if note else ""))

    print("-" * 58)
    print(f"{len(mods)} testbenches, {total_fail} failing")
    print()
    return 1 if total_fail else 0


if __name__ == "__main__":
    sys.exit(main())
