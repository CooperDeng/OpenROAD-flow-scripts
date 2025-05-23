export DESIGN_NICKNAME = ece327_attn_head
export DESIGN_NAME = attn_head
export PLATFORM = sky130hd

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE 	 = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Large inferred RAM set to 1Mbit
export SYNTH_MEMORY_MAX_BITS = 1048576

# SRAM macro that hopefully works
export DFF_LIB_FILES = ./platforms/sky130ram/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib

# Large die!!!!
export DIE_AREA = 0 0 3000 3000

# Looser area pressure
export CORE_UTILIZATION = 35
export PLACE_DENSITY_LB_ADDON = 0.2

export REMOVE_ABC_BUFFERS = 1
