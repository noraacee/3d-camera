# TCL File Generated by Component Editor 13.0sp1
# Wed Apr 08 19:36:32 PDT 2015
# DO NOT MODIFY


# 
# 3Dlizer "3Dlizer" v1.0
#  2015.04.08.19:36:32
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module 3Dlizer
# 
set_module_property DESCRIPTION ""
set_module_property NAME 3Dlizer
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME 3Dlizer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL threeDlizer
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file 3Dlizer.vhd VHDL PATH 3Dlizer.vhd TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter pixel_buffer_2D STD_LOGIC_VECTOR 0
set_parameter_property pixel_buffer_2D DEFAULT_VALUE 0
set_parameter_property pixel_buffer_2D DISPLAY_NAME pixel_buffer_2D
set_parameter_property pixel_buffer_2D TYPE STD_LOGIC_VECTOR
set_parameter_property pixel_buffer_2D UNITS None
set_parameter_property pixel_buffer_2D ALLOWED_RANGES 0:4294967295
set_parameter_property pixel_buffer_2D HDL_PARAMETER true
add_parameter pixel_buffer_3D STD_LOGIC_VECTOR 524288
set_parameter_property pixel_buffer_3D DEFAULT_VALUE 524288
set_parameter_property pixel_buffer_3D DISPLAY_NAME pixel_buffer_3D
set_parameter_property pixel_buffer_3D TYPE STD_LOGIC_VECTOR
set_parameter_property pixel_buffer_3D UNITS None
set_parameter_property pixel_buffer_3D ALLOWED_RANGES 0:4294967295
set_parameter_property pixel_buffer_3D HDL_PARAMETER true


# 
# display items
# 


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

add_interface_port conduit_end reset_out export Output 1
add_interface_port conduit_end pixel_r_ready export Input 1
add_interface_port conduit_end pixel_r export Input 5
add_interface_port conduit_end pixel_offset export Input 18
add_interface_port conduit_end pixel_r_done export Output 1
add_interface_port conduit_end red_led export Output 18
add_interface_port conduit_end clk_in export Input 1


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
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_in reset_n Input 1


# 
# connection point avalon_master_w
# 
add_interface avalon_master_w avalon start
set_interface_property avalon_master_w addressUnits SYMBOLS
set_interface_property avalon_master_w associatedClock clock
set_interface_property avalon_master_w associatedReset reset
set_interface_property avalon_master_w bitsPerSymbol 8
set_interface_property avalon_master_w burstOnBurstBoundariesOnly false
set_interface_property avalon_master_w burstcountUnits WORDS
set_interface_property avalon_master_w doStreamReads false
set_interface_property avalon_master_w doStreamWrites false
set_interface_property avalon_master_w holdTime 0
set_interface_property avalon_master_w linewrapBursts false
set_interface_property avalon_master_w maximumPendingReadTransactions 0
set_interface_property avalon_master_w readLatency 0
set_interface_property avalon_master_w readWaitTime 1
set_interface_property avalon_master_w setupTime 0
set_interface_property avalon_master_w timingUnits Cycles
set_interface_property avalon_master_w writeWaitTime 0
set_interface_property avalon_master_w ENABLED true
set_interface_property avalon_master_w EXPORT_OF ""
set_interface_property avalon_master_w PORT_NAME_MAP ""
set_interface_property avalon_master_w SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_w master_wr_en write Output 1
add_interface_port avalon_master_w master_wd writedata Output 16
add_interface_port avalon_master_w master_w_wait waitrequest Input 1
add_interface_port avalon_master_w master_w_addr address Output 32
add_interface_port avalon_master_w master_w_be byteenable Output 2


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
