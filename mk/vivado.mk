# Copyright 2021 Raphaël Bresson
# create destination folders
build/vivado:
	@mkdir -p $@
	@mkdir -p $@/build

build/vivado/script: | build/vivado
	@mkdir -p $@

# generate VHDL .vhd files package importer script
build/vivado/script/import_pkg_vhd.tcl: ${SYNTH_PKG_VHD_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_pkg_vhd.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_pkg_vhd.sh
	@touch build/vivado/script/save_pkg_vhd.sh
	@for f in `find rtl/synth -name *.vhd`; do \
	  cp $${f} build/vivado/build/; \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_pkg_vhd.sh; \
	done

# generate VHDL .vhdl files package importer script
build/vivado/script/import_pkg_vhdl.tcl: ${SYNTH_PKG_VHDL_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_pkg_vhdl.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_pkg_vhdl.sh
	@touch build/vivado/script/save_pkg_vhdl.sh
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/vivado/build/; \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_pkg_vhdl.sh; \
	done

# generate System Verilog .sv files package importer script
build/vivado/script/import_pkg_sv.tcl: ${SYNTH_PKG_SV_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_pkg_sv.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_pkg_sv.sh
	@touch build/vivado/script/save_pkg_sv.sh
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/vivado/build/; \
		echo "read_verilog -sv build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_pkg_sv.sh; \
	done

build/vivado/script/import_pkg.tcl: build/vivado/script/import_pkg_sv.tcl build/vivado/script/import_pkg_vhdl.tcl build/vivado/script/import_pkg_vhd.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/vivado/script/import_pkg_sv.tcl"    > $@
	@echo "source build/vivado/script/import_pkg_vhd.tcl"  >> $@
	@echo "source build/vivado/script/import_pkg_vhdl.tcl" >> $@

# generate contraints .xdc files importer script
build/vivado/script/import_xdc.tcl: ${CONSTR_XDC_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_xdc.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_xdc.sh
	@touch build/vivado/script/save_xdc.sh
	@for f in `find rtl/constr -name *.xdc`; do \
	  cp $${f} build/vivado/build/; \
		echo "read_xdc build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_xdc.sh; \
	done

# generate VHDL .vhd files importer script
build/vivado/script/import_vhd.tcl: ${SYNTH_VHD_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_vhd.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_vhd.sh
	@touch build/vivado/script/save_vhd.sh
	@for f in `find rtl/synth -name *.vhd`; do \
	  cp $${f} build/vivado/build/; \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_vhd.sh; \
	done

# generate VHDL .vhdl files importer script
build/vivado/script/import_vhdl.tcl: ${SYNTH_VHDL_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_vhd.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_vhdl.sh
	@touch build/vivado/script/save_vhdl.sh
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/vivado/build/; \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_vhdl.sh; \
	done

# generate VERILOG .v files importer script
build/vivado/script/import_verilog.tcl: ${SYNTH_V_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_verilog.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_verilog.sh
	@touch build/vivado/script/save_verilog.sh
	@for f in `find rtl/synth -name *.v`; do \
		cp $${f} build/vivado/build/; \
		echo "read_verilog build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_verilog.sh; \
	done

# generate SYSTEM VERILOG .sv files importer script
build/vivado/script/import_system_verilog.tcl: ${SYNTH_SV_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_system_verilog.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_system_verilog.sh
	@touch build/vivado/script/save_system_verilog.sh
	@for f in `find rtl/synth -name *.sv`; do \
		cp $${f} build/vivado/build; \
		echo "read_verilog -sv build/vivado/build/`basename $${f}`" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_system_verilog.sh; \
	done


# generate IP .xci files importer script
build/vivado/script/import_ips.tcl: ${SYNTH_XCI_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_ips.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_ips.sh
	@touch build/vivado/script/save_ips.sh
	@for f in `find rtl/synth -name *.xci`; do \
		cp $${f} build/vivado/build; \
		echo "read_ip build/vivado/build/`basename $${f}`" >> $@; \
		echo "set_property part ${PART} [current_project]" >> $@; \
		echo "set_property board_part ${BOARD} [current_project]" >> $@; \
		echo "set_property target_language ${RTL_LANGUAGE} [current_project]" >> $@; \
		echo "upgrade_ip -force [get_files build/vivado/`basename $${f}`]" >> $@; \
		echo "generate_target all [get_files build/vivado/`basename $${f}`] -force" >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/vivado/build/`basename $${f}`] -no_script -force" >> $@; \
		echo "export_simulation -directory \"build/vivado/sim\" -of_objects [get_files build/vivado/build/`basename $${f}`] -simulator xsim -force" >> $@; \
		echo "update_ip_catalog" >> $@; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_ips.sh; \
	done

# generate BLOCK DESIGN .bd files importer script
build/vivado/script/import_bds.tcl: ${SYNTH_BD_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@ and bash script ${PWD}/build/vivado/script/save_bds.sh"
	@rm -f $@
	@touch $@
	@rm -f build/vivado/script/save_bds.sh
	@touch build/vivado/script/save_bds.sh
	@for f in `find rtl/synth -name *.bd`; do \
		cp $${f} build/vivado/build; \
		echo "read_bd build/vivado/build/`basename $${f}`" >> $@; \
		echo "set_property part ${PART} [current_project]" >> $@; \
		echo "set_property board_part ${BOARD} [current_project]" >> $@; \
		echo "set_property target_language ${RTL_LANGUAGE} [current_project]" >> $@; \
		echo "generate_target all [get_files build/vivado/build/`basename $${f}`] -force" >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/vivado/build/`basename $${f}`] -no_script -force" >> $@; \
		echo "export_simulation -directory \"build/vivado/sim\" -of_objects [get_files build/vivado/build/`basename $${f}`] -simulator xsim -force" >> $@; \
		echo "make_wrapper -files [get_files build/vivado/build/`basename $${f}`] -top" >> $@; \
		if [[ "${RTL_LANGUAGE}" == "VHDL" ]]; then \
			echo "read_vhdl build/vivado/build/hdl/$$(basename $${f%.*})_wrapper.vhd" >> $@; \
		else \
			echo "read_verilog build/vivado/build/hdl/$$(basename $${f%.*})_wrapper.v" >> $@; \
		fi; \
		echo "cp build/vivado/build/`basename $${f}` $${f}" >> build/vivado/script/save_bds.sh; \
	done

# generate synthetisable files importer script
build/vivado/script/import_synth.tcl: build/vivado/script/import_xdc.tcl build/vivado/script/import_vhd.tcl build/vivado/script/import_vhdl.tcl build/vivado/script/import_verilog.tcl build/vivado/script/import_system_verilog.tcl build/vivado/script/import_bds.tcl build/vivado/script/import_ips.tcl build/vivado/script/import_xdc.tcl build/vivado/script/import_pkg.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/vivado/script/import_pkg.tcl"             > $@
	@echo "source build/vivado/script/import_vhd.tcl"            >> $@
	@echo "source build/vivado/script/import_vhdl.tcl"           >> $@
	@echo "source build/vivado/script/import_verilog.tcl"        >> $@
	@echo "source build/vivado/script/import_system_verilog.tcl" >> $@
	@echo "source build/vivado/script/import_ips.tcl"            >> $@
	@echo "source build/vivado/script/import_bds.tcl"            >> $@
	@echo "source build/vivado/script/import_xdc.tcl"            >> $@

build/vivado/script/save_synth_files.sh: build/vivado/script/import_synth.tcl
	@echo "### INFO: Generating bash script ${PWD}/$@"
	@echo "bash build/vivado/script/save_xdc.sh"             > $@
	@echo "bash build/vivado/script/save_vhd.sh"            >> $@
	@echo "bash build/vivado/script/save_vhdl.sh"           >> $@
	@echo "bash build/vivado/script/save_verilog.sh"        >> $@
	@echo "bash build/vivado/script/save_system_verilog.sh" >> $@
	@echo "bash build/vivado/script/save_ips.sh"            >> $@
	@echo "bash build/vivado/script/save_bds.sh"            >> $@

build/vivado/script/synth.tcl: build/vivado/script/import_synth.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/vivado/script/import_synth.tcl"                        > $@
	@echo "synth_design -top ${TOP}  -part ${PART}"                           >> $@
	@echo "report_timing_summary     -file build/vivado/synth_out/timing.rpt" >> $@
	@echo "report_power              -file build/vivado/synth_out/power.rpt"  >> $@
	@echo "write_verilog -force      -file build/vivado/synth_out/netlist.v"  >> $@
	@echo "write_checkpoint -force build/vivado/build/synth.dcp"              >> $@

# generate bitstream generator script
build/vivado/script/impl.tcl: build/vivado/script/synth.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "set_property part ${PART} [current_project]"                               > $@
	@echo "set_property board_part ${BOARD} [current_project]"                       >> $@
	@echo "opt_design"                                                               >> $@
	@echo "power_opt_design"                                                         >> $@
	@echo "place_design"                                                             >> $@
	@echo "phys_opt_design"                                                          >> $@
	@echo "route_design"                                                             >> $@
	@echo "report_timing_summary     -file build/vivado/impl_out/pr_timing.rpt"      >> $@
	@echo "report_clock_utilization  -file build/vivado/impl_out/pr_clock_util.rpt"  >> $@
	@echo "report_utilization        -file build/vivado/impl_out/pr_utilisation.rpt" >> $@
	@echo "report_power              -file build/vivado/impl_out/pr_power.rpt"       >> $@
	@echo "report_drc                -file build/vivado/impl_out/pr_drc.rpt"         >> $@
	@echo "write_verilog -force            build/vivado/impl_out/netlist.v"          >> $@
	@echo "write_xdc -no_fixed_only -force build/vivado/impl_out/bft.xdc"            >> $@
	@echo "write_checkpoint -force         build/vivado/build/impl.dcp"              >> $@
	@echo "write_bitstream -force          build/vivado/bitstream.bit"               >> $@
	@echo "write_hwdef -force              build/vivado/system.hdf"                  >> $@

build/vivado/import-synth.done: build/vivado/script/import_synth.tcl
	@rm -rf build/vivado/sim
	@echo "### INFO: importing and generate synthetisable files"
	@vivado -mode batch -source build/vivado/script/import_synth.tcl -nojournal -nolog
	@echo "DONE" > build/vivado/import-synth.done

build/vivado/build/synth.dcp: build/vivado/script/synth.tcl
	@rm -rf build/vivado/sim
	@rm -rf build/xsct
	@echo "### INFO: Launching synthesis with top level module: ${TOP}"
	@mkdir -p build/vivado/synth_out
	@vivado -mode batch -source build/vivado/script/synth.tcl -nojournal -log build/vivado/synth_out/synth.log
	@echo "### INFO: Synthesis terminated succesfully with top level module: ${TOP}"
	@echo "DONE" > build/vivado/import-synth.done

# generate hardware definition file (.hdf)
build/vivado/build/impl.dcp: build/vivado/script/impl.tcl build/vivado/build/synth.dcp
	@mkdir -p build/vivado/impl_out
	@echo "### INFO: Launching implementation for top level module: ${TOP}"
	@vivado -mode batch -source build/vivado/script/impl.tcl -nojournal build/vivado/build/synth.dcp -log build/vivado/impl_out/impl.log
	@cp build/vivado/bitstream.bit os/board/${BR2_BOARD}/fpga.bit
	@echo "### INFO: Bitstream and hardware definition file successfully created for top level module: ${TOP}"

build/vivado/system.hdf: build/vivado/build/impl.dcp

vivado-all: build/vivado/system.hdf

vivado-gui: build/vivado/script/save_synth_files.sh
	@echo "### INFO: Opening Vivado in gui mode"
	@vivado -nojournal -nolog -source build/vivado/script/import_synth.tcl
	@echo "Would you like to save the modified files? [y, N]"
	@read rc; \
	if [[ "$${rc}" == @(y|Y) ]]; then \
		echo "### INFO: Copying synthetizable files from ${PWD}/build/vivado/build to ${PWD}/rtl/synth"; \
		bash build/vivado/script/save_synth_files.sh; \
	else \
		echo "### INFO: Modified files from ${PWD}/build/vivado/build not saved"; \
		echo "### INFO: Modified files will be automatically restored on the next invocation of vivado"; \
		rm -f build/vivado/script/import_*; \
	fi
	@echo "DONE" > build/vivado/import-synth.done

vivado-gui-synth: build/vivado/build/synth.dcp
	@echo "### INFO: Opening Vivado synthetized design in gui mode"
	@vivado -nojournal -nolog build/vivado/build/synth.dcp

vivado-gui-impl: build/vivado/build/impl.dcp
	@echo "### INFO: Opening Vivado implemented design in gui mode"
	@vivado -nojournal -nolog build/vivado/build/impl.dcp

vivado-clean:
	@echo "### Cleaning vivado outputs"
	@rm -rf build/vivado
