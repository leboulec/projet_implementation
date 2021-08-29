# Copyright 2021 Raphaël Bresson

SYNTH_V_FILES    = $(shell find ${PWD}/rtl/synth/ -name "*.v"   )
SYNTH_SV_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.sv"  )
SYNTH_VHD_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.vhd" )
SYNTH_VHDL_FILES = $(shell find ${PWD}/rtl/synth/ -name "*.vhdl")
SYNTH_XCI_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.xci" )
SYNTH_BD_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.bd"  )

CONSTR_XDC_FILES = $(shell find ${PWD}/rtl/constr/ -name "*.xdc")

SIM_V_FILES    = $(shell find ${PWD}/rtl/sim/ -name "*.v"   )
SIM_SV_FILES   = $(shell find ${PWD}/rtl/sim/ -name "*.sv"  )
SIM_VHD_FILES  = $(shell find ${PWD}/rtl/sim/ -name "*.vhd" )
SIM_VHDL_FILES = $(shell find ${PWD}/rtl/sim/ -name "*.vhdl")


GEN_PROTOINST_FILES = $(shell find ${PWD}/build/vivado/build/ -name ".protoinst")
IPSHARED_DIR                = ${PWD}/build/vivado/build/ipshared
GENERATED_IPSHARED_DIRNAMES = $(shell ls ${IPSHARED_DIR})
GENERATED_IPSHARED_DIRS     = $(addprefix ${IPSHARED_DIR}/, ${GENERATED_IPSHARED_DIRNAMES})
GENERATED_IPSHARED_HDLDIRS  = $(addsuffix /hdl , ${GENERATED_IPSHARED_DIRS})
GENERATED_IPSHARED_VERILOGDIRS  = $(addsuffix /hdl/verilog , ${GENERATED_IPSHARED_DIRS})
GENERATED_IPSHARED_INCLUDE  = $(addprefix --include , ${GENERATED_IPSHARED_HDLDIRS} ${GENERATED_IPSHARED_VERILOGDIRS})
PROTOINST_DECLARE           = $(addprefix --protoinst , ${GEN_PROTOINST_FILES})

