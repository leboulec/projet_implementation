// Copyright Raphaël Bresson 2021

// Reference file for bd wrapper: build/vivado/build/hdl/<bd_name>_wrapper.vhd or
// build/vivado/build/hdl/<bd_name>_wrapper.v (depending which language is preferred in Makefile and after generating it:
// make build/vivado/import_synth.done

`timescale 1 ps / 1 ps

module projet_implementation_top_sv
( inout [14:0] DDR_addr
, inout  [2:0] DDR_ba
, inout        DDR_cas_n
, inout        DDR_ck_n
, inout        DDR_ck_p
, inout        DDR_cke
, inout        DDR_cs_n
, inout  [3:0] DDR_dm
, inout [31:0] DDR_dq
, inout  [3:0] DDR_dqs_n
, inout  [3:0] DDR_dqs_p
, inout        DDR_odt
, inout        DDR_ras_n
, inout        DDR_reset_n
, inout        DDR_we_n
, inout        FIXED_IO_ddr_vrn
, inout        FIXED_IO_ddr_vrp
, inout        FIXED_IO_mio
, inout        FIXED_IO_ps_clk
, inout        FIXED_IO_ps_porb
, inout        FIXED_IO_ps_srstb
// user added ports
//, output i2s_in_mclk
//, output i2s_in_bclk
//, output i2s_in_lrck
//, input  i2s_in_data
);

// user added signals
// logic [31:0] i2s_in_tdata;
// logic        i2s_in_tvalid;
// logic        i2s_in_tready:
// logic        i2s_in_tlast;

design_1_wrapper bd_inst( .DDR_addr          (DDR_addr)
                        , .DDR_ba            (DDR_ba)
                        , .DDR_cas_n         (DDR_cas_n)
                        , .DDR_ck_n          (DDR_ck_n)
                        , .DDR_ck_p          (DDR_ck_p)
                        , .DDR_cke           (DDR_cke)
                        , .DDR_cs_n          (DDR_cs_n)
                        , .DDR_dm            (DDR_dm)
                        , .DDR_dq            (DDR_dq)
                        , .DDR_dqs_n         (DDR_dqs_n)
                        , .DDR_dqs_p         (DDR_dqs_p)
                        , .DDR_odt           (DDR_odt)
                        , .DDR_ras_n         (DDR_ras_n)
                        , .DDR_reset_n       (DDR_reset_n)
                        , .DDR_we_n          (DDR_we_n)
                        , .FIXED_IO_ddr_vrn  (FIXED_IO_ddr_vrn)
                        , .FIXED_IO_ddr_vrp  (FIXED_IO_ddr_vrp)
                        , .FIXED_IO_mio      (FIXED_IO_mio)
                        , .FIXED_IO_ps_clk   (FIXED_IO_ps_clk)
                        , .FIXED_IO_ps_porb  (FIXED_IO_ps_porb)
                        , .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb)
                        // user added ports
                        //, .i2s_in_mclk (i2s_in_mclk)
                        //, .i2s_in_bclk (i2s_in_bclk)
                        //, .i2s_in_lrck (i2s_in_lrck)
                        //, .i2s_in_data (i2s_in_data)
                        );

// i2s_input i2s_input( .clk (?)
//                    , .aresetn(?)
//                    , .din(i2s_in_data)
//                    , .mclk(i2s_in_mclk)
//                    , .bclk(i2s_in_bclk)
//                    , .lrck(i2s_in_lrck)
//                    , .i2s_in_tdata (i2s_in_tdata)
//                    , .i2s_in_tvalid(i2s_in_tvalid)
//                    , .i2s_in_tready(i2s_in_tready)
//                    , .i2s_in_tlast (i2s_in_last)
//                    );

endmodule
