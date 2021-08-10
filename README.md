# Buildroot framework for Zynq-7000

User files
----
- `rtl` contains all user rtl files and constraints
  - `constr` folder contains user contraints
  - `synth` folder contains synthetizable user files (this folder contains initially an example of a block design and an example of a standalone entity)
  - `sim` folder contains user simulation files (this folder contains initialy example files to run a standalone testbench and top testbench)
- `os` folder contains buildroot packages and configs used
  - `configs` contains defconfigs for supported boards (here only zynq-zedboard is supported)
  - `board` contains scripts for post build or pre build
    - `common` contains files shared by all platform supported (initially only zynq-zedboard is supported)
    - `<board name>` contains files specific to board supported (initially there is only zynq-zedboard)
  - `package` contains all buildroot packages
- `mk` folder contains all mandatory makefiles for this project:
  - `vivado.mk` contains all targets for generating IP and BLOCK DESIGN output products then making bitstream
  - `xsct.mk` contains all targets to handle device-tree and fsbl baremetal build
  - `xsim.mk` contains all targets for behavioral simulation
  - `buildroot.mk` contains all targets to build buildroot distribution

Output files
----
All output files are copied to the build directory (except some garbage from xsim in project root):
- `build/vivado` contains all vivado generated files especially bitstream and hardware definition file (.hdf)
- `build/xsct` contains all xsct generated files especially fsbl and device-tree build folders
- `build/xsim` contains all xsim generated files (logs and waveforms)
- `build/buildroot` contains the buildroot repository
- `build/buildroot-output` contains the builded buildroot distribution

Requirements
----
- Modern Linux Distribution (Tested on Debian 10 buster)
- [Vivado 2019.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html) with a valid license (Webpack succesfully tested)
- [Buildroot requirements](https://buildroot.org/downloads/manual/manual.html#requirement)
- Enough space on disk to store the output products (required:15GB, recommended:40GB)

gmake vs make
----
GNU Make is not the only one make executable. To handle this problem, some  rename the make executable to gmake.
Xilinx software tools are using the gmake command instead of make.
If gmake is not present in /bin, you can create a symbolic link yourself:
```bash
  sudo ln -s /bin/make /bin/gmake
```

Installing buildroot dependancies (Debian based distributions only)
----
```bash
  sudo apt install which sed make build-essential gcc g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget python ncurses-base ncurses-bin libncurses5-dev bazaar cvs git mercurial scp subversion
```

Before initial manipulation:
----
```bash
  source <XILINX_INSTALL>/Vivado/<vivado version>/settings64.sh
```

Generating bitstream
----
```bash
  make vivado-all TOP=<top entity>
```
  This will generate bitstream and hardware definition files.
  Default value for TOP: design\_1\_wrapper

Execute Vivado in GUI mode
----
```bash
  make vivado-gui
```

Cleaning Vivado output products
----
```bash
  make vivado-clean
```

Behavioral simulation using XSIM (Xilinx Simulator):
----
```bash
  make sim SIM_TOP=<simulation_top_entity> SIM_MODE=<gui|cli>
```
  Launch behavioral simulation.
  Default value for SIM\_TOP: tb\_top
  Default value for SIM\_MODE: gui.

Cleaning simulation files
----
```bash
  make sim-clean
```
  This will delete all files generated by XSIM

Baremetal projects
----
First, create project with Xilinx SDK then copy sources to baremetal directory:
```bash
  mkdir -p baremetal/<your project name>
  cp <path to project src directory>/* baremetal
```
Then build a project:
```bash
  make xsct-clean-workspace # clean workspace before (this is not mandatory but cleaner if you change c files)
  make xsct-baremetal-build BM_PROJECT=<name of your project> # build elf
```
Then connect JTAG (mini usb port "PROG") to program FPGA and boot the board and UART (mini usb port "UART") to receive the outputs of the printfs in Minicom.
Open another terminal window and open Minicom.
```bash
  minicom -b 115200 -D /dev/ttyACM<N>
```
Then launch project in non-interactive mode:
```bash
  make xsct-baremetal-run BM_PROJECT=<name of your project> # run app
```
Or launch in interactive mode (debug):
```bash
  make xsct-baremetal-debug BM_PROJECT=<name of your project> # run app
```
Refer to the following links to use interactive mode
- [XSCT runtime commands](https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/running/reference_xsct_running.html)
- [XSCT breakpoints commands](https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/breakpoints/reference_xsct_breakpoints.html)
- [XSCT memory commands](https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/memory/reference_xsct_memory.html)
- [XSCT register commands](https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/registers/reference_xsct_registers.html)

Executing Xilinx SDK in gui mode
----
```bash
  make xsct-sdk
```

Cleaning baremetal workspace
----
```bash
  make xsct-clean-workspace
```

Cleaning files generated by XSCT
----
```bash
  make xsct-clean
```

Update buildroot:
----
```bash
  make buildroot-update
```
This will (re)generate buildroot outputs

Sending commands to buildroot
----
```bash
  make buildroot-cmd CMD=<your command>
```
Send command to buildroot build system. CMD argument is mandatory.

Exemple: Open menuconfig of buildroot
```bash
  make buildroot-cmd CMD="menuconfig"
```
  Exemple: Open menuconfig of the Linux Kernel
```bash
  make buildroot-cmd CMD="linux-menuconfig"
```

Cleaning Buildroot output products
----
```bash
  make buildroot-clean
```

Building all
----
```bash
  make TOP=<top_entity>
```
Build bitstream, hardware definition file, FSBL, device-tree and buildroot distribution.
Default value for TOP: design\_1\_wrapper

Cleaning all files
----
```bash
  make clean
```
This will delete all generated files and output folders

Boot buildroot Linux from JTAG
----
Connect the board and run uboot:
```bash
  make xcst-boot-jtag-buildroot
```
Run Minicom in another terminal:
```bash
  minicom -b 115200 -D /dev/ttyACM<number>
```
In the minicom terminal, interrupt uboot by pressing any key then run the following uboot command:
```bash
  bootm $kernel_load_address $ramdisk_load_address $devicetree_load_address
```

Boot Linux from SDCARD
----
Insert SDCARD and run the following command:
```bash
  sudo fdisk -l
```
Using the output of the previous command you should be able to identify the file in /dev which correspond to your SDCARD.
It can be `/dev/mmcblk<number>` or `/dev/sd<letter>`.

Two partitions are required:
- \"BOOT\" formated in fat32 and containing boot files
- \"ROOTFS\" formated in ext4 and containing the root filesystem

  This can be done as following:

  First umount device and erase its first bytes (location of partition table)
```bash
  sudo umount /dev/<device>*
  sudo dd if=/dev/null of=/dev/<device> bs=1024 count=1
```
  Then use fdisk or other tool to design disk partitions. See [fdisk documentation](https://www.man7.org/linux/man-pages/man8/fdisk.8.html) to know how to use fdisk

  Then format your partitions in required format:
```bash
  sudo mkfs.vfat -n BOOT   /dev/<device><part1>
  sudo mkfs.ext4 -L ROOTFS /dev/<device><part2>
```
  Then mount and copy files
```bash
  sudo mount /dev/<device><part1> <part1 mount point>
  sudo mount /dev/<device><part2> <part2 mount point>
  cp build/buildroot-output/images/boot/* <part1 mount point>
  cd  <part2 mount point> && sudo tar xf build/buildroot-output/images/rootfs.tar
```
  After all, unmount partitions
```bash
  sudo umount /dev/<device>*
```
  Then run Minicom and insert SDCARD.

Minicom configuration
----
To control the terminal of buildroot from Minicom, we need to disable the hardware flow control.
This can be done in Minicom by using CTRL+o to open the configuration menu then select "serial port configuration" then disable "Hardware flow control" option.
Then select "Save config to dfl" to save configuration for future use.

Xilinx JTAG drivers install
----
If your board isn't detected, it can be because the required driver is not installed. You can install it as following:
```bash
  sudo bash <xilinx_install>/Vivado/<version>/data/xicom/cable_drivers/install_drivers
```

Usefull documentation links
----
- [Xilinx Vivado design flows overview](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug892-vivado-design-flows-overview.pdf) (for information, this framework implement a non-project flow)
- [Xilinx Vivado implementation user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug904-vivado-implementation.pdf)
- [Xilinx XSim user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug900-vivado-logic-simulation.pdf)
- [Xilinx XSCT tcl commands user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug1208-xsct-reference-guide.pdf)
- [Xilinx SDK web page](https://www.xilinx.com/html_docs/xilinx2019_1/SDK_Doc/index.html)
- [Zedboard user guide](https://reference.digilentinc.com/_media/zedboard:zedboard_ug.pdf)
- [Buildroot manual](https://buildroot.org/downloads/manual/manual.html)

TODO list
----
- Add support of cosimulation by replacing automatically in flow the Zynq VIP instance by a systemC model and connect that to (built by flow) [xilinx qemu](https://github.com/Xilinx/qemu.git). An available tutorial for petalinux can be found [here](https://blog.reds.ch/?p=1180). The tutorial not match our requirements.

LICENSE
----
This software is distributed with an Apache License 2.0 physically represented by the `LICENSE` file.

Copyright 2021 Raphaël Bresson
