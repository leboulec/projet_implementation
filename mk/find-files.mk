# Copyright 2021 Raphaël Bresson

SYNTH_V_FILES    = $(shell find ${PWD}/rtl/synth/ -name "*.v")
SYNTH_SV_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.sv"   | grep -v pkg)
SYNTH_VHD_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.vhd"  | grep -v pkg)
SYNTH_VHDL_FILES = $(shell find ${PWD}/rtl/synth/ -name "*.vhdl" | grep -v pkg)
SYNTH_PKG_SV_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.sv"   | grep pkg)
SYNTH_PKG_VHD_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.vhd"  | grep pkg)
SYNTH_PKG_VHDL_FILES = $(shell find ${PWD}/rtl/synth/ -name "*.vhdl" | grep pkg)
SYNTH_XCI_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.xci" )
SYNTH_BD_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.bd"  )

CONSTR_XDC_FILES          = $(shell find ${PWD}/rtl/constr/ -name "*.xdc")
CONSTR_XDC_PROBES         = $(shell find ${PWD}/rtl/probes/ -name "*.xdc")
CONSTR_XDC_PRE_OPT        = $(shell find ${PWD}/rtl/pre_opt/ -name "*.xdc")
CONSTR_XDC_POST_OPT       = $(shell find ${PWD}/rtl/post_opt/ -name "*.xdc")
CONSTR_XDC_POST_PLACEMENT = $(shell find ${PWD}/rtl/post_placement/ -name "*.xdc")

# TODO: Netlists input not supported
#NETLIST_V      = $(shell find ${PWD}/rtl/pre_opt/ -name "*.v")
#NETLIST_EDIF   = $(shell find ${PWD}/rtl/pre_opt/ -name "*.edif")

SIM_V_FILES    = $(shell find ${PWD}/rtl/sim/ -name "*.v"   )
SIM_SV_FILES   = $(shell find ${PWD}/rtl/sim/ -name "*.sv"  )
SIM_VHD_FILES  = $(shell find ${PWD}/rtl/sim/ -name "*.vhd" )
SIM_VHDL_FILES = $(shell find ${PWD}/rtl/sim/ -name "*.vhdl")


GEN_PROTOINST_FILES = $(shell find ${PWD}/build/xsim/build/ -name ".protoinst")
IPSHARED_DIR                = ${PWD}/build/xsim/build/ipshared
GENERATED_IPSHARED_DIRNAMES = $(shell ls ${IPSHARED_DIR})
GENERATED_IPSHARED_DIRS     = $(addprefix ${IPSHARED_DIR}/, ${GENERATED_IPSHARED_DIRNAMES})
GENERATED_IPSHARED_HDLDIRS  = $(addsuffix /hdl , ${GENERATED_IPSHARED_DIRS})
GENERATED_IPSHARED_VERILOGDIRS  = $(addsuffix /hdl/verilog , ${GENERATED_IPSHARED_DIRS})
GENERATED_IPSHARED_INCLUDE  = $(addprefix --include , ${GENERATED_IPSHARED_HDLDIRS} ${GENERATED_IPSHARED_VERILOGDIRS})
PROTOINST_DECLARE           = $(addprefix --protoinst , ${GEN_PROTOINST_FILES})

