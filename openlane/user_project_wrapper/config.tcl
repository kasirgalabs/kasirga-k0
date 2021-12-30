# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configuration
set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_CORE_RING) 1

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/c0_rtl/sabitler.vh \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "\
	mprj.clk_g\
	BB_SRAM.clk0\
	BB_SRAM.clk1\
	VB_SRAM.clk0\
	VB_SRAM.clk1"

set ::env(CLOCK_PERIOD) "50"

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) " \
	mprj vccd1 vssd1 \
	BB_SRAM vccd1 vssd1 \
	VB_SRAM vccd1 vssd1"

### Macro Placement
#set ::env(FP_SIZING) "absolute"
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg


#set ::env(PDN_CFG) $script_dir/pdn.tcl


### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/c0_rtl/c0_system.v \
	$script_dir/../../verilog/c0_rtl/sky130_sram_2kbyte_1rw1r_32x512_8.v"

set ::env(EXTRA_LEFS) " \
	$script_dir/../../lef/c0_system.lef \
	$script_dir/../../lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef"

set ::env(EXTRA_GDS_FILES) " \
	$script_dir/../../gds/c0_system.gds \
	$script_dir/../../gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds"

set ::env(GLB_RT_MAXLAYER) 5

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0


#set ::env(VDD_NETS) "vccd1"
#set ::env(GND_NETS) "vssd1"


# Add Blockage arond the SRAM to avoid Magic DRC & 
# add signal routing blockage for met5

# SRAM Dimensions: X-479,78, Y-397,5
# 2Kbyte Dim: X-683.1, Y-416.54
set ::env(GLB_RT_OBS) " met1 250.00 1000.00 933.1 1416.54, \
	              		met2 250.00 1000.00 933.1 1416.54, \
	              		met3 250.00 1000.00 933.1 1416.54, \
	              		met1 250.00 1900.00 933.1 2316.54, \
	              		met2 250.00 1900.00 933.1 2316.54, \
	              		met3 250.00 1900.00 933.1 2316.54, \
		       			met5 0 0 2920 3520"

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0


set ::env(QUIT_ON_LVS_ERROR) "0"
set ::env(QUIT_ON_MAGIC_DRC) "0"
set ::env(QUIT_ON_NEGATIVE_WNS) "0"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"
set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"
set ::env(QUIT_ON_TR_DRC) "0"

# Because OpenLANE takes up all memory trying to output DRC failures in KLAYOUT format
set ::env(RUN_KLAYOUT_DRC) 0
set ::env(MAGIC_DRC_USE_GDS) 0
