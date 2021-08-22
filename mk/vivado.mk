# Copyright 2021 Raphaël Bresson
# create destination folders
build/vivado:
	@mkdir -p $@
	@mkdir -p $@/build

build/vivado/script: | build/vivado
	@mkdir -p $@

# generate contraints .xdc files importer script
build/vivado/script/import_xdc.tcl: ${CONSTR_XDC_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xdc`; do             \
	  cp $${f} build/vivado/build/;                        \
		echo "read_xdc build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhd files importer script
build/vivado/script/import_vhd.tcl: ${SYNTH_VHD_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhd`; do              \
	  cp $${f} build/vivado/build/;                         \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhdl files importer script
build/vivado/script/import_vhdl.tcl: ${SYNTH_VHDL_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhdl`; do             \
		cp $${f} build/vivado/build/;                          \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VERILOG .v files importer script
build/vivado/script/import_verilog.tcl: ${SYNTH_V_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.v`; do                    \
		cp $${f} build/vivado/build/;                              \
		echo "read_verilog build/vivado/build/`basename $${f}`" >> $@;  \
	done

# generate SYSTEM VERILOG .sv files importer script
build/vivado/script/import_system_verilog.tcl: ${SYNTH_SV_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.sv`; do                       \
		cp $${f} build/vivado/build;                                  \
		echo "read_verilog -sv build/vivado/build/`basename $${f}`" >> $@;  \
	done

# generate IP .xci files importer script
build/vivado/script/import_ips.tcl: ${SYNTH_XCI_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xci`; do                                    \
		cp $${f} build/vivado/build;                                                \
		echo "read_ip build/vivado/build/`basename $${f}`"                   >> $@; \
		echo "set_property part ${PART} [current_project]"                   >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"            >> $@; \
		echo "set_property target_language VHDL [current_project]"           >> $@; \
		echo "generate_target all [get_files build/vivado/`basename $${f}`] -force" >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/vivado/build/`basename $${f}`] -no_script -force" >> $@; \
		echo "export_simulation -directory \"build/vivado/sim\" -of_objects [get_files build/vivado/build/`basename $${f}`] -simulator xsim -force" >> $@; \
	done

# generate BLOCK DESIGN .bd files importer script
build/vivado/script/import_bds.tcl: ${SYNTH_BD_FILES} | build/vivado/script
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.bd`; do                                                                                                            \
		cp $${f} build/vivado/build;                                                                                                                       \
		echo "read_bd build/vivado/build/`basename $${f}`"                                                                                          >> $@; \
		echo "set_property part ${PART} [current_project]"                                                                                          >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"                                                                                   >> $@; \
		echo "set_property target_language VHDL [current_project]"                                                                                  >> $@; \
		echo "generate_target all [get_files build/vivado/build/`basename $${f}`] -force"                                                           >> $@; \
		echo "export_ip_user_files -of_objects [get_files build/vivado/build/`basename $${f}`] -no_script -force"                                   >> $@; \
		echo "export_simulation -directory \"build/vivado/sim\" -of_objects [get_files build/vivado/build/`basename $${f}`] -simulator xsim -force" >> $@; \
		echo "make_wrapper -files [get_files build/vivado/build/`basename $${f}`] -top"                                                             >> $@; \
		echo "read_vhdl build/vivado/build/hdl/$$(basename $${f%.*})_wrapper.vhd"                                                                   >> $@; \
	done

# generate synthetisable files importer script
build/vivado/script/import_synth.tcl: build/vivado/script/import_xdc.tcl build/vivado/script/import_vhd.tcl build/vivado/script/import_vhdl.tcl build/vivado/script/import_verilog.tcl build/vivado/script/import_system_verilog.tcl build/vivado/script/import_bds.tcl build/vivado/script/import_ips.tcl build/vivado/script/import_xdc.tcl
	@echo "### INFO: Generating tcl script $@"
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source build/vivado/script/import_vhd.tcl"             > $@
	@echo "source build/vivado/script/import_vhdl.tcl"           >> $@
	@echo "source build/vivado/script/import_verilog.tcl"        >> $@
	@echo "source build/vivado/script/import_system_verilog.tcl" >> $@
	@echo "source build/vivado/script/import_ips.tcl"            >> $@
	@echo "source build/vivado/script/import_bds.tcl"            >> $@
	@echo "source build/vivado/script/import_xdc.tcl"            >> $@

# generate bitstream generator script
build/vivado/script/impl.tcl: build/vivado/script/import_synth.tcl
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "source $<"                                                                 > $@
	@echo "synth_design -top ${TOP}  -part ${PART}"                                  >> $@
	@echo "report_timing_summary     -file build/vivado/synth_out/timing.rpt"        >> $@
	@echo "report_power              -file build/vivado/synth_out/power.rpt"         >> $@
	@echo "write_verilog -force      -file build/vivado/synth_out/netlist.v"         >> $@
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
	@echo "write_bitstream -force          build/vivado/bitstream.bit"               >> $@
	@echo "write_hwdef -force              build/vivado/system.hdf"                  >> $@

# generate hardware definition file (.hdf)
build/vivado/system.hdf: build/vivado/script/impl.tcl
	@rm -rf build/vivado/sim
	@mkdir -p build/vivado/synth_out build/vivado/impl_out
	@echo "### INFO: Generating bitstream and hardware definition file for top level module: ${TOP}"
	@vivado -mode batch -source $< -nojournal -nolog
	@cp build/vivado/bitstream.bit os/board/zynq-zedboard/fpga.bit
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done
	@echo "### INFO: Bitstream and hardware definition file successfully created"

build/vivado/import-synth.done: build/vivado/script/import_synth.tcl
	@rm -rf build/vivado/sim
	@echo "### INFO: Importing and generating synthetizable files"
	@vivado -mode batch -source $< -nojournal -nolog
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done

vivado-all: build/vivado/system.hdf

vivado-gui: build/vivado/script/import_synth.tcl
	@echo "### INFO: Opening Vivado in gui mode"
	@vivado -nojournal -nolog -source $<
	@echo "Would you like to save the modified files? [y, N]"
	@read rc; \
	if [[ "$${rc}" == @(y|Y) ]]; then \
		echo "### INFO: Copying synthetizable files from ${PWD}/build/vivado/build to ${PWD}/rtl/synth"; \
		cp build/vivado/build/*.bd rtl/synth 2>/dev/null || :; \
		cp build/vivado/build/*.v rtl/synth 2>/dev/null || :; \
		cp build/vivado/build/*.sv rtl/synth 2>/dev/null || :; \
		cp build/vivado/build/*.vhd rtl/synth 2>/dev/null || :; \
		cp build/vivado/build/*.vhdl rtl/synth 2>/dev/null || :; \
		cp build/vivado/build/*.xci rtl/synth 2>/dev/null || :; \
		for f in `ls build/vivado/build/ | grep ".xdc" | grep -v "_ooc"`; do \
		  cp -f build/vivado/build/$${f} rtl/constr/; \
		done \
	else \
		echo "### INFO: Modified files from ${PWD}/build/vivado/build not saved"; \
		echo "### INFO: Files will be automatically restored on the next invocation of vivado" \
		rm -f build/vivado/scripts/import_*; \
	fi
	@touch build/vivado/import-synth.done

vivado-clean:
	@echo "### Cleaning vivado outputs"
	@rm -rf build/vivado

