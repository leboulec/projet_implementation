library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_reader is
	port (
		clk,aresetn: in std_logic; 
        din: in std_logic; --donnée entrante depuis l'ADC
        m_axis_tready : in std_logic; 
        mclk,bclk,lrck : out std_logic; 
            -- master clock = clock de l'ADC, 
            -- bit clock = indique chaque bit du signal = mclk/4
            -- left-right clock - indique début d'un nouveau mot

        m_axis_tvalid, m_axis_tlast : out std_logic;
        m_axis_tdata : out std_logic_vector (31 downto 0)
	) ;
end i2s_reader;

architecture RTL of i2s_reader is

    signal tmp_tdata : std_logic_vector (31 downto 0); --vecteur qui va contenir les bits de la sortie au fur et à mesure
    constant Divisor_clk_bclk : positive := 4; -- 8/2 on compte la demi-periode
    constant Divisor_clk_lrck : positive := 256; -- 512/2 on compte la demi-periode

    signal cmpt : integer range 0 to Divisor_clk_lrck*2 + 2 := 1;

    signal tmp_mclk : std_logic;
    signal tmp_bclk : std_logic;
    signal tmp_lrck : std_logic;
    signal state : std_logic_vector (1 downto 0);


begin

	process(clk, aresetn) 
	begin

        if (aresetn = '0') then 
		    tmp_tdata <= (others =>'0');
            cmpt <= 1;
            tmp_mclk <= '0';
            tmp_bclk <= '1';
            tmp_lrck <= '0';
            state <= (others =>'0');
            m_axis_tvalid <= '0';
            m_axis_tlast <= '0';

        elsif rising_edge(CLK) then

        if (m_axis_tready = '1' ) then 

            cmpt <= cmpt + 1;
            if (cmpt < Divisor_clk_lrck*2 + 2) then
               if ( cmpt mod Divisor_clk_bclk = 0 ) then --generate SCLK
                    tmp_bclk <= not(tmp_bclk);
                    state <= '0' & not(tmp_bclk); -- to detect falling edge
		       end if;
               
               if ( state = "00" ) then 
                    state <= "01";
                    tmp_tdata <= tmp_tdata(30 downto 0) & din;
		       end if;

               if ( cmpt mod Divisor_clk_lrck = 0 ) then --generate LCLK
                    state <= "10";
                end if;

                if (state = "10") then
                    state <= "01";
                    tmp_lrck <= not(tmp_lrck);
                    m_axis_tvalid <= '1';
                    m_axis_tlast <= '1';
               else 
                    m_axis_tvalid <= '0';
                    m_axis_tlast <= '0';
		       end if;

            else 
                cmpt <= 1;
            end if;

        end if;    


        end if;

	end process;

    mclk <= CLK;
    bclk <= tmp_bclk;
    lrck <= tmp_lrck;
    m_axis_tdata <= tmp_tdata;

end architecture;

           
