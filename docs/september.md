# Month 1 — September 2026

**Goal:** by 30 September you can write combinational Verilog without looking
anything up, your toolchain works, and your GitHub has four weeks of commits.

**Not the goal:** understanding pipelines, caches, UVM, or anything about
chips. That is months 4 through 9. Trying to skip ahead now is the single
most common way this goes wrong.

Budget roughly **8–10 hours a week**. That is a little over an hour a day.
Consistency matters far more than intensity here — the material compounds,
and cramming does not work on skills.

---

## Week 1 (1–7 Sep) — make the tools work, then stop touching them

- [ ] WSL2 + Ubuntu installed, toolchain installed, `make` runs green
      (see [SETUP.md](../SETUP.md))
- [ ] GitHub repo created and pushed
- [ ] **Harris & Harris ch. 1** — From Zero to One. Number systems, logic
      gates, CMOS transistors.
- [ ] **HarveyMuddX Digital Design**, the matching videos. Watch at 1.25×;
      pause and redo anything you cannot re-derive on paper.
- [ ] **HDLBits: Getting Started + Verilog Language → Basics.** ~14 problems.
- [ ] Read the two testbenches in `tb/` line by line. Then break `rtl/mux2.sv`
      on purpose, run `make`, and watch it go red. That is the most important
      thing you will do this week.

> **Why break it deliberately?** Because a testbench you have never seen fail
> is a testbench you have no reason to trust. Get in the habit now, while the
> designs are four lines long, and you will still have it when they are four
> thousand.

## Week 2 (8–14 Sep) — combinational logic

- [ ] **Harris & Harris ch. 2** — Combinational Logic Design. Boolean algebra,
      K-maps, multi-level logic, X's and Z's.
- [ ] **HDLBits: Vectors, Modules, Procedures.** ~25 problems.
- [ ] Write your own from scratch, with testbenches, into this repo:
      - [ ] `mux4` — 4:1 mux, parameterised, built two ways: with a `case`
            and by instantiating three `mux2`. Compare the synthesis results.
      - [ ] `decoder3to8`
      - [ ] `priority_encoder8`
- [ ] Run `make lint` on every one. Fix every warning. Not most of them.

## Week 3 (15–21 Sep) — arithmetic, and reading waveforms

- [ ] **Harris & Harris ch. 3** — Sequential Logic Design. Latches,
      flip-flops, timing, metastability, FSMs. Chapter 3 is where the year
      actually starts; read it twice.
- [ ] **HDLBits: More Features, Basic Gates, Multiplexers.** ~30 problems.
- [ ] Build:
      - [ ] `ripple_adder` — 4-bit, from your `full_adder`. Then look at the
            carry chain in GTKWave and understand why it is slow.
      - [ ] `alu` — 8-bit, parameterised: ADD, SUB, AND, OR, XOR, SLT.
            Flags: zero, carry, overflow. Getting overflow right is harder
            than it looks; that is the point.
- [ ] Spend one full session in GTKWave doing nothing but reading waveforms.
      Learn to add signals, group them, change radix, and measure between
      two edges. You will live in this tool for a year.

## Week 4 (22–30 Sep) — K-maps, and the first real habit

- [ ] **HDLBits: Arithmetic Circuits, Karnaugh Maps.** ~19 problems.
      That should put you past 60 for the month.
- [ ] Re-read anything in ch. 1–3 you cannot explain out loud.
- [ ] Write proper READMEs for every block in the repo, using
      [PROJECT_README_TEMPLATE.md](PROJECT_README_TEMPLATE.md). Yes, for a
      multiplexer. The habit is what you are building, not the document.
- [ ] Run your first synthesis and record the numbers:
      ```bash
      yosys -p "read_verilog -sv rtl/alu.sv; synth; stat"
      ```
- [ ] Update `hdlbits/progress.md` with what you finished and what was hard.
- [ ] **Month-end check:** run `make`. Everything green? Push. Then look at
      your GitHub contribution graph. It should have about twenty-five green
      squares on it. That is what month one was for.

---

## The four things that decide whether this works

1. **Type every example.** Do not read HDL, write HDL. You cannot learn a
   language by watching someone else use it, and Verilog punishes people who
   try, because it looks like C and behaves like hardware.

2. **Every design gets a testbench, the same day.** Not later. Later never
   arrives, and a block without a testbench is a block you will not put on
   your resume.

3. **Fix every lint warning.** Verilator warns about the exact things that
   become real bugs — inferred latches, width mismatches, unused signals.
   Treat warnings as errors from day one and you will never develop the habit
   of ignoring them.

4. **Commit daily.** Even a bad commit. Especially a bad commit.

## What you are explicitly not doing yet

FPGAs and boards (month 3), CPUs (month 4), UVM (month 9), physical design,
tapeout, DSA. If you find yourself watching a RISC-V video in week 2, you are
avoiding the boring part — and the boring part is the part that works.
