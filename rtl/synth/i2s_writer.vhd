library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_writer is
  port (

    -- GLOBAL SIGNALS
    clk, reset                  : in std_logic;

    -- DONGLE AUDIO
    dout                        : out std_logic;
    mclk_in, sclk_in, lrck_in   : out  std_logic;          

    -- SLAVE : AXI
    s_axis_tdata                : in  std_logic_vector(31 downto 0);
    s_axis_tvalid               : in  std_logic;
    s_axis_tready               : out std_logic;
    s_axis_tlast                : in  std_logic
);
    
end i2s_writer;

architecture RTL of i2s_writer is

    signal tmp_dout : std_logic;
    constant Divisor_clk_bclk : positive := 4; -- 8/2 on compte la demi-periode
    constant Divisor_clk_lrck : positive := 256; -- 512/2 on compte la demi-periode

    signal tmp_mclk : std_logic;
    signal tmp_bclk : std_logic;
    signal tmp_lrck : std_logic;
    signal state : std_logic_vector (1 downto 0);
    signal nombre : integer range 0 to 32 := 32;
    signal tmp_s_axis_tdata : std_logic_vector(31 downto 0);

begin

        process(clk, reset) 
        variable cmpt : integer range 0 to Divisor_clk_lrck + 2 := 1;
        variable ntm : integer range 0 to 1 :=0;
            begin

            if (reset = '0') then
                tmp_dout <= '0';
                cmpt := 1;
                nombre <= 32;
                tmp_mclk <= '0';
                tmp_bclk <= '1';
                tmp_lrck <= '0';
                state <= "01";
                s_axis_tready <= '1';

            elsif rising_edge(CLK) then
                    s_axis_tready <= '1';

                    if( s_axis_tvalid = '1' and ntm = 0 ) then
                        ntm := 1;
                        s_axis_tready <= '0';
                        tmp_s_axis_tdata <= s_axis_tdata;
                    end if; 
 
                    if (cmpt < Divisor_clk_lrck+1) then
                       if ( cmpt mod Divisor_clk_bclk = 0) then --generate SCLK
                            tmp_bclk <= not(tmp_bclk);
                            state <= '0' & not(tmp_bclk); -- to detect falling edge
                       end if;

                       if ( state = "00" ) then 
                            state <= "01";
                            tmp_dout <= tmp_s_axis_tdata(nombre - 1); -- 31
                            nombre <= nombre - 1;
                       end if;

                       if ( cmpt mod Divisor_clk_lrck = 0 ) then --generate LCLK
                            nombre <= 32;
                            ntm := 0;
                            tmp_lrck <= not(tmp_lrck);
                            s_axis_tready <= '1';
                        end if;

                    else 
                        cmpt := 1;
                    end if;

                    cmpt := cmpt + 1;
            end if;
    end process;

    mclk_in <= clk;
    sclk_in <= tmp_bclk;
    lrck_in <= tmp_lrck;
    dout <= tmp_dout;

end architecture;