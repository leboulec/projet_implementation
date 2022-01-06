library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_i2s is
  port (
		CLK, RST: in std_logic;
		i2s_in_mclk : out std_logic;
        i2s_in_bclk : out std_logic;
        i2s_in_lrck : out std_logic;
        i2s_in_data : in  std_logic;

        i2s_out_mclk : out std_logic;
        i2s_out_bclk : out std_logic;
        i2s_out_lrck : out std_logic;
        i2s_out_data : out  std_logic
		);
end entity full_i2s;

architecture struct of full_i2s is

signal i2s_in_tdata : std_logic_vector(31 downto 0);
signal i2s_in_tvalid : std_logic;
signal i2s_in_tready : std_logic;
signal i2s_in_tlast : std_logic;
	
begin
--- user modules instantiations
 i2s_in_inst : entity work.i2s_reader
   port map( clk => CLK
          , aresetn => RST
           , din => i2s_in_data
           , mclk => i2s_in_mclk
           , bclk => i2s_in_bclk
           , lrck => i2s_in_lrck
           , m_axis_tdata => i2s_in_tdata
           , m_axis_tvalid => i2s_in_tvalid
           , m_axis_tready => i2s_in_tready
           , m_axis_tlast  => i2s_in_tlast);

 i2s_out_inst : entity work.i2s_writer
   port map( clk => CLK
           , reset => RST
           , dout => i2s_out_data
           , mclk_in => i2s_out_mclk
           , sclk_in => i2s_out_bclk
           , lrck_in => i2s_out_lrck
           , s_axis_tdata => i2s_in_tdata
           , s_axis_tvalid => i2s_in_tvalid
           , s_axis_tready => i2s_in_tready
           , s_axis_tlast  => i2s_in_tlast);

end architecture;
