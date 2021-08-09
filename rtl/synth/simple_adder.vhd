library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity simple_adder is
  port( clk : in std_logic;
        a   : in std_logic_vector(3 downto 0);
        b   : in std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0));
end entity;

architecture behav of simple_adder is begin
  process(clk) begin
    if(rising_edge(clk)) then
      y <= std_logic_vector(unsigned(a) + unsigned(b));
    end if;
  end process;
end architecture;
