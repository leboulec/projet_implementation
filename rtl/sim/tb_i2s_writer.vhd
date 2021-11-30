--test tb de l'i2s reader 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity tb_i2s_writer is
end entity;

architecture bench of tb_i2s_writer is

    component i2s_writer is
        port (
		clk,reset: in std_logic; 
        dout: out std_logic; --donnée entrante depuis l'ADC
        mclk_in,sclk_in,lrck_in : out std_logic; 
        s_axis_tvalid, s_axis_tlast : in std_logic;
        s_axis_tready : out std_logic; 
        s_axis_tdata : in std_logic_vector (31 downto 0));
    end component;

    signal clk,aresetn : std_logic; 
    signal dout: std_logic; --donnée entrante depuis l'ADC
    signal s_axis_tready : std_logic; 
    signal mclk,bclk,lrck :  std_logic; 
    signal s_axis_tvalid, s_axis_tlast : std_logic;
    signal s_axis_tdata : std_logic_vector (31 downto 0);

    signal full_din : std_logic_vector(31 downto 0):="11010011101101010001011010011010";

begin

inst: i2s_writer port map (
		clk => clk ,
        reset => aresetn, 
        dout => dout ,   
        mclk_in => mclk,
        sclk_in => bclk,
        lrck_in => lrck, 
        s_axis_tdata => s_axis_tdata,
        s_axis_tvalid => s_axis_tvalid,
        s_axis_tready => s_axis_tready,
        s_axis_tlast => s_axis_tlast );


s_axis_tdata <= full_din;
s_axis_tvalid <= '1';
s_axis_tlast <= '1';

gen_clk: process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process gen_clk;

gen_rst: process
  begin
    aresetn <= '0';
    wait for 10 ns;
    aresetn <= '1';
    wait;
  end process gen_rst;

	
end architecture;
