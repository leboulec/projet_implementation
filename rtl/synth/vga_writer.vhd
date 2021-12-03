LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_writter is 
	generic (
		-- Accordez les valeurs en fonction la r√©solution et du taux de rafra√Æchissement √† l'aide de la table : VGA Timing Specifications
		-- Ici on choisit une r√©solution de 640x480 pixels, 60 Hz
		-- pixel_clk = 25.175 MHz
		h_pulse  	: INTEGER := 96;    --horiztonal sync pulse width in pixels
		h_bp      : INTEGER := 48;    --horiztonal back porch width in pixels
		h_pixels 	: INTEGER := 640;   --horiztonal display width in pixels
		h_fp     	: INTEGER := 16;    --horiztonal front porch width in pixels
		h_pol    	: STD_LOGIC := '0';  --horizontal sync pulse polarity (1 = positive, 0 = negative)
		v_pulse  	: INTEGER := 2;      --vertical sync pulse width in rows
		v_bp     	: INTEGER := 33;     --vertical back porch width in rows
		v_pixels 	: INTEGER := 480;   --vertical display width in rows
		v_fp     	: INTEGER := 10;      --vertical front porch width in rows
		v_pol    	: STD_LOGIC := '0'  --vertical sync pulse polarity (1 = positive, 0 = negative)
	);

	port(
		pixel_clk 	: IN   STD_LOGIC;
		reset 		: IN STD_LOGIC;
		din 		: IN STD_LOGIC;
		hsync 		: OUT STD_LOGIC;
		vsync 		: OUT STD_LOGIC;
		display  	: OUT  STD_LOGIC;  --display time ou blink si = 0
		r, g, b		: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity;

architecture behave of vga_writter is
	-- DÈclaration des signaux internes (compteurs)
	CONSTANT h_period : INTEGER := h_pulse + h_bp + h_pixels + h_fp; --Nombre de coup de clock horizontal
	CONSTANT v_period : INTEGER := v_pulse + v_bp + v_pixels + v_fp; --Nombre de coup de clock vertical
	signal h_count : INTEGER RANGE 0 TO h_period := 0; -- Compteur horizontal
	--signal h_count : INTEGER RANGE 0 TO h_period := 1; -- Compteur horizontal
	signal v_count : INTEGER RANGE 0 TO v_period := 0; -- Compteur vertical
	begin
		process(pixel_clk, reset)
			begin
				if reset = '0' then -- Reset
					hsync <= h_pol;
					vsync <= v_pol;
					h_count <= 0;
					v_count <= 0;
					display <= '0';
					r <= (others => '0');
					g <= (others => '0');
					b <= (others => '0');
				elsif pixel_clk'event and pixel_clk = '1' then -- DÈtection de front montant

					-- Synchronisation des signaux hsync, vsync
					if (h_count < h_pixels + h_fp or h_count >= h_period - h_bp) then
						hsync <= NOT h_pol;    --deassert horiztonal sync pulse
					else
						hsync <= h_pol;        --assert horiztonal sync pulse
					end if;
					  
					if(v_count < v_pixels + v_fp or v_count >= v_period - v_bp) then
						vsync <= NOT v_pol;    --deassert vertical sync pulse
					else
						vsync <= v_pol;        --assert vertical sync pulse
					end if;
					  
					-- Code RGB en fonction de din pendant le display time
					if ((h_count <= h_pixels) and (v_count <= v_pixels)) or ( (v_count >= v_period - 1) and (h_count >= h_period - 1) ) then  --display time
						display <= '1';
          				if din = '1' then
							r <= "0000";
							g <= "0000";
							b <= "1111";
						elsif din = '0' then
							r <= "1111";
							g <= "1111";
							b <= "0000";
						end if;
					else
						display <= '0';                                -- Blanking time
						r <= "0000";
						g <= "0000";
						b <= "0000";
					end if;
					
					-- Reset / IncrÈmentation des compteurs
					if h_count < h_period - 1 then
					  h_count <= h_count + 1;
					else 
					  h_count <= 0;
					  if v_count < v_period - 1 then
					     v_count <= v_count + 1;
					  else
					     v_count <= 0;
					  end if;
					end if;
				end if;
		end process;
end architecture;