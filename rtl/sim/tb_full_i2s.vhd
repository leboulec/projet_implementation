--test tb de l'i2s reader 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_full_i2s is
end entity;

architecture bench of tb_full_i2s is

    component full_i2s is
        port (
		CLK, RST: in std_logic;
		i2s_in_mclk : out std_logic;
        i2s_in_bclk : out std_logic;
        i2s_in_lrck : out std_logic;
        i2s_in_data : in  std_logic;

        i2s_out_mclk : out std_logic;
        i2s_out_bclk : out std_logic;
        i2s_out_lrck : out std_logic;
        i2s_out_data : out  std_logic);
    end component;

    signal CLK, RST, i2s_in_mclk, i2s_in_bclk, i2s_in_lrck, i2s_in_data, i2s_out_mclk, i2s_out_bclk, i2s_out_lrck,i2s_out_data : std_logic;
    signal full_din : std_logic_vector(31 downto 0):="11010011101101010001011010011010";
    signal counter : std_logic_vector(5 downto 0):="100000";

begin

inst: full_i2s port map (
		CLK => CLK ,
        RST => RST, 
        i2s_in_mclk => i2s_in_mclk , 
        i2s_in_bclk => i2s_in_bclk,  
        i2s_in_lrck => i2s_in_lrck,
        i2s_in_data => i2s_in_data,
        i2s_out_mclk => i2s_out_mclk, 
        i2s_out_bclk => i2s_out_bclk, 
        i2s_out_lrck => i2s_out_lrck,
        i2s_out_data => i2s_out_data);

gen_clk: process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process gen_clk;

gen_rst: process
  begin
    RST <= '0';
    wait for 10 ns;
    RST <= '1';
    wait;
  end process gen_rst;


Main : process(i2s_in_bclk)
begin

	if falling_edge(i2s_in_bclk) then
	
		i2s_in_data <= full_din(to_integer(unsigned(counter) - 1));
		counter <= std_logic_vector(unsigned(counter) - 1);
	
	end if;

	if counter <= "000001" then

		counter <= "100000";

	end if;
end process Main;


	
end architecture;
