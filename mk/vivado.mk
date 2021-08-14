# Copyright 2021 Raphaël Bresson
# create destination folders
build/vivado:
	@mkdir -p $@
	@mkdir -p $@/build

build/vivado/script: | build/vivado
	@mkdir -p $@

# generate contraints .xdc files importer script
build/vivado/script/import_xdc.tcl: ${CONTR_XDC_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xdc`; do             \
	  cp $${f} build/vivado/build/;                        \
		echo "read_xdc build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhd files importer script
build/vivado/script/import_vhd.tcl: ${SYNTH_VHD_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhd`; do              \
	  cp $${f} build/vivado/build/;                         \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhdl files importer script
build/vivado/script/import_vhdl.tcl: ${SYNTH_VHDL_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhdl`; do             \
		cp $${f} build/vivado/build/;                          \
		echo "read_vhdl build/vivado/build/`basename $${f}`" >> $@; \
	done

# generate VERILOG .v files importer script
build/vivado/script/import_verilog.tcl: ${SYNTH_V_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.v`; do                    \
		cp $${f} build/vivado/build/;                              \
		echo "read_verilog build/vivado/build/`basename $${f}`" >> $@;  \
	done

# generate SYSTEM VERILOG .sv files importer script
build/vivado/script/import_system_verilog.tcl: ${SYNTH_SV_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.sv`; do                       \
		cp $${f} build/vivado/build;                                  \
		echo "read_verilog -sv build/vivado/build/`basename $${f}`" >> $@;  \
	done

# generate IP .xci files importer script
build/vivado/script/import_ips.tcl: ${SYNTH_XCI_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xci`; do                                    \
		cp $${f} build/vivado/build;                                                \
		echo "read_ip build/vivado/build/`basename $${f}`"                   >> $@; \
		echo "set_property part ${PART} [current_project]"                   >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"            >> $@; \
		echo "set_property target_language VHDL [current_project]"           >> $@; \
		echo "generate_target all [get_files build/vivado/`basename $${f}`]" >> $@; \
	done

# generate BLOCK DESIGN .bd files importer script
build/vivado/script/import_bds.tcl: ${SYNTH_BD_FILES} | build/vivado/script
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.bd`; do                                                   \
		cp $${f} build/vivado/build;                                                              \
		echo "read_bd build/vivado/build/`basename $${f}`"                                 >> $@; \
		echo "set_property part ${PART} [current_project]"                                 >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"                          >> $@; \
		echo "set_property target_language VHDL [current_project]"                         >> $@; \
		echo "generate_target all [get_files build/vivado/build/`basename $${f}`] -force"  >> $@; \
		echo "make_wrapper -files [get_files build/vivado/`basename $${f}`] -top"          >> $@; \
		echo "read_vhdl build/vivado/build/hdl/$$(basename $${f%.*})_wrapper.vhd"          >> $@; \
	done

# generate synthetisable files importer script
build/vivado/script/import_synth.tcl: build/vivado/script/import_xdc.tcl build/vivado/script/import_vhd.tcl build/vivado/script/import_vhdl.tcl build/vivado/script/import_verilog.tcl build/vivado/script/import_system_verilog.tcl build/vivado/script/import_bds.tcl build/vivado/script/import_ips.tcl build/vivado/script/import_xdc.tcl
	@echo "source build/vivado/script/import_vhd.tcl"             > $@
	@echo "source build/vivado/script/import_vhdl.tcl"           >> $@
	@echo "source build/vivado/script/import_verilog.tcl"        >> $@
	@echo "source build/vivado/script/import_system_verilog.tcl" >> $@
	@echo "source build/vivado/script/import_ips.tcl"            >> $@
	@echo "source build/vivado/script/import_bds.tcl"            >> $@
	@echo "source build/vivado/script/import_xdc.tcl"            >> $@

# generate bitstream generator script
build/vivado/script/impl.tcl: build/vivado/script/import_synth.tcl
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
	@mkdir -p build/vivado/synth_out build/vivado/impl_out
	@vivado -mode batch -source $< -nojournal -nolog
	@cp build/vivado/bitstream.bit os/board/zynq-zedboard/fpga.bit
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done

build/vivado/import-synth.done: build/vivado/script/import_synth.tcl
	@vivado -mode batch -source $< -nojournal -nolog
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done

vivado-all: build/vivado/system.hdf

vivado-gui: build/vivado/import_synth.tcl
	@vivado -nojournal -nolog -source $<

vivado-clean:
	@rm -rf build/vivado

