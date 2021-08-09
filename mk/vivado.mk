# Copyright 2021 Raphaël Bresson
# create destination folders
build/vivado:
	@mkdir -p build/vivado

# generate contraints .xdc files importer script
build/vivado/import_xdc.tcl: ${CONTR_XDC_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xdc`; do             \
	  cp $${f} build/vivado/;                              \
		echo "read_xdc build/vivado/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhd files importer script
build/vivado/import_vhd.tcl: ${SYNTH_VHD_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhd`; do              \
	  cp $${f} build/vivado/;                               \
		echo "read_vhdl build/vivado/`basename $${f}`" >> $@; \
	done

# generate VHDL .vhdl files importer script
build/vivado/import_vhdl.tcl: ${SYNTH_VHDL_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.vhdl`; do \
		cp $${f} build/vivado/;                \
		echo "read_vhdl build/vivado/`basename $${f}`" >> $@; \
	done

# generate VERILOG .v files importer script
build/vivado/import_verilog.tcl: ${SYNTH_V_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.v`; do                 \
		cp $${f} build/vivado/;                                \
		echo "read_verilog build/vivado/`basename $${f}`" >> $@;  \
	done

# generate SYSTEM VERILOG .sv files importer script
build/vivado/import_system_verilog.tcl: ${SYNTH_SV_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.sv`; do         \
		cp $${f} build/vivado/;                         \
		echo "read_verilog -sv build/vivado/`basename $${f}`" >> $@;  \
	done

# generate IP .xci files importer script
build/vivado/import_ips.tcl: ${SYNTH_XCI_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.xci`; do                                    \
		cp $${f} build/vivado/;                                                     \
		echo "read_ip build/vivado/`basename $${f}`"                         >> $@; \
		echo "set_property part ${PART} [current_project]"                   >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"            >> $@; \
		echo "set_property target_language VHDL [current_project]"           >> $@; \
		echo "generate_target all [get_files build/vivado/`basename $${f}`]" >> $@; \
	done

# generate BLOCK DESIGN .bd files importer script
build/vivado/import_bds.tcl: ${SYNTH_BD_FILES} | build/vivado
	@rm -f $@
	@touch $@
	@for f in `find rtl/synth -name *.bd`; do                                          \
		cp $${f} build/vivado;                                                           \
		echo "read_bd build/vivado/`basename $${f}`"                              >> $@; \
		echo "set_property part ${PART} [current_project]"                        >> $@; \
		echo "set_property board_part ${BOARD} [current_project]"                 >> $@; \
		echo "set_property target_language VHDL [current_project]"                >> $@; \
		echo "generate_target all [get_files build/vivado/`basename $${f}`]"      >> $@; \
		echo "make_wrapper -files [get_files build/vivado/`basename $${f}`] -top" >> $@; \
		echo "read_vhdl build/vivado/hdl/$$(basename $${f%.*})_wrapper.vhd"       >> $@; \
	done

# generate synthetisable files importer script
build/vivado/import_synth.tcl: build/vivado/import_xdc.tcl build/vivado/import_vhd.tcl build/vivado/import_vhdl.tcl build/vivado/import_verilog.tcl build/vivado/import_system_verilog.tcl build/vivado/import_bds.tcl build/vivado/import_ips.tcl
	@echo "source build/vivado/import_vhd.tcl"             > $@
	@echo "source build/vivado/import_vhdl.tcl"           >> $@
	@echo "source build/vivado/import_verilog.tcl"        >> $@
	@echo "source build/vivado/import_system_verilog.tcl" >> $@
	@echo "source build/vivado/import_ips.tcl"            >> $@
	@echo "source build/vivado/import_bds.tcl"            >> $@
	@echo "source build/vivado/import_xdc.tcl"            >> $@

# generate bitstream generator script
build/vivado/impl.tcl: build/vivado/import_synth.tcl
	@echo "source $<"                                                                                                > $@
	@echo "synth_design -top ${TOP} -part ${PART}"                                                                  >> $@
	@echo "write_checkpoint -force build/vivado/post_synth"                                                         >> $@
	@echo "report_timing_summary -file build/vivado/post_synth_timing_summary.rpt"                                  >> $@
	@echo "report_power -file build/vivado/post_synth_power.rpt"                                                    >> $@
	@echo "write_verilog -force -file build/vivado/synth_netlist.v"                                                 >> $@
	@echo "opt_design"                                                                                              >> $@
	@echo "power_opt_design"                                                                                        >> $@
	@echo "place_design"                                                                                            >> $@
	@echo "phys_opt_design"                                                                                         >> $@
	@echo "write_checkpoint -force build/vivado/post_place"                                                         >> $@
	@echo "route_design"                                                                                            >> $@
	@echo "write_checkpoint -force build/vivado/post_route"                                                         >> $@
	@echo "report_timing_summary -file build/vivado/post_route_timing_summary.rpt"                                  >> $@
	@echo "report_timing -sort_by group -max_paths 100 -path_type summary -file build/vivado/post_route_timing.rpt" >> $@
	@echo "report_clock_utilization -file build/vivado/clock_util.rpt"                                              >> $@
	@echo "report_utilization -file build/vivado/post_route_util.rpt"                                               >> $@
	@echo "report_power -file build/vivado/post_route_power.rpt"                                                    >> $@
	@echo "report_drc -file build/vivado/post_imp_drc.rpt"                                                          >> $@
	@echo "write_verilog -force build/vivado/impl_netlist.v"                                                        >> $@
	@echo "write_xdc -no_fixed_only -force build/vivado/bft_impl.xdc"                                               >> $@
	@echo "write_bitstream -force build/vivado/bitstream.bit"                                                       >> $@
	@echo "write_hwdef -force build/vivado/system.hdf"                                                              >> $@

# generate hardware definition file (.hdf)
build/vivado/system.hdf: build/vivado/impl.tcl
	@vivado -mode batch -source $< -nojournal -nolog
	@cp build/vivado/bitstream.bit os/board/zynq-zedboard/fpga.bit
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done

build/vivado/import-synth.done: build/vivado/import_synth.tcl
	@vivado -mode batch -source $< -nojournal -nolog
	@rm -f build/vivado/import-synth.done
	@touch build/vivado/import-synth.done

vivado-all: build/vivado/system.hdf

vivado-gui: build/vivado/import_synth.tcl
	@vivado -nojournal -nolog -source $<

vivado-clean:
	@rm -rf build/vivado

