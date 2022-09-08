#---------------------------------------------------------------------------
#------------ WFGMF: WoW FPGA Guidelines Makefile Framework ----------------
#---------------------------------------------------------------------------
# DESCRIPTION : <description>
#---------------------------------------------------------------------------
# TESTED VERSIONS: 
#---------------------------------------------------------------------------
# KNOWN ISSUES:
#---------------------------------------------------------------------------
# TODO:
#---------------------------------------------------------------------------
# VERSION HISTORY:
# yyyy-mm-dd   <Author Abbreviation>    <Comment>
#---------------------------------------------------------------------------
# Edit the following line. Provide a relative or absolute path to the
# buildfiles directory.
BUILDFILES_PREFIX=../../buildfiles
#---------------------------------------------------------------------------
# Do not edit the following line.
include $(BUILDFILES_PREFIX)/pre_include.mk
#---------------------------------------------------------------------------
# Place customization below this line.
#---------------------------------------------------------------------------

LIB_BLOCK = lib_top_audio_filter

VIVADO_ALL_TARGET = gen_files prj gui

VIVADO_VHDL_VERSION = 2008

VIVADO_ALL_TARGET = export_hw

#modules used in the design
DEPENDENCIES = $(TOOL)/lib_clock_controller_pll
DEPENDENCIES += $(TOOL)/lib_adc_receiver
DEPENDENCIES += $(TOOL)/lib_dac_control
DEPENDENCIES += $(TOOL)/lib_double_buffer
DEPENDENCIES += $(TOOL)/lib_channel_splitter
DEPENDENCIES += $(TOOL)/lib_channel_recombiner
#DEPENDENCIES += $(TOOL)/lib_FIR_filter
DEPENDENCIES += $(TOOL)/lib_IIR_filter



#Name of block design:
VIVADO_TOP=top_audio_filter
VIVADO_PROJECT = top_audio_filter

# Block design generation options:
# uncomment next line for VHDL (i.s.o. Verilog) generation HDL
# VIVADO_BD_GEN_TCL_OPTS += --vhdl
# uncomment next line to generate a hardware definition file (for XSDK)
VIVADO_BD_GEN_TCL_OPTS += --hwdef
# uncomment next line for generation of tcl files to re-generate block design (.bd) file
# VIVADO_BD_GEN_TCL_OPTS += --write_tcl
# uncomment next line to force synthesis generation mode of block design
# (supported None, Singular or Hierarchical). Will modify .bd file
VIVADO_BD_GEN_TCL_OPTS += --cp_mode None

VIVADO_IP_GEN_TCL_OPTS += --enable_upgrade


#call setup_project_properties_dg.tcl to configure project specific parameters
#VIVADO_PRJ_MGT_TCL_OPTS     += --script setup_project_properties_dg.tcl
#VIVADO_NP_FLOW_SCRIPT_OPTS  += --script setup_project_properties_dg.tcl
#VIVADO_NP_FLOW_SCRIPT_OPTS  += --include setup_project_properties_dg.tcl
VIVADO_NP_FLOW_SCRIPT_OPTS += --incr

# If your block design contains custom IP, add the location(s) to VIVADO_IP_REPO_PATH:
# e.g.:
# VIVADO_IP_REPO_PATH += $(CUR_COMPONENT_PATH)/vivado/lib_ip_repo/PWM_w_Int_1.0

#---------------------------------------------------------------------------
# Do not edit the following line.
include $(BUILDFILES_PREFIX)/post_include.mk

# also clean local project when running "make clean"
clean: clean_project_all