----------------------------------------------------------------------------------
-- Company: 			Engs 31 15X
-- Engineer: 			E.W. Hansen
-- 
-- Create Date:    	17:56:35 07/25/2008 / revised 07/17/2015
-- Design Name: 	
-- Module Name:    	mux7seg - Behavioral 
-- Project Name: 		
-- Target Devices: 	Digilent Nexys 2 board
-- Tool versions: 	ISE 14.7
-- Description: 		Multiplexed seven-segment decoder for the display on the
--							Nexys 2 board
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.00 (07/17/2015) --- drop the clock divider, run on a 1000 Hz clock
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux7seg is
    Port ( clk : in  STD_LOGIC;												-- runs on a slow (100 Hz or so) clock
           keyboard_value : in  STD_LOGIC_VECTOR (3 downto 0);		-- digits
			  octave : in STD_LOGIC_VECTOR (1 downto 0);
           seg : out  STD_LOGIC_VECTOR(0 to 6);							-- segments (a...g)
           an : out  STD_LOGIC_VECTOR (3 downto 0) );					-- anodes
end mux7seg;

architecture Behavioral of mux7seg is

	-- notes constants
	constant No_note 		: std_logic_vector (3 downto 0) := 		"0000";
	constant A 				: std_logic_vector (3 downto 0) := 		"0001";
	constant B_flat 		: std_logic_vector (3 downto 0) := 		"0010";
	constant B 				: std_logic_vector (3 downto 0) := 		"0011";
	constant C 				: std_logic_vector (3 downto 0) := 		"0100";
	constant C_sharp 		: std_logic_vector (3 downto 0) := 		"0101";
	constant D 				: std_logic_vector (3 downto 0) := 		"0111";
	constant D_sharp 		: std_logic_vector (3 downto 0) := 		"1000";
	constant E 				: std_logic_vector (3 downto 0) := 		"1001";
	constant F 				: std_logic_vector (3 downto 0) := 		"1010";
	constant F_sharp 		: std_logic_vector (3 downto 0) := 		"1011";
	constant G 				: std_logic_vector (3 downto 0) := 		"1100";
	constant G_sharp 		: std_logic_vector (3 downto 0) := 		"1101";
	
	-- octave constants
	constant octave_2 	: std_logic_vector (1 downto 0) := 		"00";
	constant octave_1		: std_logic_vector (1 downto 0) := 		"01";
	constant octave_3 	: std_logic_vector (1 downto 0) := 		"11";
	
	signal adcount : unsigned(1 downto 0) := "00";		-- anode / mux selector count
	signal muxy : std_logic_vector(3 downto 0);			-- mux output
	signal segh : std_logic_vector(0 to 6);				-- segments (high true)
begin			

AnodeDriver:
process(clk, adcount)
begin	
	if rising_edge(clk) then
		adcount <= adcount + 1;
	end if;
	
	case adcount is
		when "00" => an <= "1110";
		when "01" => an <= "1101";
		when "10" => an <= "1011";
		when "11" => an <= "0111" ;
		when others => an <= "1111";
	end case;
end process AnodeDriver;

Segment_Process:
process(keyboard_value, octave)
begin
	case octave is 
		-- if octave is 2 (middle) then
		when octave_2 =>
			case keyboard_value is 
				when A =>
					keyboard_octave_code <= "00001"
				when B_flat =>
					keyboard_octave_code <= "00010"
				when B =>
					keyboard_octave_code <= "00011"
				when C =>
					keyboard_octave_code <= "00100"
				when C_sharp =>
					keyboard_octave_code <= "00101"
				when D =>
					skip_increment <= 401;
				when D_sharp =>
					skip_increment <= 425;
				when E =>
					skip_increment <= 451;
				when F =>
					skip_increment <= 477;
				when F_sharp =>
					skip_increment <= 506;
				when G =>
					skip_increment <= 536;
				when G_sharp =>
					skip_increment <= 568;
			end case;
		-- octave down
		when octave_1 =>
			case keyboard_value is 
				when A =>
					skip_increment <= 151;
				when B_flat =>
					skip_increment <= 160;
				when B =>
					skip_increment <= 169;
				when C =>
					skip_increment <= 179;
				when C_sharp =>
					skip_increment <= 190;
				when D =>
					skip_increment <= 201;
				when D_sharp =>
					skip_increment <= 213;
				when E =>
					skip_increment <= 226;
				when F =>
					skip_increment <= 239;
				when F_sharp =>
					skip_increment <= 253;
				when G =>
					skip_increment <= 268;
				when G_sharp =>
					skip_increment <= 284;	
			end case;
		--octave up		
		when octave_1 =>
			case keyboard_value is 
				when A =>
					skip_increment <= 601;
				when B_flat =>
					skip_increment <= 637;
				when B =>
					skip_increment <= 675;
				when C =>
					skip_increment <= 715;
				when C_sharp =>
					skip_increment <= 757;
				when D =>
					skip_increment <= 802;
				when D_sharp =>
					skip_increment <= 850;
				when E =>
					skip_increment <= 901;
				when F =>
					skip_increment <= 954;
				when F_sharp =>
					skip_increment <= 1011;
				when G =>
					skip_increment <= 1071;
				when G_sharp =>
					skip_increment <= 1135;
			end case;
	end case;
				
	
	
	
Multiplexer:
process(adcount, y0, y1, y2, y3)
begin
	case adcount is
		when "00" => muxy <= octave;
		when "01" => muxy <= "0000";
		when "10" => muxy <= ;
		when "11" => muxy <= y3;
		when others => muxy <= x"0";
	end case;
end process Multiplexer;

with muxy select segh <=
	"1110111" when "0001,	
	"0011111" when x"b",	
	"1001110" when x"c",	
	"0111101" when x"d",	
	"1001111" when x"e",	
	"1000111" when x"f",		





-- Seven segment decoder
with muxy select segh <=
	"1111110" when x"0",		-- active-high definitions
	"0110000" when x"1",
	"1101101" when x"2",
	"1111001" when x"3",
	"0110011" when x"4",
	"1011011" when x"5",
	"1011111" when x"6",
	"1110000" when x"7",
	"1111111" when x"8",
	"1111011" when x"9",
	"1110111" when x"a",	
	"0011111" when x"b",	
	"1001110" when x"c",	
	"0111101" when x"d",	
	"1001111" when x"e",	
	"1000111" when x"f",	
	"0000000" when others;	
seg <= not(segh);				-- Convert to active-low

end Behavioral;

