export DESIGN_NICKNAME = ece327_mm
export DESIGN_NAME = mm
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# setting it to 1Mbit
export SYNTH_MEMORY_MAX_BITS = 1048576

# giving it really large die area 
export DIE_AREA = 0 0 3000 3000

# Area pressure loosen from 45
export CORE_UTILIZATION = 35
export PLACE_DENSITY_LB_ADDON = 0.2

export REMOVE_ABC_BUFFERS = 1
