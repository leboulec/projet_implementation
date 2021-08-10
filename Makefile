# Copyright 2021 Raphaël Bresson
TOP        ?= design_1_wrapper
PART       ?= xc7z020clg484-1
BOARD      ?= em.avnet.com:zed:part0:1.3
SIM_MODE   ?= gui
SIM_TOP    ?= tb_top

all: buildroot-update

clean: vivado-clean xsct-clean buildroot-clean sim-clean
	@rm -rf *.html *.xml *.zip build/

include mk/find-files.mk
include mk/vivado.mk
include mk/xsct.mk
include mk/xsim.mk
include mk/buildroot.mk
