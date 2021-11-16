library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bench_reader is
end bench_reader;

architecture test_reader of bench_reader is

component test
	port(

    -- GLOBAL SIGNALS
    nreset, CLK          :  in std_logic;

    -- DONGLE AUDIO
    din                 :  in std_logic;
    mclk, sclk, lrck    :  out std_logic;           

    -- MASTER : RESULT
    m_axis_tdata        : out std_logic_vector(31 downto 0);
    m_axis_tvalid       : out std_logic;
    m_axis_tready       : in  std_logic;
    m_axis_tlast        : out std_logic);

end component;

-- GLOBAL SIGNALS
signal CLK					: std_logic:='1';
signal nreset				: std_logic;

-- MASTER : RESULT
signal m_axis_tdata 		: std_logic_vector(31 downto 0);
signal m_axis_tvalid 		: std_logic;
signal m_axis_tready 		: std_logic:='1';
signal m_axis_tlast			: std_logic;

signal full_din 			: std_logic_vector(31 downto 0):="11010011101101010001011010011010"; --mon Payload
signal fdout 				: std_logic:='0';
signal counter 				: std_logic_vector(4 downto 0):="11110";

-- DONGLE AUDIO
signal din 					: std_logic:=full_din(31);
signal mclk, sclk, lrck		: std_logic;


begin

MAIN_CLOCK : process
begin

	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;

end process MAIN_CLOCK;

Reset_process : process
begin
	nreset <= '0';
	wait for 50 ns;
	nreset <= '1';
	wait;
	
end process Reset_process;

Main : process(sclk)
begin

	if m_axis_tvalid = '0' and falling_edge(sclk) then
	
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

		assert m_axis_tdata = "11010011101101010001011010011010" report "Le payload est faux" severity error;

	end if;
end process Asserting;


 i2s : test port map(CLK => CLK, nreset => nreset, din => din, mclk => mclk, sclk => sclk, lrck => lrck, m_axis_tdata => m_axis_tdata, m_axis_tvalid => m_axis_tvalid, m_axis_tready => m_axis_tready, m_axis_tlast => m_axis_tlast);

end architecture;