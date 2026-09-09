# vlsi-journey

Digital design work, September 2026 onward. RTL in SystemVerilog, verified
with self-checking testbenches, synthesised with Yosys, simulated with Icarus
Verilog and Verilator.

Building toward a RISC-V RV32I core.

---

## Layout

```
rtl/            designs           — rtl/<name>.sv
tb/             testbenches       — tb/tb_<name>.sv
scripts/        automation        — run_all.py runs the whole suite
docs/           templates, notes
hdlbits/        HDLBits progress log
build/          simulation output (gitignored)
```

The naming convention is load-bearing: `rtl/foo.sv` pairs with `tb/tb_foo.sv`,
and everything else discovers designs from that. Keep to it and you never
touch the Makefile again.

## Commands

```bash
make                    # run every testbench, print a summary table
make sim  MOD=mux2      # run one testbench
make wave MOD=mux2      # run it, then open the waveform in GTKWave
make lint MOD=mux2      # Verilator lint — stricter than the simulator
make clean              # delete build artifacts
```

## What's here so far

| Block | Description | Checks | Status |
|-------|-------------|-------:|--------|
| `mux2` | Parameterised 2:1 multiplexer | 204 | PASS |
| `full_adder` | 1-bit full adder, exhaustively verified | 8 | PASS |

## The rule

Nothing gets committed to `rtl/` without a testbench in `tb/` that checks it
and a lint run that comes back clean. Not "I looked at the waveform and it
seemed right" — a testbench that fails loudly and exits non-zero when the
design is wrong.

To prove yours actually does that: break the design on purpose, run `make`,
and confirm it goes red. A testbench that passes no matter what you do to
the RTL is worse than no testbench, because it makes you confident.

## Setup

See [SETUP.md](SETUP.md).
