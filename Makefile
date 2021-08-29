# Copyright 2021 Raphaël Bresson

# VIVADO USER CONFIG
TOP        ?= projet_implementation_top_vhdl
PART       ?= xc7z020clg484-1
BOARD      ?= em.avnet.com:zed:part0:1.3
RTL_LANGUAGE ?= VHDL
#RTL_LANGUAGE ?= Verilog

# SIMULATION USER CONFIG
SIM_MODE   ?= gui
SIM_TOP    ?= tb_top

# XSCT USER CONFIG
XSCT_BOARD ?= zedboard

# BUILDROOT USER CONFIG
BR2_BOARD  ?= zynq-zedboard
BR2_DEFCONFIG  ?= zynq_zedboard_defconfig

all: buildroot-update

clean: vivado-clean xsct-clean buildroot-clean sim-clean
	@rm -rf *.html *.xml *.zip .Xil/ build/ *.str

include mk/find-files.mk
include mk/vivado.mk
include mk/xsct.mk
include mk/xsim.mk
include mk/buildroot.mk
