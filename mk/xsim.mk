# Copyright 2021 Raphaël Bresson
sim: build/vivado/import-synth.done
	@mkdir -p build/xsim
	@echo "log_wave -r *" > build/xsim/xsim.tcl
	@xvlog -sv ${XSIM_VLOG_OPT} ${XILINX_VIVADO}/data/verilog/src/glbl.v -log build/xsim/glbl.log
	@if [[ "${XSIM_SV_FILES}" == *[!\ ]* ]]; then                                                                                          \
		xvlog -sv ${XSIM_VLOG_OPT} ${XSIM_SV_FILES} -log build/xsim/systemverilog.log;                                                       \
	fi;                                                                                                                                    \
	if [[ "${XSIM_VHDL_FILES}" == *[!\ ]* ]]; then                                                                                         \
		xvhdl ${XSIM_VHDL_OPT} ${XSIM_VHDL_FILES} -log build/xsim/vhdl.log;                                                                  \
	fi;                                                                                                                                    \
	if [[ "${XSIM_VHD_FILES}" == *[!\ ]* ]]; then                                                                                          \
		xvhdl ${XSIM_VHDL_OPT} ${XSIM_VHD_FILES} -log build/xsim/vhd.log;                                                                    \
	fi;                                                                                                                                    \
	if [[ "${XSIM_V_FILES}" == *[!\ ]* ]]; then                                                                                            \
		xvlog ${XSIM_VLOG_OPT} ${XSIM_V_FILES} -log build/xsim/verilog.log;                                                                  \
	fi;                                                                                                                                    \
	xelab ${XSIM_ELAB_OPT} simwork.${SIM_TOP} simwork.glbl -s ${SIM_TOP}_sim -log build/xsim/elab.log;                                     \
	if [ "${SIM_MODE}" == "gui" ]; then                                                                                                    \
		xsim ${SIM_TOP}_sim ${PROTOINST_DECLARE} -tclbatch build/xsim/xsim.tcl -gui -log build/xsim/xsim.log -wdb build/xsim/${SIM_TOP}.wdb; \
	else                                                                                                                                   \
		xsim ${SIM_TOP}_sim ${PROTOINST_DECLARE} -R -log build/xsim/xsim.log -wdb build/xsim/${SIM_TOP}.wdb;                                 \
	fi;

sim-clean:
	@rm -rf build/xsim xsim.dir *.pb *.log *.dir *.jou *.wdb
