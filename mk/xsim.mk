# Copyright 2021 Raphaël Bresson

SIM_SCRIPT=$(shell find build/xsim/sim/build/xsim/ -name *.sh)
DESIGN_NAME = $(notdir $(basename ${SIM_SCRIPT}))
SIM_ELAB_OPT = \
$(shell grep "xelab --relax" ${SIM_SCRIPT} | sed 's/xelab //g' \
                                   | sed 's/elaborate.log/build\/xsim\/elab.log/g' \
                                   | sed 's/${DESIGN_NAME}/${SIM_TOP}/g')
SIM_VHDL_OPT=$(shell grep "xvhdl_opts=" ${SIM_SCRIPT} | sed 's/xvhdl_opts=//g' | sed 's/\"//g') --work xil_defaultlib
SIM_VLOG_OPT=$(shell grep "xvlog_opts=" ${SIM_SCRIPT} | sed 's/xvlog_opts=//g' | sed 's/\"//g') --work xil_defaultlib ${GENERATED_IPSHARED_INCLUDE}

build/xsim:
	@mkdir -p $@
	@mkdir -p $@/build

build/xsim/script: | build/xsim
	@mkdir -p $@

# generate VHDL .vhd files package importer script
build/xsim/script/import_pkg_vhd.tcl: ${SYNTH_PKG_VHD_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/xsim/script/save_pkg_vhd.sh"
	@rm -f $@
	@touch $@
	@rm -f build/xsim/script/save_pkg_vhd.sh
	@touch build/xsim/script/save_pkg_vhd.sh
	@for f in `find rtl/synth -name *.vhd`; do \
	  cp $${f} build/xsim/build/; \
		echo "read_vhdl build/xsim/build/`basename $${f}`" >> $@; \
		echo "cp build/xsim/build/`basename $${f}` $${f}" >> build/xsim/script/save_pkg_vhd.sh; \
	done

# generate VHDL .vhdl files package importer script
build/xsim/script/import_pkg_vhdl.tcl: ${SYNTH_PKG_VHDL_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/xsim/script/save_pkg_vhdl.sh"
	@rm -f $@
	@touch $@
	@rm -f build/xsim/script/save_vhdl.sh
	@touch build/xsim/script/save_vhdl.sh
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/xsim/build/; \
		echo "read_vhdl build/xsim/build/`basename $${f}`" >> $@; \
		echo "cp build/xsim/build/`basename $${f}` $${f}" >> build/vivado/script/save_pkg_vhdl.sh; \
	done

# generate System Verilog .sv files package importer script
build/xsim/script/import_pkg_sv.tcl: ${SYNTH_PKG_SV_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/xsim/script/save_pkg_sv.sh"
	@rm -f $@
	@touch $@
	@rm -f build/xsim/script/save_vhdl.sh
	@touch build/xsim/script/save_vhdl.sh
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/xsim/build/; \
		echo "read_verilog -sv build/xsim/build/`basename $${f}`" >> $@; \
		echo "cp build/xsim/build/`basename $${f}` $${f}" >> build/xsim/script/save_pkg_sv.sh; \
	done

build/xsim/script/import_pkg.tcl: build/xsim/script/import_pkg_sv.tcl build/xsim/script/import_pkg_vhdl.tcl build/xsim/script/import_pkg_vhd.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/xsim/script/import_pkg_sv.tcl"    > $@
	@echo "source build/xsim/script/import_pkg_vhd.tcl"  >> $@
	@echo "source build/xsim/script/import_pkg_vhdl.tcl" >> $@

# generate contraints .xdc files importer script
build/xsim/script/import_xdc.tcl: ${CONSTR_XDC_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/constr -name *.xdc`; do \
	  cp $${f} build/xsim/build/; \
		echo "read_xdc build/xsim/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhd files importer script
build/xsim/script/import_vhd.tcl: ${SYNTH_VHD_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhd`; do \
	  cp $${f} build/xsim/build/; \
		echo "read_vhdl build/xsim/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhdl files importer script
build/xsim/script/import_vhdl.tcl: ${SYNTH_VHDL_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/xsim/build/; \
		echo "read_vhdl build/xsim/build/`basename $${f}`" >> $@; \
	done

# generate VERILOG .v files importer script
build/xsim/script/import_verilog.tcl: ${SYNTH_V_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.v`; do \
		cp $${f} build/xsim/build/; \
		echo "read_verilog build/xsim/build/`basename $${f}`" >> $@; \
	done

# generate SYSTEM VERILOG .sv files importer script
build/xsim/script/import_system_verilog.tcl: ${SYNTH_SV_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.sv`; do \
		cp $${f} build/xsim/build; \
		echo "read_verilog -sv build/xsim/build/`basename $${f}`" >> $@; \
	done


# generate IP .xci files importer script
build/xsim/script/import_ips.tcl: ${SYNTH_XCI_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xci`; do \
		cp $${f} build/xsim/build; \
		echo "read_ip build/xsim/build/`basename $${f}`" >> $@; \
		echo "set_property part ${PART} [current_project]" >> $@; \
		echo "set_property board_part ${BOARD} [current_project]" >> $@; \
		echo "set_property target_language Verilog [current_project]" >> $@; \
		echo "generate_target all [get_files build/xsim/`basename $${f}`] -force" >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/xsim/build/`basename $${f}`] -no_script -force" >> $@; \
		echo "export_simulation -directory \"build/xsim/sim\" -of_objects [get_files build/xsim/build/`basename $${f}`] -simulator xsim -force" >> $@; \
		echo "update_ip_catalog" >> $@; \
	done

# generate BLOCK DESIGN .bd files importer script
build/xsim/script/import_bds.tcl: ${SYNTH_BD_FILES} | build/xsim/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.bd`; do \
		cp $${f} build/xsim/build; \
		echo "read_bd build/xsim/build/`basename $${f}`" >> $@; \
		echo "set_property part ${PART} [current_project]" >> $@; \
		echo "set_property board_part ${BOARD} [current_project]" >> $@; \
		echo "set_property target_language Verilog [current_project]" >> $@; \
		echo "generate_target all [get_files build/xsim/build/`basename $${f}`] -force" >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/xsim/build/`basename $${f}`] -no_script -force" >> $@; \
		echo "export_simulation -directory \"build/xsim/sim\" -of_objects [get_files build/xsim/build/`basename $${f}`] -simulator xsim -force" >> $@; \
		echo "make_wrapper -files [get_files build/xsim/build/`basename $${f}`] -top" >> $@; \
		echo "read_verilog build/xsim/build/hdl/$$(basename $${f%.*})_wrapper.v" >> $@; \
	done


build/xsim/script/import_synth.tcl: build/xsim/script/import_xdc.tcl build/xsim/script/import_vhd.tcl build/xsim/script/import_vhdl.tcl build/xsim/script/import_verilog.tcl build/xsim/script/import_system_verilog.tcl build/xsim/script/import_bds.tcl build/xsim/script/import_ips.tcl build/xsim/script/import_xdc.tcl build/xsim/script/import_pkg.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/xsim/script/import_pkg.tcl"             > $@
	@echo "source build/xsim/script/import_vhd.tcl"            >> $@
	@echo "source build/xsim/script/import_vhdl.tcl"           >> $@
	@echo "source build/xsim/script/import_verilog.tcl"        >> $@
	@echo "source build/xsim/script/import_system_verilog.tcl" >> $@
	@echo "source build/xsim/script/import_ips.tcl"            >> $@
	@echo "source build/xsim/script/import_bds.tcl"            >> $@
	@echo "source build/xsim/script/import_xdc.tcl"            >> $@

build/xsim/import-synth.done: build/xsim/script/import_synth.tcl
	@rm -rf build/xsim/sim
	@echo "### INFO: importing and generate synthetisable files"
	@vivado -mode batch -source build/xsim/script/import_synth.tcl -nojournal -nolog
	@echo "DONE" > build/xsim/import-synth.done

sim: build/xsim/import-synth.done
	@mkdir -p build/xsim/log
	@echo "### INFO: RTL Simulation"
	@echo "### INFO: Simulation top level module: ${SIM_TOP}"
	@echo "### INFO: Generating tcl script build/xsim/script/xsim.tcl"
	@echo "log_wave -r *" > build/xsim/script/xsim.tcl
	@echo "### INFO: Parsing simulation files"
	@xvhdl ${SIM_VHDL_OPT} -prj build/xsim/sim/build/xsim/vhdl.prj -log build/xsim/log/xvhdl.log
	@xvlog ${SIM_VLOG_OPT} -prj build/xsim/sim/build/xsim/vlog.prj -log build/xsim/log/xvlog.log
	@bd_wrapper_verilog=`find build/xsim/build/hdl -name *.v`; \
	xvlog ${SIM_VLOG_OPT} $${bd_wrapper_verilog} ${SIM_V_FILES} ${SYNTH_V_FILES} -log build/xsim/log/verilog.log; \
	if [[ "${SIM_SV_FILES} ${SYNTH_SV_FILES}" == *[!\ ]* ]]; then \
		xvlog -sv ${SIM_VLOG_OPT} ${SIM_SV_FILES} ${SYNTH_SV_FILES} -log build/xsim/log/systemverilog.log; \
	fi; \
	if [[ "${SIM_VHD_FILES} ${SYNTH_VHD_FILES}" == *[!\ ]* ]]; then \
		xvhdl ${SIM_VHDL_OPT} ${SIM_VHD_FILES} ${SYNTH_VHD_FILES} -log build/xsim/log/vhd.log; \
	fi; \
	if [[ "${SIM_VHDL_FILES} ${SYNTH_VHDL_FILES}" == *[!\ ]* ]]; then \
		xvhdl ${SIM_VHDL_OPT} ${SIM_VHDL_FILES} ${SYNTH_VHDL_FILES} -log build/xsim/log/vhdl.log; \
	fi;
	@echo "### INFO: Elaborating design with top: ${SIM_TOP}"
	@xelab ${SIM_ELAB_OPT}
	@echo "### INFO: Launching simulation with top: ${SIM_TOP}"
	@if [ "${SIM_MODE}" == "gui" ]; then \
		xsim ${SIM_TOP} ${PROTOINST_DECLARE} -tclbatch build/xsim/script/xsim.tcl -gui -log build/xsim/log/xsim.log -wdb build/xsim/${SIM_TOP}.wdb; \
	else \
		xsim ${SIM_TOP} ${PROTOINST_DECLARE} -R -log build/xsim/log/xsim.log -wdb build/xsim/${SIM_TOP}.wdb; \
	fi;

sim-clean:
	@echo "### INFO: Cleaning simulation outputs"
	@rm -rf build/xsim xsim.dir *.pb *.log *.dir *.jou *.wdb
