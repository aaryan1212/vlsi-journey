# <Block name>

> Copy this file into each project folder and fill it in *as you build*, not
> at the end. A recruiter spends about ninety seconds on a repo. This file is
> the ninety seconds.

**One line:** what this block does, in plain English.

---

## Specification

What it is supposed to do, written before you wrote the RTL. Interface table:

| Signal | Dir | Width | Description |
|--------|-----|-------|-------------|
| `clk`  | in  | 1     | |
| `rst_n`| in  | 1     | Active-low synchronous reset |

Parameters, and what changing them does.

## Block diagram

Draw it. A hand-drawn photo is fine — better than nothing, and better than
a wall of text. WaveDrom or draw.io if you want it neat.

## How to run it

```
make sim  MOD=<name>     # run the testbench
make wave MOD=<name>     # look at the waveform
make lint MOD=<name>     # Verilator lint
```

Expected output: `PASS  tb_<name>`, N checks, 0 failures.

## Verification

What the testbench actually checks — directed cases, random cases, corner
cases. How many checks. What you deliberately did *not* test, and why.

Paste a waveform screenshot of the interesting case. Not the boring one.

## Synthesis

```
yosys -p "read_verilog -sv rtl/<name>.sv; synth; stat"
```

| Metric | Value |
|--------|-------|
| Cells | |
| Estimated Fmax | |
| Critical path | |

## Known limitations

Be honest here. This section is the one that makes an interviewer take you
seriously — it says you understand the boundaries of your own work. "Does
not handle back-to-back writes on the same cycle" reads as an engineer.
An absent limitations section reads as someone who did not look.

## What I learned

Two or three sentences. For you, not for them — but interviewers read it.
