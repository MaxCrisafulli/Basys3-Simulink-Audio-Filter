#BUILDFILES_PREFIX=../../buildfiles
#include $(BUILDFILES_PREFIX)/pre_include.mk

#include $(BUILDFILES_PREFIX)/post_include.mk




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

#DEPENDENCIES += 


VIVADO_ALL_TARGET = export_sim
VIVADO_DEPENDENCY_TARGET = export_sim

DEPENDENCIES = 
VIVADO_PRJ_MGT_TCL_OPTS = --ip_project
VIVADO_CLEAN_DIRS       = ip_user_files
VIVADO_CLEAN_DIRS      += export_sim
VIVADO_CLEAN_DIRS      += log_files
VIVADO_IP_GEN_TCL_OPTS += --enable_upgrade

## Export simulation 
## apply some fixes for Xilinx scripts during export_sim build:
VIVADO_EXPORT_SIM_PRE_TCL  = ../../buildfiles/vivado_tcl/xilinx_projutils_fixes.tcl
VIVADO_EXPORT_SIM_TCL_OPTS = --export_ip_user_files

#---------------------------------------------------------------------------
# Do not edit the following line.
include $(BUILDFILES_PREFIX)/post_include.mk

