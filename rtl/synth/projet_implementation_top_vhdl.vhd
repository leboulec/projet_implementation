-- Copyright Raphaël Bresson 2021

-- Reference file for bd wrapper: build/vivado/build/hdl/<bd_name>_wrapper.vhd or
-- build/vivado/build/hdl/<bd_name>_wrapper.v (depending which language is preferred in Makefile and after generating it:
-- make build/vivado/import_synth.done

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity projet_implementation_top_vhdl is
  port( DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_cas_n : inout STD_LOGIC;
        DDR_ck_n : inout STD_LOGIC;
        DDR_ck_p : inout STD_LOGIC;
        DDR_cke : inout STD_LOGIC;
        DDR_cs_n : inout STD_LOGIC;
        DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_odt : inout STD_LOGIC;
        DDR_ras_n : inout STD_LOGIC;
        DDR_reset_n : inout STD_LOGIC;
        DDR_we_n : inout STD_LOGIC;
        FIXED_IO_ddr_vrn : inout STD_LOGIC;
        FIXED_IO_ddr_vrp : inout STD_LOGIC;
        FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
        FIXED_IO_ps_clk : inout STD_LOGIC;
        FIXED_IO_ps_porb : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        -- user added ports
        i2s_in_mclk : out std_logic;
        i2s_in_bclk : out std_logic;
        i2s_in_lrck : out std_logic;
        i2s_in_data : in  std_logic;

        i2s_out_mclk : in std_logic;
        i2s_out_bclk : in std_logic;
        i2s_out_lrck : in std_logic;
        i2s_out_data : out  std_logic
      );
end entity;

architecture top_arch of projet_implementation_top_vhdl is
   signal i2s_in_tdata : std_logic_vector(31 downto 0);
   signal i2s_in_tvalid : std_logic;
   signal i2s_in_tready : std_logic;
   signal i2s_in_tlast : std_logic;
   signal i2s_clk : std_logic;
   signal i2s_rst : std_logic;
begin
bd_inst: entity work.design_1_wrapper
  port map( DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
            DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
            DDR_cas_n => DDR_cas_n,
            DDR_ck_n => DDR_ck_n,
            DDR_ck_p => DDR_ck_p,
            DDR_cke => DDR_cke,
            DDR_cs_n => DDR_cs_n,
            DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
            DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
            DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
            DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
            DDR_odt => DDR_odt,
            DDR_ras_n => DDR_ras_n,
            DDR_reset_n => DDR_reset_n,
            DDR_we_n => DDR_we_n,
            FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
            FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
            FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
            FIXED_IO_ps_clk => FIXED_IO_ps_clk,
            FIXED_IO_ps_porb => FIXED_IO_ps_porb,
            FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
            --FCLK => i2s_clk;
            -- user added ports
			FCLK_CLK2_0 => i2s_clk,
            i2s_axis_0_tdata  => i2s_in_tdata,   -- ici faute
            i2s_axis_0_tvalid => i2s_in_tvalid,
            i2s_axis_0_tready => i2s_in_tready,
            i2s_axis_0_tlast  => i2s_in_tlast
          );

--- user modules instantiations
 i2s_in_inst : entity work.i2s_reader
   port map( clk => i2s_clk
           , aresetn => i2s_rst
           , din => i2s_in_data
           , mclk => i2s_in_mclk
           , bclk => i2s_in_bclk
           , lrck => i2s_in_lrck
           , m_axis_tdata => i2s_in_tdata
           , m_axis_tvalid => i2s_in_tvalid
           , m_axis_tready => i2s_in_tready
           , m_axis_tlast  => i2s_in_tlast);

i2s_out_inst : entity work.i2s_writer
   port map( clk => i2s_clk
           , reset => i2s_rst
           , dout => i2s_out_data
           , mclk_in => i2s_out_mclk
           , sclk_in => i2s_out_bclk
           , lrck_in => i2s_out_lrck
           , s_axis_tdata => i2s_in_tdata
           , s_axis_tvalid => i2s_in_tvalid
           , s_axis_tready => i2s_in_tready
           , s_axis_tlast  => i2s_in_tlast);
end architecture;
