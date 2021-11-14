# Copyright 2021 Raphaël Bresson
XSCT_FOLDER  = build/xsct
XSCT_WS      = ${XSCT_FOLDER}/workspace
XSCT_HW_NAME = hw1
XSCT_BSP_NAME = bsp1

${XSCT_FOLDER}:
	@mkdir -p $@

${XSCT_WS}:
	@mkdir -p $@

${XSCT_FOLDER}/device-tree-xlnx:
	@echo "### INFO: Cloning Xilinx device-tree repository in directory ${PWD}/$@"
	@cd build/xsct/ && git clone https://github.com/Xilinx/device-tree-xlnx -b xilinx-v2019.1

${XSCT_FOLDER}/gen_fsbl.tcl: | ${XSCT_FOLDER}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "open_hw_design build/vivado/system.hdf"                                                                      > $@
	@echo "create_sw_design impl_fsbl -proc ps7_cortexa9_0 -app zynq_fsbl"                                             >> $@
	@echo "generate_app -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir ${XSCT_FOLDER}/fsbl" >> $@
	@echo "exit"                                                                                                       >> $@

${XSCT_FOLDER}/gen_dts.tcl: | ${XSCT_FOLDER}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "open_hw_design build/vivado/system.hdf"                                     > $@
	@echo "set_repo_path ${XSCT_FOLDER}/device-tree-xlnx"                             >> $@
	@echo "create_sw_design device-tree-sources -proc ps7_cortexa9_0 -os device_tree" >> $@
	@echo "set_property CONFIG.periph_type_overrides \"{BOARD ${XSCT_BOARD}}\" [get_os]"   >> $@
	@echo "generate_bsp -dir ${XSCT_FOLDER}/dts"                                      >> $@
	@echo "exit"                                                                      >> $@

${XSCT_FOLDER}/fsbl/executable.elf: build/vivado/system.hdf ${XSCT_FOLDER}/gen_fsbl.tcl
	@echo "### INFO: Generating fsbl executable ${PWD}/$@"
	@hsi -source ${XSCT_FOLDER}/gen_fsbl.tcl -nolog -nojournal

${XSCT_FOLDER}/dts/system-top.dts: build/vivado/system.hdf ${XSCT_FOLDER}/gen_dts.tcl | ${XSCT_FOLDER}/device-tree-xlnx
	@echo "### INFO: Generating device-tree files in ${PWD}/${XSCT_FOLDER}/dts/"
	@hsi -source ${XSCT_FOLDER}/gen_dts.tcl -nolog -nojournal

os/board/${BR2_BOARD}/dts/system-top.dts: ${XSCT_FOLDER}/dts/system-top.dts
	@echo "### INFO: Copying and patching generated device-tree files from ${PWD}/${XSCT_FOLDER}/dts/ to ${PWD}/os/board/${BR2_BOARD}/dts/"
	@mkdir -p os/board/${BR2_BOARD}/dts
	@cp $< $@
	@touch os/board/${BR2_BOARD}/dts/pl.dtsi
	@find ${XSCT_FOLDER}/dts/ -name "*.dtsi" -exec cp {} os/board/${BR2_BOARD}/dts \;
	@find ${XSCT_FOLDER}/dts/ -name "*.h"    -exec cp {} os/board/${BR2_BOARD}/dts \;
	@find ${XSCT_FOLDER}/dts/ -name "*.dts"  -exec cp {} os/board/${BR2_BOARD}/dts \;
	@find ${XSCT_FOLDER}/dts/ -name "*.bit"  -exec cp {} os/board/${BR2_BOARD}/dts \;
	@sed -i '/\/ {/i #include "system-user.dtsi"' os/board/${BR2_BOARD}/dts/system-top.dts

os/board/${BR2_BOARD}/fsbl.elf: ${XSCT_FOLDER}/fsbl/executable.elf
	@echo "### INFO: Copying fsbl executable from ${PWD}/$< to ${PWD}/$@"
	@cp $< $@

sys-update: os/board/${BR2_BOARD}/fsbl.elf os/board/${BR2_BOARD}/dts/system-top.dts

### ------------------------------------------------------------------------------------------

BARE_METAL_C = $(shell find baremetal/ -name "*.c")
BARE_METAL_H = $(shell find baremetal/ -name "*.h")

${XSCT_FOLDER}/gen_hwproj.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "setws -switch ${XSCT_WS}"                                        > $@
	@echo "createhw -name ${XSCT_HW_NAME} -hwspec build/vivado/system.hdf" >> $@

${XSCT_FOLDER}/gen_bsp.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "setws -switch ${XSCT_WS}"                                                                         > $@
	@echo "createbsp -name ${XSCT_BSP_NAME} -hwproject ${XSCT_HW_NAME} -os standalone -proc ps7_cortexa9_0" >> $@
	@echo "project -build -name ${XSCT_BSP_NAME} -type bsp"                                                 >> $@

${XSCT_FOLDER}/create-bm-${BM_PROJECT}.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@if [[ "`find baremetal/${BM_PROJECT} -name *.c`" == *[!\ ]* ]]; then \
		echo "setws ${XSCT_WS}" > $@; \
		echo "createapp -name ${BM_PROJECT} -app {Empty Application} -hwproject ${XSCT_HW_NAME} -bsp ${XSCT_BSP_NAME} -proc ps7_cortexa9_0" >> $@; \
		echo "importsources -name ${BM_PROJECT} -path baremetal/${BM_PROJECT}" >> $@; \
		echo "project -build -name ${BM_PROJECT} -type app" >> $@; \
	else \
		echo "Error: Project ${BM_PROJECT} has no C sources"; \
		exit 1; \
	fi

${XSCT_FOLDER}/build-bm-${BM_PROJECT}.tcl: ${XSCT_FOLDER}/create-bm-${BM_PROJECT}.tcl | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@if [[ "`find baremetal/${BM_PROJECT} -name *.c`" == *[!\ ]* ]]; then \
		echo "setws ${XSCT_WS}" > $@; \
		echo "importsources -name ${BM_PROJECT} -path baremetal/${BM_PROJECT}" >> $@; \
		echo "project -build -name ${BM_PROJECT} -type app" >> $@; \
	else \
		echo "Error: Project ${BM_PROJECT} has no C sources"; \
		exit 1; \
	fi

${XSCT_FOLDER}/run-bm-${BM_PROJECT}.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "connect"                                                                                    > $@
	@echo "puts [targets]"                                                                            >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                                        >> $@
	@echo "rst -system"                                                                               >> $@
	@echo "fpga -f build/vivado/bitstream.bit"                                                        >> $@
	@echo "source ${XSCT_WS}/${XSCT_HW_NAME}/ps7_init.tcl; ps7_init; ps7_post_config; rst -processor" >> $@
	@echo "dow ${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf"                                      >> $@
	@echo "bpadd -addr &main"                                                                         >> $@
	@echo "con -block"                                                                                >> $@
	@echo "con"                                                                                       >> $@

${XSCT_FOLDER}/debug-bm-${BM_PROJECT}.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "connect"                                                                          > $@
	@echo "puts [targets]"                                                                  >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                              >> $@
	@echo "rst -system"                                                                     >> $@
	@echo "fpga -f build/vivado/bitstream.bit"                                              >> $@
	@echo "source ${XSCT_WS}/${XSCT_HW_NAME}/ps7_init.tcl; ps7_post_config; rst -processor" >> $@
	@echo "ps7_init"                                                                        >> $@
	@echo "dow ${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf"                            >> $@
	@echo "bpadd -addr &main"                                                               >> $@

${XSCT_FOLDER}/clean-bm-project.tcl: | ${XSCT_WS}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "setws ${XSCT_WS}"                   > $@
	@echo "deleteprojets -name ${BM_PROJECT}" >> $@

${XSCT_WS}/${XSCT_HW_NAME}/system.hdf: build/vivado/system.hdf ${XSCT_FOLDER}/gen_hwproj.tcl
	@echo "### INFO: Generating hardware project ${XSCT_HW_NAME}"
	@xsct ${XSCT_FOLDER}/gen_hwproj.tcl
	@echo "### INFO: hardware project ${XSCT_HW_NAME} successfully generated"

${XSCT_WS}/${XSCT_BSP_NAME}/system.mss: ${XSCT_FOLDER}/gen_bsp.tcl
	@echo "### INFO: Generating BSP project ${XSCT_BSP_NAME}"
	@xsct ${XSCT_FOLDER}/gen_bsp.tcl
	@echo "### INFO: BSP project ${XSCT_BSP_NAME} successfully generated"

xsct-clean-workspace:
	@echo "### INFO: Cleaning baremetal workspace"
	@rm -rf ${XSCT_WS} ${XSCT_FOLDER}/gen_hwproj.tcl ${XSCT_FOLDER}/gen_bsp.tcl ${XSCT_FOLDER}/build-bm-* ${XSCT_FOLDER}/run-bm-*  ${XSCT_FOLDER}/debug-bm-* ${XSCT_FOLDER}/*.done os/board/${BR2_BOARD}/dts os/board/${BR2_BOARD}/fpga.bit

${XSCT_FOLDER}/bm-verify-${BM_PROJECT}.done: | ${XSCT_WS}
	@if [[ "${BM_PROJECT}" == *[!\ ]* ]]; then \
		if [[ "$(shell find baremetal/ -name ${BM_PROJECT})" == *[!\ ]* ]]; then \
			echo "done" > ${XSCT_FOLDER}/bm-verify-${BM_PROJECT}.done \
			echo "### INFO: Found baremetal project: baremetal/${BM_PROJECT}"; \
		else \
			echo "### ERROR: Project ${BM_PROJECT} not found in \"baremetal/\" directory"; \
			exit -1; \
		fi \
	else \
		echo "### ERROR: BM_PROJECT argument containing the name of baremetal project is mandatory for all xsct-baremetal-* targets"; \
		echo "### USAGE: make xsct-baremetal-<target> BM_PROJECT=<name of your project>"; \
		echo "### EXEMPLE: BUILD: make xsct-baremetal-build BM_PROJECT=helloworld"; \
		echo "### EXEMPLE: RUN: make xsct-baremetal-run BM_PROJECT=helloworld"; \
		echo "### EXEMPLE: DEBUG: make xsct-baremetal-debug BM_PROJECT=helloworld"; \
		echo "### INFO: Any baremetal project must be placed in \"baremetal\" directory"; \
		exit -1; \
	fi

${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf: ${XSCT_WS}/${XSCT_HW_NAME}/system.hdf ${XSCT_WS}/${XSCT_BSP_NAME}/system.mss ${XSCT_FOLDER}/bm-verify-${BM_PROJECT}.done build/xsct/build-bm-${BM_PROJECT}.tcl ${BARE_METAL_C} ${BARE_METAL_H}
	@if [ ! -d ${XSCT_WS}/${BM_PROJECT} ]; then \
		echo "### INFO: Generating application project ${BM_PROJECT}"; \
		xsct ${XSCT_FOLDER}/create-bm-${BM_PROJECT}.tcl; \
	else \
		echo "### INFO: Updating application project ${BM_PROJECT}"; \
		xsct ${XSCT_FOLDER}/build-bm-${BM_PROJECT}.tcl; \
	fi
	@echo "### INFO: Built executable: ${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf"

xsct-baremetal-build: ${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf

xsct-baremetal-run: xsct-baremetal-build ${XSCT_FOLDER}/run-bm-${BM_PROJECT}.tcl
	@echo "### INFO: Running baremetal project ${BM_PROJECT}"
	@xsct build/xsct/run-bm-${BM_PROJECT}.tcl
	@echo "### INFO: baremetal project ${BM_PROJECT} run successfully finished"

xsct-baremetal-debug: xsct-baremetal-build ${XSCT_FOLDER}/debug-bm-${BM_PROJECT}.tcl
	@echo "### INFO: Debugging baremetal project ${BM_PROJECT}"
	@xsdb -interactive build/xsct/debug-bm-${BM_PROJECT}.tcl
	@echo "### INFO: baremetal project ${BM_PROJECT} debug session successfully finished"

xsct-clean: xsct-clean-workspace
	@echo "### INFO: Cleaning xsct folder"
	@rm -rf build/xsct

xsct-xsdk: ${XSCT_WS}/${XSCT_HW_NAME}/system.hdf ${XSCT_WS}/${XSCT_BSP_NAME}/system.mss
	@xsdk -workspace ${XSCT_WS}
	@echo "Would you like to save the modified files? [y, N]"
	@read rc; \
	if [[ "$${rc}" == @(y|Y) ]]; then \
		echo "### INFO: Copying source files from ${PWD}/${XSCT_WS}/ to ${PWD}/baremetal"; \
		for d in `ls -d ${XSCT_WS}/*/ | grep -v hw | grep -v bsp | grep -v TempFiles`; do \
      proj_dir=$$(basename $${d}); \
			mkdir -p baremetal/$${proj_dir}; \
			cp -r ${XSCT_WS}/$${proj_dir}/src baremetal/$${proj_dir}/; \
		done \
	else \
		echo "### INFO: Modified files from ${PWD}/${XSCT_WS}/ not saved"; \
		echo "### INFO: Files will be automatically restored on the next baremetal build"; \
	fi

${XSCT_FOLDER}/boot-jtag-buildroot.tcl: | ${XSCT_FOLDER}
	@echo "### INFO: Generating tcl script ${PWD}/$@"
	@echo "connect"                                                                   > $@
	@echo "puts [targets]"                                                           >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                       >> $@
	@echo "rst"                                                                      >> $@
	@echo "source ${XSCT_WS}/${XSCT_HW_NAME}/ps7_init.tcl"                           >> $@
	@echo "ps7_init"                                                                 >> $@
	@echo "ps7_post_config"                                                          >> $@
	@echo "fpga -f build/vivado/bitstream.bit"                                       >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                       >> $@
	@echo "dow build/buildroot-output/images/zynq/u-boot.elf"                        >> $@
	@echo "con"                                                                      >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                       >> $@
	@echo "dow -data build/buildroot-output/images/boot/uImage 0x2080000"            >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                       >> $@
	@echo "dow -data build/buildroot-output/images/boot/devicetree.dtb 0x2000000"    >> $@
	@echo "targets -set -nocase -filter {name =~ \"ARM* #0\"}"                       >> $@
	@echo "dow -data build/buildroot-output/images/boot/uramdisk.image.gz 0x4000000" >> $@


xsct-boot-jtag-buildroot: buildroot-update ${XSCT_WS}/${XSCT_HW_NAME}/system.hdf ${XSCT_FOLDER}/boot-jtag-buildroot.tcl
	@echo "### INFO: Booting Buildroot GNU/Linux distribution"
	@xsct ${XSCT_FOLDER}/boot-jtag-buildroot.tcl
	@echo "### INFO: Linux boot successfully done"

