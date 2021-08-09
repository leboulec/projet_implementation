library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_simple_adder is
end entity;

architecture test of tb_simple_adder is
  component simple_adder is
    port( clk : in std_logic;
          a   : in std_logic_vector(3 downto 0);
          b   : in std_logic_vector(3 downto 0);
          y   : out std_logic_vector(3 downto 0));
  end component;
  signal clk : std_logic := '0';
  signal a, b, y : std_logic_vector(3 downto 0);
  signal count : std_logic_vector(7 downto 0) := (others=>'0');
  signal finished : boolean := false;
begin
  inst: simple_adder
    port map( clk => clk
            , a   => a
            , b   => b
            , y   => y);

  gen_clk: process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
    if(finished) then
      wait;
    end if;
  end process;


  stimulus: process
  begin
    if(count = X"FF") then
      finished <= true;
      wait;
    end if;
    wait until rising_edge(clk);
    count <= std_logic_vector(unsigned(count)+1);
  end process;

  a <= count(3 downto 0);
  b <= count(3 downto 0);

end architecture;
