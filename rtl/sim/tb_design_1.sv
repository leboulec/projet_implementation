// Coyright 2021 Raphaël Bresson
`timescale 1 ps / 1 ps

`define RESET_DELAY 1000
`define STOP_DELAY 1000
`define INIT_DELAY  400
`define INTERRUPT_DELAY 40

// values to modify with real addresses (defined in block design)
`define REG_BASE_DMA_I2S    32'h40000000
`define REG_BASE_DMA_FFT_TX 32'h40004000
`define REG_BASE_DMA_FFT_RX 32'h40008000
`define REG_BASE_DMA_VGA    32'h4000C000

`define SRC_DMA_FFT_TX_PING 32'h80000000
`define SRC_DMA_FFT_TX_PONG 32'h80004000
`define SRC_DMA_VGA_PING    32'h80008000
`define SRC_DMA_VGA_PONG    32'h8000C000

`define DEST_DMA_I2S_PING    32'hC0000000
`define DEST_DMA_I2S_PONG    32'hC0004000
`define DEST_DMA_FFT_RX_PING 32'hC0008000
`define DEST_DMA_FFT_RX_PONG 32'hC000C000

`define C_SLV_AWIDTH     32
`define C_SLV_DWIDTH     32

//Response type defines
`define RESPONSE_OKAY   2'b00

//AMBA 4 defines
`define RESP_BUS_WIDTH   2
`define MAX_BURST_LENGTH 8'b1111_1111
`define SINGLE_BURST_LENGTH 8'b0000_0000

// Burst Size Defines
`define BURST_SIZE_1_BYTE    3'b000
`define BURST_SIZE_2_BYTES   3'b001
`define BURST_SIZE_4_BYTES   3'b010
`define BURST_SIZE_8_BYTES   3'b011
`define BURST_SIZE_16_BYTES  3'b100
`define BURST_SIZE_32_BYTES  3'b101
`define BURST_SIZE_64_BYTES  3'b110
`define BURST_SIZE_128_BYTES 3'b111

// Lock Type Defines
`define LOCK_TYPE_NORMAL    1'b0

// Burst Type Defines
`define BURST_TYPE_INCR  2'b01

`define DMA_MM2S_DMACR        8'h00
`define DMA_MM2S_DMASR        8'h04
`define DMA_MM2S_CURRDESC     8'h08
`define DMA_MM2S_CURRDESC_MSB 8'h0C
`define DMA_MM2S_TAILDESC     8'h10
`define DMA_MM2S_TAILDESC_MSB 8'h14

`define DMA_S2MM_DMACR        8'h20
`define DMA_S2MM_DMASR        8'h24
`define DMA_S2MM_CURRDESC     8'h28
`define DMA_S2MM_CURRDESC_MSB 8'h2C
`define DMA_S2MM_TAILDESC     8'h30
`define DMA_S2MM_TAILDESC_MSB 8'h34

`define ZYNQ_INSTANCE tb_design_1.bd_wrapper.design_1_i.processing_system7_0.inst
`define NUM_FCLK 1

`uselib lib=unisims_ver

module tb_design_1;
  reg                     [0:0] r_ps_clk      ;
  reg                     [0:0] r_ps_aresetn  ;
  wire                          w_ps_clk      ;
  wire                          w_ps_aresetn  ;
  logic  [ `RESP_BUS_WIDTH-1:0] response    ;
//  logic                [31:0] i2s_in_tdata_i2s ;
//  logic                       i2s_in_tvalid_i2s;
//  logic                       i2s_in_tlast_i2s ;
//  logic                       i2s_in_tready_i2s;

  design_1_wrapper bd_wrapper(
    .DDR_addr()
  , .DDR_ba()
  , .DDR_cas_n()
  , .DDR_ck_n()
  , .DDR_ck_p()
  , .DDR_cke()
  , .DDR_cs_n()
  , .DDR_dm()
  , .DDR_dq()
  , .DDR_dqs_n()
  , .DDR_dqs_p()
  , .DDR_odt()
  , .DDR_ras_n()
  , .DDR_reset_n()
  , .DDR_we_n()
  , .FIXED_IO_ddr_vrn()
  , .FIXED_IO_ddr_vrp()
  , .FIXED_IO_mio()
  , .FIXED_IO_ps_clk(w_ps_clk)
  , .FIXED_IO_ps_porb(w_ps_aresetn)
  , .FIXED_IO_ps_srstb(w_ps_aresetn)
  //, .i2s_in_tdata  (i2s_in_tdata)
  //, .i2s_in_tvalid (i2s_in_tvalid)
  //, .i2s_in_tlast  (i2s_in_tlast)
  //, .i2s_in_tready (i2s_in_tready)
  );


  //-------------------------------
  //-- instances of user modules --


  // ---------------------
  // -- clock generator --
  initial begin
    r_ps_clk = 1'b0;
    forever #10 r_ps_clk = !r_ps_clk;
    `ZYNQ_INSTANCE.set_function_level_info("ALL", 0);
    `ZYNQ_INSTANCE.set_channel_level_info("ALL", 0);
  end
  assign w_ps_clk = r_ps_clk;
  assign w_ps_aresetn = r_ps_aresetn;

  // ---------------------------
  // -- test
  initial begin
    $display("### TOP Simulation started!");
    $display("# Resetting the system");
    r_ps_aresetn = 1'b0;
    repeat(`RESET_DELAY)@(posedge r_ps_clk);
    r_ps_aresetn = 1'b1;
    $display("# Reset is released");
    `ZYNQ_INSTANCE.fpga_soft_reset(32'h1);
    `ZYNQ_INSTANCE.fpga_soft_reset(32'h0);
    repeat(`INIT_DELAY)@(posedge r_ps_clk);
    // to complete below with your tests
    // You can use the following methods to transfer data:
    // - write to register:
    //   `ZYNQ_INSTANCE.write_data(addr, `BURST_SIZE_4_BYTES, value, response);
    //   CHECK_RESPONSE(response);
    // - read from register:
    //   `ZYNQ_INSTANCE.read_data(addr, `BURST_SIZE_4_BYTES, value, response);
    //   CHECK_RESPONSE(response);
    // - write to memory:
    //   `ZYNQ_INSTANCE.write_burst(addr, `BURST_SIZE_4_BYTES, `BURST_TYPE_INCR, `LOCK_TYPE_NORMAL, 0, 0, data, size, response);
    //   CHECK_RESPONSE_VECTOR(response);
    // - read from memory:
    //   `ZYNQ_INSTANCE.read_data(addr, size, data, response);
    //   CHECK_RESPONSE(response);
    // - initialize memory from file:
    //   `ZYNQ_INSTANCE.load_mem_from_file(filename, addr, size);
    // - initialize memory with value:
    //   `ZYNQ_INSTANCE.load_mem(value, addr, size);
		// - waiting for next rising edge of clock:
		//   $@(posedge clock)
    // You can also compare data with golden with the task COMPARE_DATA()
    repeat(`STOP_DELAY)@(posedge r_ps_clk);
    $display("# SIMULATION FINISHED SUCCESSFULLY!!");
		$stop;
  end

  //----------------------------------------------------------------------------
  //   TEST LEVEL API: CHECK_RESPONSE(response)
  //----------------------------------------------------------------------------
  // Description: This task check if the return response is equal to OKAY
  //----------------------------------------------------------------------
  task automatic CHECK_RESPONSE;
    input [`RESP_BUS_WIDTH-1:0] response;
     begin
      if (response !== `RESPONSE_OKAY) begin
        $display("TESTBENCH FAILED! Response is not OKAY",
                 "\n expected = 0x%h",`RESPONSE_OKAY,
                 "\n actual = 0x%h", response);
        $stop;
      end
    end
  endtask

  //----------------------------------------------------------------------------
  //   TEST LEVEL API: COMPARE_DATA(expected,actual)
  //----------------------------------------------------------------------------
  // Description: This task checks if the actual data is equal to the expected data
  //----------------------------------------------------------------------
  task automatic COMPARE_DATA;
    input [(`C_SLV_DWIDTH*(`MAX_BURST_LENGTH+1))-1:0] expected;
    input [(`C_SLV_DWIDTH*(`MAX_BURST_LENGTH+1))-1:0] actual;
    begin
      if (expected === 'hx || actual === 'hx) begin
        $display("TESTBENCH FAILED! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
        $stop;
      end
      if (actual !== expected) begin
        $display("TESTBENCH FAILED! Data expected is not equal to actual.","\n expected = 0x%h",expected,
                 "\n actual   = 0x%h",actual);
        $stop;
      end
    end
    endtask

  //----------------------------------------------------------------------------
  //   TEST LEVEL API: CHECK_RESPONE_VECTOR(response,burst_length)
  //----------------------------------------------------------------------------
  // Description: This task checks if the response vector returned from the READ_BURST
  // is equal to OKAY
  //-------------------------------------------------
  task automatic CHECK_RESPONSE_VECTOR;
    input [(`RESP_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] response;
    input integer                                       burst_length;
    integer                                             i;
    begin
      for (i = 0; i < burst_length+1; i = i+1) begin
        CHECK_RESPONSE(response[i*`RESP_BUS_WIDTH +: `RESP_BUS_WIDTH]);
      end
    end
  endtask

endmodule

