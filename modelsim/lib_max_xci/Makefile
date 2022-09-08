#BUILDFILES_PREFIX=../../buildfiles
#include $(BUILDFILES_PREFIX)/pre_include.mk

#DEPENDENCIES = vivado/$(LIB_BLOCK)

#include $(BUILDFILES_PREFIX)/post_include.mk





#---------------------------------------------------------------------------
#------------ WFGMF: WoW FPGA Guidelines Makefile Framework ----------------
#---------------------------------------------------------------------------
# DESCRIPTION : Example Makefile for compilation and simulation of a Vivado
#               design exported with the (vivado buildfiles) export_sim
#               target
#               This Makefile will invoke a (python) parser that generates
#               files for compilation etc. using data in the generated 
#               export_sim folder
#---------------------------------------------------------------------------
# TESTED VERSIONS: 
#---------------------------------------------------------------------------
# KNOWN ISSUES:
#---------------------------------------------------------------------------
# TODO:
#---------------------------------------------------------------------------
# VERSION HISTORY:
# yyyy-mm-dd   <Author Abbreviation>    <Comment>
# 2019-08-28   PAEI   First version
#---------------------------------------------------------------------------
# Provide a relative path to the buildfiles directory.
BUILDFILES_PREFIX=../../buildfiles
#---------------------------------------------------------------------------
# Do not edit the following line.
include $(BUILDFILES_PREFIX)/pre_include.mk
#---------------------------------------------------------------------------
# Place customization below this line.
#---------------------------------------------------------------------------

# Define dependencies:
DEPENDENCIES  = vivado/$(LIB_BLOCK)

# Enable the vivado compilation flow 
MODELSIM_VIVADO_COMPILE    = yes
# Where is the export_sim folder found
MODELSIM_VIVADO_DIR        = $(CUR_COMPONENT_PATH)/vivado/$(LIB_BLOCK)
# Name of top-level for simulation
MODELSIM_VIVADO_SYSTEMNAME = $(BLOCK)

# Compilation options
MODELSIM_VLOG_GEN_ARGS = -lint -quiet -source 
# remove language from compiler command, is set in generated file vivado/ modelsim_comp.sh
MODELSIM_VCOM_GEN_ARGS = -nologo -lint -quiet -source -noDeferSubpgmCheck -rangecheck

# If you want to override library xil_defaultlib to the "local" library
#MODELSIM_VIVADO_PROC_OPTS += --library $(MODELSIM_WORK)
# for processing additional options for setting up simulator search paths (-L options)
MODELSIM_VIVADO_PROC_OPTS += --elab_file $(MODELSIM_VIVADO_DIR)/export_sim/questa/elaborate.do

# For searching in libraries for design units instantiated in verilog code, or
#   default VHDL component binding, uncomment the following line and specify the search
#   libraries. The libaries will be added in the order specified in -L options to the 
#   vsim (and vopt) command line.
# MODELSIM_VSIM_SEARCH_LIBS = lib_a lib_b
# To search in the current library first (i.e. where the unit is instantiated), 
#   specify "work" as the first library:
# MODELSIM_VSIM_SEARCH_LIBS = work lib_a lib_b

# Specify libraries to be searched during verilog compilation
# In most cases this is only required for finding SystemVerilog packages
# Advice to define it here manually, even if it is empty,
# instead of using "generated" value from modelsim_variables.mk
MODELSIM_VLOG_LIBS =

# It is adviced to explicitly define the search libraries for vsim (and vopt)
# and not to use the auto-genrated value from modelsim_variables.mk.
# To use the auto-generated value, comment out next line:
#MODELSIM_VSIM_LIBS = unisims_ver unisim secureip unimacro_ver xpm

# Add file(s) with additional search libraries for the vivado system
MODELSIM_VOPT_ARG_FILES += vivado/modelsim_vivado_opts.f
MODELSIM_VSIM_ARG_FILES += vivado/modelsim_vivado_opts.f

# Add generated wrapper file (if any) to sources. It will be in the hdl subfolder:
SIM_HDL_SEARCH_PATH += $(MODELSIM_VIVADO_DIR)/$(MODELSIM_VIVADO_SYSTEMNAME)/hdl

# To use the 3 step flow (vcom/vlog, vopt, vsim) , uncomment the following line
# In most cases this is required when the design is exported in Verilog, in order to add 
# glbl.v as a second top-level (2 top-levels is currently only supported in optimizer flow)
#MODELSIM_USE_VOPT = yes
# The top-levels 
#MODELSIM_VOPT_TOP_DESIGNS = $(MODELSIM_WORK).$(MODELSIM_VIVADO_SYSTEMNAME) $(MODELSIM_WORK).glbl

#---------------------------------------------------------------------------
# Do not edit the following line.
include $(BUILDFILES_PREFIX)/post_include.mk