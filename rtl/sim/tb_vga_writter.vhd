-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity vga_writter_tb is
end;

architecture bench of vga_writter_tb is

  component vga_writter 
  	generic (
  		h_pulse  	: INTEGER := 96;
  		h_bp      : INTEGER := 48;
  		h_pixels 	: INTEGER := 640;
  		h_fp     	: INTEGER := 16;
  		h_pol    	: STD_LOGIC := '0';
  		v_pulse  	: INTEGER := 2;
  		v_bp     	: INTEGER := 33;
  		v_pixels 	: INTEGER := 480;
  		v_fp     	: INTEGER := 10;
  		v_pol    	: STD_LOGIC := '0'
  	);
  	port(
  		pixel_clk 	: IN   STD_LOGIC;
  		reset 		: IN STD_LOGIC;
  		din 		  : IN STD_LOGIC;
  		hsync 		: OUT STD_LOGIC;
  		vsync 		: OUT STD_LOGIC;
  		display  	: OUT  STD_LOGIC;
  		r, g, b		: OUT STD_LOGIC_VECTOR(3 downto 0)
  	);
  end component;

  signal pixel_clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal din: STD_LOGIC;
  signal hsync: STD_LOGIC;
  signal vsync: STD_LOGIC;
  signal display: STD_LOGIC;
  signal r, g, b: STD_LOGIC_VECTOR(3 downto 0) ;
  --real clock = 39.72 ns --> 25 MHz
  -- Pour 148.5 MHz
  constant clock_period: time := 39.7 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: vga_writter generic map ( h_pulse   => 96,
                                 h_bp      => 48,
                                 h_pixels  => 640,
                                 h_fp      => 16,
                                 h_pol     => '0',
                                 v_pulse   => 2,
                                 v_bp      => 33,
                                 v_pixels  => 480,
                                 v_fp      => 10,
                                 v_pol     => '0' )
                      port map ( pixel_clk => pixel_clk,
                                 reset     => reset,
                                 din       => din,
                                 hsync     => hsync,
                                 vsync     => vsync,
                                 display   => display,
                                 r         => r,
                                 g         => g,
                                 b         => b );

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    wait for 5 ns;
    reset <= '1';
	  wait for 40000000 ns;
    -- Put test bench stimulus code here
 
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
	pixel_clk <= '0';
	wait for clock_period/2;
	pixel_clk <= '1';
	wait for clock_period/2;
    end loop;
    wait;
  end process;
  
  dataIn: process
  begin
    while not stop_the_clock loop
      din <= '1';
      wait for 50 ns;
      din <= '0';
      wait for 50 ns;
      din <= '1';
      wait for 25 ns;
      din <= '0';
      wait for 25 ns;
    end loop;
    wait;
  end process; 
end;