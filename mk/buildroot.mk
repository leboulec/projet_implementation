# Copyright 2021 Raphaël Bresson
# buildroot initial build
build/buildroot:
	@cd build && git clone https://github.com/buildroot/buildroot.git
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot zynq_zedboard_defconfig

# clean buildroot
buildroot-clean:
	@rm -rf build/buildroot build/buildroot-output

# update buildroot
build/buildroot-output/images/boot/BOOT.BIN: os/board/zynq-zedboard/dts/system-top.dts os/board/zynq-zedboard/fsbl.elf | build/buildroot
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot


buildroot-update: build/buildroot-output/images/boot/BOOT.BIN
buildroot-cmd:
	@if [[ "${CMD}" == *[!\ ]* ]]; then \
		make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os ${CMD} -C build/buildroot; \
	else \
		echo "### ERROR: Mandatory argument \"CMD\" not specified for target $@"; \
		echo "### USAGE: make buildroot-cmd CMD=<your command>"; \
		echo "### EXEMPLE: make buildroot-cmd CMD=menuconfig"; \
	fi
