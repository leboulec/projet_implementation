library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_writer is
  port (

    -- GLOBAL SIGNALS
    CLK, reset                  : in std_logic;

    -- DONGLE AUDIO
    dout                        : out std_logic;
    mclk_in, sclk_in, lrck_in   : in  std_logic;          

    -- SLAVE : AXI
    s_axis_tdata                : in  std_logic_vector(31 downto 0);
    s_axis_tvalid               : in  std_logic;
    s_axis_tready               : out std_logic;
    s_axis_tlast                : in  std_logic
);
    
end i2s_writer;

architecture RTL of i2s_writer is

signal dout_sig         : std_logic:=('0');
signal flag_start       : std_logic:=('0');
signal sig_tready       : std_logic:=('1');
signal data_temp        : std_logic_vector(31 downto 0);

begin

    dout            <= dout_sig;
    s_axis_tready   <= sig_tready;
    -- Process Reset synchrone
    process(CLK, reset)
    begin
        if rising_edge(CLK) then 
            if reset = '1' then
                dout_sig        <= '0'; 
                sig_tready      <= '1';
            end if;
        end if;
    end process;

    -- Process data transfer
    process(CLK, mclk_in, sclk_in, lrck_in)

        variable counter : Integer range 0 to 32;

    begin
        if s_axis_tvalid = '1' then
            data_temp <= s_axis_tdata;
        end if;

        if falling_edge(sclk_in) then

            if counter = 32 then

                counter     :=  0 ;
                flag_start  <= '0';
            end if;

            if falling_edge(lrck_in) or rising_edge(lrck_in) then
                flag_start <= '1';
            elsif flag_start = '1' then
                sig_tready  <= '0';
                dout_sig    <= data_temp(counter); 
                counter := counter + 1;
            end if;
        end if;

    end process;
    
end architecture;

