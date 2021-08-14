# Copyright 2021 Raphaël Bresson

SYNTH_V_FILES    = $(shell find ${PWD}/rtl/synth/ -name "*.v"   )
SYNTH_SV_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.sv"  )
SYNTH_VHD_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.vhd" )
SYNTH_VHDL_FILES = $(shell find ${PWD}/rtl/synth/ -name "*.vhdl")
SYNTH_XCI_FILES  = $(shell find ${PWD}/rtl/synth/ -name "*.xci" )
SYNTH_BD_FILES   = $(shell find ${PWD}/rtl/synth/ -name "*.bd"  )

CONSTR_XDC_FILES = $(shell find ${PWD}/rtl/constr/ -name "*.xdc"

SIM_V_FILES    = $(shell find ${PWD}/rtl/sim/ -name "*.v"   )
SIM_SV_FILES   = $(shell find ${PWD}/rtl/sim/ -name "*.sv"  )
SIM_VHD_FILES  = $(shell find ${PWD}/rtl/sim/ -name "*.vhd" )
SIM_VHDL_FILES = $(shell find ${PWD}/rtl/sim/ -name "*.vhdl")

GEN_IP_V_FILES    = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.v"    | grep 'sim')
GEN_IP_SV_FILES   = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.sv"   | grep 'sim')
GEN_IP_VHD_FILES  = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.vhd"  | grep 'sim')
GEN_IP_VHDL_FILES = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.vhdl" | grep 'sim')

GEN_IP_SYNTH_V_FILES    = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.v"    | grep 'synth')
GEN_IP_SYNTH_SV_FILES   = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.sv"   | grep 'synth')
GEN_IP_SYNTH_VHD_FILES  = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.vhd"  | grep 'synth')
GEN_IP_SYNTH_VHDL_FILES = $(shell find ${PWD}/build/vivado/build/ip/ -name "*.vhdl" | grep 'synth')

GEN_SIM_V_FILES    = $(shell find ${PWD}/build/vivado/build/sim -name "*.v"   )
GEN_SIM_SV_FILES   = $(shell find ${PWD}/build/vivado/build/sim -name "*.sv"  )
GEN_SIM_VHD_FILES  = $(shell find ${PWD}/build/vivado/build/sim -name "*.vhd" )
GEN_SIM_VHDL_FILES = $(shell find ${PWD}/build/vivado/build/sim -name "*.vhdl")

GEN_SYNTH_V_FILES    = $(shell find ${PWD}/build/vivado/build/synth -name "*.v"   )
GEN_SYNTH_SV_FILES   = $(shell find ${PWD}/build/vivado/build/synth -name "*.sv"  )
GEN_SYNTH_VHD_FILES  = $(shell find ${PWD}/build/vivado/build/synth -name "*.vhd" )
GEN_SYNTH_VHDL_FILES = $(shell find ${PWD}/build/vivado/build/synth -name "*.vhdl")

GEN_WRAPPER_V_FILES    = $(shell find ${PWD}/build/vivado/build/hdl -name "*.v"   )
GEN_WRAPPER_SV_FILES   = $(shell find ${PWD}/build/vivado/build/hdl -name "*.sv"  )
GEN_WRAPPER_VHD_FILES  = $(shell find ${PWD}/build/vivado/build/hdl -name "*.vhd" )
GEN_WRAPPER_VHDL_FILES = $(shell find ${PWD}/build/vivado/build/hdl -name "*.vhdl")

GEN_PROTOINST_FILES = $(shell find ${PWD}/build/vivado/build/ -name ".protoinst")

GEN_V_FILES    = ${GEN_IP_V_FILES}    ${GEN_SIM_V_FILES}    ${GEN_WRAPPER_V_FILES}
GEN_SV_FILES   = ${GEN_IP_SV_FILES}   ${GEN_SIM_SV_FILES}   ${GEN_WRAPPER_SV_FILES}
GEN_VHD_FILES  = ${GEN_IP_VHD_FILES}  ${GEN_SIM_VHD_FILES}  ${GEN_WRAPPER_VHD_FILES}
GEN_VHDL_FILES = ${GEN_IP_VHDL_FILES} ${GEN_SIM_VHDL_FILES} ${GEN_WRAPPER_VHDL_FILES}

XSIM_V_FILES    = ${SYNTH_V_FILES}    ${SIM_V_FILES}    ${GEN_V_FILES}
XSIM_SV_FILES   = ${SYNTH_SV_FILES}   ${SIM_SV_FILES}   ${GEN_SV_FILES}
XSIM_VHD_FILES  = ${SYNTH_VHD_FILES}  ${SIM_VHD_FILES}  ${GEN_VHD_FILES}
XSIM_VHDL_FILES = ${SYNTH_VHDL_FILES} ${SIM_VHDL_FILES} ${GEN_VHDL_FILES}

XILINX_VIP_DIR     = ${XILINX_VIVADO}/data/xilinx_vip/
XILINX_VIP_INCLUDE = --include "${XILINX_VIP_DIR}/include" --include "${XILINX_VIP_DIR}/hdl"

IPSHARED_DIR                = ${PWD}/build/vivado/build/ipshared
GENERATED_IPSHARED_DIRNAMES = $(shell ls ${IPSHARED_DIR})
GENERATED_IPSHARED_DIRS     = $(addprefix ${IPSHARED_DIR}/, ${GENERATED_IPSHARED_DIRNAMES})
GENERATED_IPSHARED_HDLDIRS  = $(addsuffix /hdl , ${GENERATED_IPSHARED_DIRS})
GENERATED_IPSHARED_INCLUDE  = $(addprefix --include , ${GENERATED_IPSHARED_HDLDIRS})
PROTOINST_DECLARE           = $(addprefix --protoinst , ${GEN_PROTOINST_FILES})

XSIM_VLOG_INCLUDE   = ${XILINX_VIP_INCLUDE} ${GENERATED_IPSHARED_INCLUDE}
XSIM_ELAB_LIBRARIES = -L xpm -L unisims_ver -L unimacro_ver -L secureip -L simwork -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xil_defaultlib -L xilinx_vip
XSIM_ELAB_FLAGS     = --incr --relax --debug typical
XSIM_VLOG_OPT       = --incr ${XSIM_VLOG_INCLUDE} --work simwork ${XSIM_ELAB_LIBRARIES}
XSIM_VHDL_OPT       = --incr --work simwork ${XSIM_ELAB_LIBRARIES}
XSIM_ELAB_OPT       = ${XSIM_ELAB_LIBRARIES} ${XSIM_ELAB_FLAGS}

