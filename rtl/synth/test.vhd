library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
  port (
    nreset, CLK                 :  in std_logic;
    din                         :  in std_logic;
    m_axis_tready               :  in std_logic; 
    mclk, sclk, lrck            :  out std_logic;           
    m_axis_tvalid, m_axis_tlast :  out std_logic; --Flag for the DMA controller
    m_axis_tdata                :  out std_logic_vector(31 downto 0)
    
    -- in order to know the side of the 
  ) ;
end test;


architecture arch of test is

    signal clk_diviseur         :   unsigned(2 downto 0);
    signal counter              :   unsigned(8 downto 0);
    signal data_shift           :   std_logic_vector(31 downto 0):=(others => '0');
    signal lrck_sig             :   std_logic;
    signal toggle               :   std_logic;

begin

    mclk <= CLK;
    lrck <= lrck_sig;
    sclk <= clk_diviseur(2);
    m_axis_tdata <= data_shift;
    
process(CLK, nreset) --Diviseur de frequence

begin
-- clocker
	if nreset = '0' then
		clk_diviseur    <= "000";
        m_axis_tlast    <= '0';
        m_axis_tvalid   <= '0';
        data_shift      <= (others => '0');
        counter         <= "000000001";
        lrck_sig        <= '0';
    end if;
     
    if rising_edge(CLK) then
        
        clk_diviseur <= clk_diviseur + 1;
        counter <= counter + 1;
       
        if clk_diviseur = "000" then -- if falling_edge(sclk)
            toggle <= '1';
        end if;
        
        if toggle = '1' then
            data_shift <= data_shift(30 downto 0) &	din;
            toggle <= '0';
        end if;
       
        if counter(8) = '1' then -- if front montant ou descendant de lrck 
            m_axis_tvalid <= '1';
            m_axis_tlast <= '1';
            counter <= "000000001";
            lrck_sig <= not(lrck_sig);
            toggle <= '0';
        else
            m_axis_tvalid <= '0';
            m_axis_tlast <= '0';
        end if;
        
    end if;

end process;

end arch ; -- arch