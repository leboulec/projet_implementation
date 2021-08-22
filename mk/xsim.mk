# Copyright 2021 Raphaël Bresson

SIM_SCRIPT=$(shell find build/vivado/sim/build/xsim/ -name *.sh)
DESIGN_NAME = $(notdir $(basename ${SIM_SCRIPT}))
SIM_ELAB_OPT = \
$(shell grep "xelab --relax" ${SIM_SCRIPT} | sed 's/xelab //g' \
                                   | sed 's/elaborate.log/build\/xsim\/elab.log/g' \
                                   | sed 's/${DESIGN_NAME}/${SIM_TOP}/g')
SIM_VHDL_OPT=$(shell grep "xvhdl_opts=" ${SIM_SCRIPT} | sed 's/xvhdl_opts=//g' | sed 's/\"//g') --work xil_defaultlib
SIM_VLOG_OPT=$(shell grep "xvlog_opts=" ${SIM_SCRIPT} | sed 's/xvlog_opts=//g' | sed 's/\"//g') --work xil_defaultlib ${GENERATED_IPSHARED_INCLUDE}

sim: build/vivado/import-synth.done
	@mkdir -p build/xsim
	@echo "### INFO: RTL Simulation"
	@echo "### INFO: Simulation top level module: ${SIM_TOP}"
	@echo "### INFO: Generating tcl script build/xsim/xsim.tcl"
	@echo "log_wave -r *" > build/xsim/xsim.tcl
	@echo "### INFO: Parsing simulation files"
	@if [[ "${SIM_SV_FILES} ${SYNTH_SV_FILES}" == *[!\ ]* ]]; then                                                                                          \
		xvlog -sv ${SIM_VLOG_OPT} ${SIM_SV_FILES} ${SYNTH_SV_FILES} -log build/xsim/systemverilog.log;                                                       \
	fi;                                                                                                                                    \
	if [[ "${SIM_VHDL_FILES} ${SYNTH_VHDL_FILES}" == *[!\ ]* ]]; then                                                                                         \
		xvhdl ${SIM_VHDL_OPT} ${SIM_VHDL_FILES} ${SYNTH_VHDL_FILES} -log build/xsim/vhdl.log;                                                                  \
	fi;                                                                                                                                    \
	if [[ "${SIM_VHD_FILES} ${SYNTH_VHD_FILES}" == *[!\ ]* ]]; then                                                                                          \
		xvhdl ${SIM_VHDL_OPT} ${SIM_VHD_FILES} ${SYNTH_VHD_FILES} -log build/xsim/vhd.log;                                                                    \
	fi;                                                                                                                                    \
	if [[ "${SIM_V_FILES} ${SYNTH_V_FILES}" == *[!\ ]* ]]; then                                                                                            \
		xvlog ${SIM_VLOG_OPT} ${SIM_V_FILES} ${SYNTH_V_FILES} -log build/xsim/verilog.log;                                                                  \
	fi
	@xvhdl ${SIM_VHDL_OPT} -prj build/vivado/sim/build/xsim/vhdl.prj -log build/xsim/xvhdl.log
	@xvlog ${SIM_VLOG_OPT} -prj build/vivado/sim/build/xsim/vlog.prj -log build/xsim/xvlog.log
	@echo "### INFO: Elaborating design with top: ${SIM_TOP}"
	@xelab ${SIM_ELAB_OPT}
	@echo "### INFO: Launching simulation with top: ${SIM_TOP}"
	@if [ "${SIM_MODE}" == "gui" ]; then                                                                                                    \
		xsim ${SIM_TOP} ${PROTOINST_DECLARE} -tclbatch build/xsim/xsim.tcl -gui -log build/xsim/xsim.log -wdb build/xsim/${SIM_TOP}.wdb; \
	else                                                                                                                                   \
		xsim ${SIM_TOP}_sim ${PROTOINST_DECLARE} -R -log build/xsim/xsim.log -wdb build/xsim/${SIM_TOP}.wdb;                                 \
	fi;

sim-clean:
	@echo "### INFO: Cleaning simulation outputs"
	@rm -rf build/xsim xsim.dir *.pb *.log *.dir *.jou *.wdb
