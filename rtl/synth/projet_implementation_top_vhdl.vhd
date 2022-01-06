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
        FIXED_IO_ps_srstb : inout STD_LOGIC
        -- user added ports
        -- i2s_in_mclk   : out std_logic;
        -- i2s_in_bclk   : out std_logic;
        -- i2s_in_lrck   : out std_logic;
        -- i2s_in_data   : in  std_logic
      );
end entity;

architecture top_arch of projet_implementation_top_vhdl is
  -- signal i2s_in_tdata : std_logic_vector(31 downto 0);
  -- signal i2s_in_tvalid : std_logic;
  -- signal i2s_in_tready : std_logic;
  -- signal i2s_in_tlast : std_logic;
begin
------ l'instanciation suivante doit être actualisée en fonction du fichier build/vivado/build/hdl/design_1_wrapper.vhd (qui représente le block design)
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
            FIXED_IO_ps_srstb => FIXED_IO_ps_srstb
            -- user added ports
            -- i2s_in_tdata  => i2s_in_tdata
            -- i2s_in_tvalid => i2s_in_tvalid
            -- i2s_in_tready => i2s_in_tready
            -- i2s_in_tlast  => i2s_in_tlast
          );

-- votre module: ici un compteur parn exemple qui sort sur 4 leds
led <= std_logic_vector(count(26 downto 23));
simple_led_test:process(aclk_0, aresetn_0) begin
  if(aresetn_0 = "0") then
    count <= (others=>'0');
  elsif(rising_edge(aclk_0)) then
    count <= count + 1;
  end if;
end process;

end architecture;
