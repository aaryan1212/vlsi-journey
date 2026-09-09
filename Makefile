# Makefile — the only three commands you need this year.
#
#   make sim  MOD=mux2     compile and run one testbench
#   make wave MOD=mux2     run it, then open the waveform in GTKWave
#   make lint MOD=mux2     run Verilator's linter over the design
#   make                   run EVERY testbench and print a summary table
#   make clean             delete build artifacts
#
# Convention this relies on: rtl/<name>.sv holds the design,
# tb/tb_<name>.sv holds its testbench. Keep to it and nothing else needs
# configuring, ever.

IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave
VERILATOR:= verilator

IVFLAGS  := -g2012 -Wall -Irtl
BUILD    := build

# Every design that has a matching testbench.
ALL_TBS  := $(patsubst tb/tb_%.sv,%,$(wildcard tb/tb_*.sv))

.PHONY: all sim wave lint clean list help

all:
	@python3 scripts/run_all.py

help:
	@echo "make sim  MOD=mux2   - run one testbench"
	@echo "make wave MOD=mux2   - run it and open the waveform"
	@echo "make lint MOD=mux2   - lint the design with Verilator"
	@echo "make                 - run every testbench"
	@echo "make list            - show what testbenches exist"
	@echo "make clean           - remove build artifacts"

list:
	@echo $(ALL_TBS) | tr ' ' '\n'

# --- one testbench ---------------------------------------------------------
sim: guard-MOD $(BUILD)
	@$(IVERILOG) $(IVFLAGS) -o $(BUILD)/$(MOD).vvp rtl/$(MOD).sv tb/tb_$(MOD).sv
	@$(VVP) $(BUILD)/$(MOD).vvp

wave: sim
	@$(GTKWAVE) $(BUILD)/tb_$(MOD).vcd >/dev/null 2>&1 &

# --- linting ---------------------------------------------------------------
# Verilator's linter is stricter than Icarus and catches the mistakes that
# turn into silicon bugs: unintended latches, width mismatches, unused
# signals. Run it before you commit. Every time.
lint: guard-MOD
	@$(VERILATOR) --lint-only -Wall -Irtl rtl/$(MOD).sv && echo "LINT CLEAN  $(MOD)"

$(BUILD):
	@mkdir -p $(BUILD)

clean:
	@rm -rf $(BUILD)
	@echo "cleaned"

guard-MOD:
ifndef MOD
	$(error MOD is not set. Try:  make sim MOD=mux2)
endif
