# Setup — Windows

You are on Windows x64. There are two ways to do this and only one of them
works past about week six.

**Do not install native Windows builds of these tools.** Icarus and GTKWave
have Windows installers and they work fine — right up until you need
Verilator, Yosys, cocotb, the RISC-V GCC toolchain or OpenLane, at which
point you are fighting the machine instead of learning digital design. Every
tool in this field is Linux-native.

**Install WSL2 instead.** It is a real Ubuntu, it takes fifteen minutes, and
it is what the industry actually runs on.

---

## 1 · WSL2 and Ubuntu

Open **PowerShell as Administrator** and run:

```powershell
wsl --install -d Ubuntu
```

Reboot when it asks. On first launch Ubuntu will ask you to create a username
and password — this is separate from your Windows account, and the password
is what `sudo` will ask for. Pick something you will remember.

Check it worked:

```powershell
wsl --list --verbose
```

You want to see `Ubuntu` with `VERSION 2`. If it says version 1, run
`wsl --set-version Ubuntu 2`.

From here on, **everything happens inside the Ubuntu terminal**, not
PowerShell. Open it from the Start menu, or type `wsl` in any terminal.

## 2 · The toolchain

Inside Ubuntu:

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    build-essential git make \
    iverilog gtkwave verilator yosys \
    python3 python3-pip python3-venv \
    curl wget unzip
```

Verify all four:

```bash
iverilog -V | head -1     # Icarus Verilog version 12.0 or newer
verilator --version       # Verilator 5.x
yosys -V                  # Yosys 0.3x
gtkwave --version         # GTKWave 3.3.x
```

If `yosys` is missing or ancient in your Ubuntu version, install the OSS CAD
Suite instead — it bundles current builds of everything:

```bash
cd ~ && wget https://github.com/YosysHQ/oss-cad-suite-build/releases/latest/download/oss-cad-suite-linux-x64.tgz
tar -xzf oss-cad-suite-linux-x64.tgz
echo 'export PATH="$HOME/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 3 · GTKWave on WSL

GTKWave is a GUI app. On Windows 11 with WSL2 it just works — run
`gtkwave file.vcd` and a window appears. On Windows 10 you need WSLg or an X
server; the simplest fix is to update to Windows 11, and the fallback is to
install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) and add
`export DISPLAY=:0` to your `~/.bashrc`.

Test it: `make wave MOD=mux2` from the repo should open a waveform window.

## 4 · Git

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

Use the **same email as your GitHub account**, or your commits will not show
up on your contribution graph — and that graph is a year-long record of your
consistency that recruiters do look at.

## 5 · Where to keep the repo

**Inside the Linux filesystem, at `~/vlsi-journey`.** Not in
`/mnt/c/Users/...`.

Files on the Windows drive are reachable from Ubuntu, but every read crosses
a filesystem boundary and simulation gets several times slower. Keep the work
in `~/` and let Windows reach *in* when it needs to — File Explorer opens
`\\wsl$\Ubuntu\home\<you>\vlsi-journey` directly.

```bash
cd ~
# unzip vlsi-journey.zip here, or clone your GitHub repo
cd vlsi-journey
make
```

You should see two testbenches, both PASS, 212 checks, 0 failures. If you do,
your whole toolchain works and you never have to think about it again.

## 6 · VS Code

You already have VS Code. Install the **WSL** extension, then from Ubuntu:

```bash
code .
```

VS Code opens on Windows but runs everything inside Linux. Add the
**Verilog-HDL/SystemVerilog** extension (mshr-h) for syntax highlighting and
linting inside the editor.

## 7 · GitHub

Create the repo today, even though it has two files in it.

```bash
cd ~/vlsi-journey
git init
git add .
git commit -m "Initial commit: toolchain verified, mux2 and full_adder passing"
```

Then create an empty repo on github.com named `vlsi-journey` and:

```bash
git remote add origin https://github.com/<you>/vlsi-journey.git
git branch -M main
git push -u origin main
```

Commit every day you work, even if the commit is small and the code is bad.
The value is not in any single commit. It is in twelve months of them.

---

## If something breaks

| Symptom | Fix |
|---|---|
| `wsl --install` fails | Enable virtualisation in BIOS; enable "Virtual Machine Platform" in Windows Features |
| `make: command not found` | `sudo apt install build-essential` |
| `iverilog: Unknown option -g2012` | Your Icarus is older than v10. Use the OSS CAD Suite build. |
| GTKWave opens nothing | Windows 10 — install VcXsrv and `export DISPLAY=:0` |
| Simulation is very slow | Your repo is on `/mnt/c/`. Move it to `~/`. |
| `make` says "Makefile:27: *** missing separator" | Your editor converted tabs to spaces. Makefiles require real tabs. |
