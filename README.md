# Buildroot framework for Zynq-7000

User files
----
- `rtl` contains all user rtl files and constraints
  - `constr` folder contains user contraints before synthesis
  - `pre_opt` folder contains user contraints used after synthesis
  - `post_opt` folder contains user contraints used after opt design
  - `post_placement` folder contains user contraints used after placement
  - `probes` folder contains user defined debug probes constraints
  - `synth` folder contains synthetizable user files (this folder contains initially an example of a block design and an example of a standalone entity)
  - `sim` folder contains user simulation files (this folder contains initialy example files to run a standalone testbench and top testbench)
- `os` folder contains buildroot packages and configs used
  - `configs` contains defconfigs for supported boards (here only zynq-zedboard is supported)
  - `board` contains scripts for post build or pre build
    - `<board name>` contains files specific to board supported (initially there is only `zynq-zedboard`)
  - `package` contains all buildroot packages
- `mk` folder contains all mandatory makefiles for this project:
  - `vivado.mk` contains all targets for generating IP and BLOCK DESIGN output products then making bitstream
  - `xsct.mk` contains all targets to handle device-tree and fsbl baremetal build
  - `xsim.mk` contains all targets for behavioral simulation
  - `buildroot.mk` contains all targets to build buildroot distribution
- `baremetal` contains all baremetal projects

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

Minicom configuration
----
To control the terminal of buildroot from Minicom, we need to disable the hardware flow control.
This can be done in Minicom by using CTRL+o to open the configuration menu then select "serial port configuration" then disable "Hardware flow control" option.
Then select "Save config to dfl" to save configuration for future use.

Allowing current user in host machine to access to serial ports without sudo
----
First add current user to dialout and tty:
```shell
  sudo usermod -a -G tty ${USER}
  sudo usermod -a -G dialout ${USER}
```
Then you have to reboot

Xilinx JTAG drivers install
----
If your board isn't detected, it can be because the required driver is not installed. You can install it as following:
```bash
  sudo bash <xilinx_install>/Vivado/<version>/data/xicom/cable_drivers/install_drivers
```

gmake vs make
----
GNU Make is not the only one make executable. To handle this problem, some  rename the make executable to gmake.
Xilinx software tools are using the gmake command instead of make.
If gmake is not present in /bin, you can create a symbolic link yourself:
```bash
  sudo ln -s /bin/make /bin/gmake
```

Makefile parameters
----
- `TOP` : Top level RTL module for synthesis (default: `projet_implementation_vhdl`)
- `PART` : FPGA (PL) target (default: `xc7z020clg484-1`)
- `BOARD` : Vivado board id (default: `em.avnet.com:zed:part0:1.3`)
- `USE_PROBES` : Active or not debug cores generation. Must be `YES` or `NO` (default: `NO`)
- `RTL_LANGUAGE` : Preferred RTL language for generated files, must be `VHDL` or `Verilog` (default: `VHDL`)
- `SIM_MODE` : Simulation mode. Must be `gui` or `console` (default: `gui`)
- `SIM_TOP` : Simulation top level RTL module (default: `tb_top`)
- `XSCT_BOARD` : XSCT board name (default: `zedboard`)
- `BM_PROJECT` : Baremetal project name (no default value)
- `BR2_BOARD` : Buildroot board name (default: `zynq-zedboard`)
- `BR2_DEFCONFIG` : Buildroot defconfig to use (default: `zynq_zedboard_defconfig`)

Example files
----
- RTL synthetizable files:
  - `rtl/synth/projet_implementation_top_vhdl.vhd`: Top level entity in VHDL
  - `rtl/synth/projet_implementation_top_sv.sv`: Top level entity in System Verilog
  - `rtl/synth/simple_adder.vhd`: Simple module example in VHDL
- RTL Simulation files:
  - `rtl/sim/tb_top.sv`: Top level test-bench (including Zynq VIP)
  - `rtl/sim/tb_design_1.sv`: Block design test-bench (including Zynq VIP)
  - `rtl/sim/tb_simple_adder.vhd`: Testbench of simple module example: `rtl/synth/simple_adder.vhd`
- Baremetal sofware projects:
  - `baremetal/helloworld`: Demonstrate how to print hello world with Zynq PS

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

Default value for `TOP`: `projet_implementation_top_vhdl`

Execute Vivado in GUI mode
----
```bash
  make vivado-gui
```

Open synthetized design in GUI
----
```bash
  make vivado-gui-synth
```

Open implemented design in GUI
----
```bash
  make vivado-gui-impl
```

Cleaning Vivado output products
----
```bash
  make vivado-clean
```

Adding debug probes
----
First open synthetized design
```bash
  make vivado-gui-synth
```
Then select the signal you want to debug. Do right click on it and select `Mark Debug`.

Repeat this operations for each signal to debug.

In the menubar, click on `Tools` then `Set Up Debug` and follow the instructions in the dialog window.

In tcl console, get all tcl commands (in blue) to generate the ILA cores. Then copy them in an xdc file in folder rtl/probes.

Then you can close the vivado window.

Then regenerate bitstream with the argument `USE_PROBES=YES` and program the board (using baremetal or buildroot flow).

Then open vivado gui.
```bash
vivado &
```
Then click on `Open Hardware Manager` then `Open Target` and select `Auto Connect`. The waveforms of ILA are opening.

Click on `Specify the probes and refresh the device` and select the file `build/vivado/probes.ltx`.

Behavioral simulation using XSIM (Xilinx Simulator):
----
```bash
  make sim SIM_TOP=<simulation_top_entity> SIM_MODE=<gui|cli>
```
Launch behavioral simulation.

Default value for `SIM_TOP`: `tb_top`

Default value for `SIM_MODE`: `gui`

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
  make xsct-xsdk
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
You can force this update with the following target:
```bash
  make buildroot-force-update
```

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

Reconfiguring buildroot (if file `os/configs/zynq_zedboard_defconfig` is modified)
----
```bash
  make buildroot-force-defconfig
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

Default value for `TOP`: `projet_implementation_top_vhdl`

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

Usefull documentation links
----
- [Xilinx Vivado design flows overview](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug892-vivado-design-flows-overview.pdf) (for information, this framework implement a non-project flow)
- [Xilinx Vivado implementation user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug904-vivado-implementation.pdf)
- [Xilinx XSim user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug900-vivado-logic-simulation.pdf)
- [Xilinx XSCT tcl commands user guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug1208-xsct-reference-guide.pdf)
- [Xilinx SDK web page](https://www.xilinx.com/html_docs/xilinx2019_1/SDK_Doc/index.html)
- [Zedboard user guide](https://reference.digilentinc.com/_media/zedboard:zedboard_ug.pdf)
- [Buildroot manual](https://buildroot.org/downloads/manual/manual.html)

LICENSE
----
This software is distributed with an Apache License 2.0 physically represented by the `LICENSE` file.

Copyright 2021 Rapha??l Bresson
