--test tb de l'i2s reader 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity tb_i2s_reader is
end entity;

architecture bench of tb_i2s_reader is

    component i2s_reader is
        port (
		clk,aresetn: in std_logic; 
        din: in std_logic; --donnée entrante depuis l'ADC
        m_axis_tready : in std_logic; 
        mclk,bclk,lrck : out std_logic; 
        m_axis_tvalid, m_axis_tlast : out std_logic;
        m_axis_tdata : out std_logic_vector (31 downto 0));
    end component;

    signal clk,aresetn : std_logic; 
    signal din: std_logic; --donnée entrante depuis l'ADC
    signal m_axis_tready : std_logic; 
    signal mclk,bclk,lrck :  std_logic; 
    signal m_axis_tvalid, m_axis_tlast : std_logic;
    signal m_axis_tdata : std_logic_vector (31 downto 0);

    signal full_din : std_logic_vector(31 downto 0):="11010011101101010001011010011010";
    signal counter : std_logic_vector(4 downto 0):="11111";


begin

m_axis_tready <= '1';

inst: i2s_reader port map (
		clk => clk ,
        aresetn => aresetn, 
        din => din , 
        m_axis_tready => m_axis_tready,  
        mclk => mclk,
        bclk => bclk,
        lrck => lrck, 
        m_axis_tvalid => m_axis_tvalid, 
        m_axis_tlast => m_axis_tlast,
        m_axis_tdata => m_axis_tdata);

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


Main : process(bclk)
begin

	if m_axis_tvalid = '0' and falling_edge(bclk) then
	
		din <= full_din(to_integer(unsigned(counter)));
		counter <= std_logic_vector(unsigned(counter) - 1);
	
	end if;

	if m_axis_tvalid = '1' then

		counter <= (others => '1');

	end if;
end process Main;

Asserting : process(m_axis_tvalid)
begin
	if m_axis_tvalid = '1' then
		assert m_axis_tdata = "11010011101101010001011010011010" report "Wrong Data" severity error;

	end if;
end process Asserting;


	
end architecture;
