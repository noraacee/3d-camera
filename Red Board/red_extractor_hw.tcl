# TCL File Generated by Component Editor 13.0sp1
# Wed Apr 08 19:36:35 PDT 2015
# DO NOT MODIFY


# 
# red_extractor "Red Extractor" v1.0
#  2015.04.08.19:36:35
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module red_extractor
# 
set_module_property DESCRIPTION ""
set_module_property NAME red_extractor
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Red Extractor"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL red_extractor
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file red_extractor.vhd VHDL PATH red_extractor.vhd TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter pixel_buffer_base STD_LOGIC_VECTOR 524288
set_parameter_property pixel_buffer_base DEFAULT_VALUE 524288
set_parameter_property pixel_buffer_base DISPLAY_NAME pixel_buffer_base
set_parameter_property pixel_buffer_base TYPE STD_LOGIC_VECTOR
set_parameter_property pixel_buffer_base UNITS None
set_parameter_property pixel_buffer_base ALLOWED_RANGES 0:4294967295
set_parameter_property pixel_buffer_base HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock ""
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end pixel_r_ready export Output 1
add_interface_port conduit_end pixel_r export Output 5
add_interface_port conduit_end pixel_offset export Output 18
add_interface_port conduit_end reset_in export Input 1
add_interface_port conduit_end red_led export Output 18
add_interface_port conduit_end pixel_r_done export Input 1
add_interface_port conduit_end clk_in export Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n_in reset_n Input 1


# 
# connection point avalon_master_r
# 
add_interface avalon_master_r avalon start
set_interface_property avalon_master_r addressUnits SYMBOLS
set_interface_property avalon_master_r associatedClock clock
set_interface_property avalon_master_r associatedReset reset
set_interface_property avalon_master_r bitsPerSymbol 8
set_interface_property avalon_master_r burstOnBurstBoundariesOnly false
set_interface_property avalon_master_r burstcountUnits WORDS
set_interface_property avalon_master_r doStreamReads false
set_interface_property avalon_master_r doStreamWrites false
set_interface_property avalon_master_r holdTime 0
set_interface_property avalon_master_r linewrapBursts false
set_interface_property avalon_master_r maximumPendingReadTransactions 0
set_interface_property avalon_master_r readLatency 0
set_interface_property avalon_master_r readWaitTime 1
set_interface_property avalon_master_r setupTime 0
set_interface_property avalon_master_r timingUnits Cycles
set_interface_property avalon_master_r writeWaitTime 0
set_interface_property avalon_master_r ENABLED true
set_interface_property avalon_master_r EXPORT_OF ""
set_interface_property avalon_master_r PORT_NAME_MAP ""
set_interface_property avalon_master_r SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_r master_rd readdata Input 16
add_interface_port avalon_master_r master_rd_en read Output 1
add_interface_port avalon_master_r master_r_wait waitrequest Input 1
add_interface_port avalon_master_r master_r_addr address Output 32
add_interface_port avalon_master_r master_r_be byteenable Output 2
