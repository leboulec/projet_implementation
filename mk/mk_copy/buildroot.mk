# Copyright 2021 Raphaël Bresson
# buildroot initial build
build/buildroot:
	@echo "### INFO: Cloning Xilinx Buildroot repository in directory ${PWD}/$@"
	@cd build && git clone https://github.com/buildroot/buildroot.git
	@echo "### INFO: Configuring Buildroot"
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot ${BR2_DEFCONFIG}

buildroot-force-defconfig:
	@echo "### INFO: Configuring Buildroot"
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot ${BR2_DEFCONFIG}

# clean buildroot
buildroot-clean:
	@echo "### INFO: Cleaning Buildroot outputs"
	@rm -rf build/buildroot build/buildroot-output

# update buildroot
build/buildroot-output/images/boot/BOOT.BIN: os/board/${BR2_BOARD}/dts/system-top.dts os/board/${BR2_BOARD}/fsbl.elf | build/buildroot
	@echo "### INFO: Building/Updating Buildroot GNU/Linux distribution"
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot

buildroot-force-update:
	@echo "### INFO: Building/Updating Buildroot GNU/Linux distribution"
	@make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os -C build/buildroot

buildroot-update: build/buildroot-output/images/boot/BOOT.BIN

buildroot-cmd:
	@echo "### INFO: Building Buildroot target: ${CMD}"
	@if [[ "${CMD}" == *[!\ ]* ]]; then \
		make O=${PWD}/build/buildroot-output BR2_EXTERNAL=${PWD}/os ${CMD} -C build/buildroot; \
	else \
		echo "### ERROR: Mandatory argument \"CMD\" not specified for target $@"; \
		echo "### USAGE: make buildroot-cmd CMD=<your command>"; \
		echo "### EXEMPLE: make buildroot-cmd CMD=menuconfig"; \
	fi
