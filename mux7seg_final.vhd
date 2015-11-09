----------------------------------------------------------------------------------
-- Company: Dartmouth College
-- Engineer: Audyn Curless, Joon Cho
-- 
-- Create Date:    23:23:46 08/25/2015 
-- Design Name: 
-- Module Name:    mux7seg_final - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity mux7seg_final is
    Port ( clk : in  STD_LOGIC;
           keyboard_value : in  STD_LOGIC_VECTOR (3 downto 0);
           octave : in  STD_LOGIC_VECTOR (1 downto 0);
           seg : out  STD_LOGIC_VECTOR (0 to 6);
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end mux7seg_final;

architecture Behavioral of mux7seg_final is

	----------- // CONSTANTS OF NOTES AND OCTAVES SPERATELY //---------
	
	-- notes constants
	constant No_note 		: std_logic_vector (3 downto 0) := 		"0000";
	constant A 				: std_logic_vector (3 downto 0) := 		"0001";
	constant B_flat 		: std_logic_vector (3 downto 0) := 		"0010";
	constant B 				: std_logic_vector (3 downto 0) := 		"0011";
	constant C 				: std_logic_vector (3 downto 0) := 		"0100";
	constant D_flat 		: std_logic_vector (3 downto 0) := 		"0101";
	constant D 				: std_logic_vector (3 downto 0) := 		"0111";
	constant E_flat 		: std_logic_vector (3 downto 0) := 		"1000";
	constant E 				: std_logic_vector (3 downto 0) := 		"1001";
	constant F 				: std_logic_vector (3 downto 0) := 		"1010";
	constant G_flat 		: std_logic_vector (3 downto 0) := 		"1011";
	constant G 				: std_logic_vector (3 downto 0) := 		"1100";
	constant A_flat 		: std_logic_vector (3 downto 0) := 		"1101";
	
		-- octave constants
	constant octave_2 	: std_logic_vector (1 downto 0) := 		"10";
	constant octave_1		: std_logic_vector (1 downto 0) := 		"01";
	constant octave_3 	: std_logic_vector (1 downto 0) := 		"11";

	--------------- // CONSTANTS FOR DISPLAY //----------------------
	
	constant no_display 		: std_logic_vector (0 to 6) := "0000000";
	constant octave_display	: std_logic_vector (0 to 6) := "1001110";					-- C
	constant flat_display 				: std_logic_vector (0 to 6) := "0011111";		-- b

	constant A_display		: std_logic_vector (0 to 6) := "1110111";						 
	constant b_display		: std_logic_vector (0 to 6) := "0011111";			 
	constant C_display		: std_logic_vector (0 to 6) := "1001110";				
	constant d_display		: std_logic_vector (0 to 6) := "0111101";			
	constant E_display		: std_logic_vector (0 to 6) := "1001111";				
	constant F_display		: std_logic_vector (0 to 6) := "1000111";				
	constant G_display		: std_logic_vector (0 to 6) := "1011111";			

	constant error_display	: std_logic_vector (0 to 6) := "1100001";
	constant one_display		: std_logic_vector (0 to 6) := "0110000";
	constant two_display		: std_logic_vector (0 to 6) := "1101101";
	constant three_display		: std_logic_vector (0 to 6) := "1111001";
	
	-------------------- // CONSTANTS FOR MUXY ENCODING //--------------------
	
	constant No_Note_indication		: std_logic_vector (3 downto 0) := "0000";
	constant A_indication 				: std_logic_vector (3 downto 0) := "0001";
	constant B_indication 				: std_logic_vector (3 downto 0) := "0010";
	constant C_indication 				: std_logic_vector (3 downto 0) := "0011";
	constant D_indication 				: std_logic_vector (3 downto 0) := "0100";
	constant E_indication 				: std_logic_vector (3 downto 0) := "0101";
	constant F_indication 				: std_logic_vector (3 downto 0) := "0110";
	constant G_indication 				: std_logic_vector (3 downto 0) := "0111";
	
	constant Flat_on_indication 		: std_logic_vector (3 downto 0) := "1000";
	constant Flat_off_indication 		: std_logic_vector (3 downto 0) := "1001";
	
	constant Octave_1_indication 		: std_logic_vector (3 downto 0) := "1010";
	constant Octave_2_indication 		: std_logic_vector (3 downto 0) := "1011";
	constant Octave_3_indication 		: std_logic_vector (3 downto 0) := "1100";
	
	
	----------------------- // SIGNALS FOR 7 SEGMENT  //-----------------------

	signal adcount : unsigned(1 downto 0) := "00";		-- anode / mux selector count
	signal muxy : std_logic_vector (3 downto 0);			-- mux output
	signal segh : std_logic_vector (0 to 6);				-- segments (high true)
	
	------------------- // SIGNALS TO CHANGE BETWEEN SEVERAL MUXY  //----------
	
	-- upon new button we set these parameters and a process will decid which one becomes segh
	signal flat_indicator 				: std_logic_vector (3 downto 0);
	signal octave_indicator				: std_logic_vector (3 downto 0);
	signal note_indicator				: std_logic_vector (3 downto 0);
	signal octave_letter_indicator 	: std_logic_vector (3 downto 0) := C_indication;
	

begin

	-- anode driver that powers each seven segment display in order
	AnodeDriver: process(clk, adcount)
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
	
	-- sets what the seven segment displays should show based on current note and octave
	Segment_Process: process(keyboard_value, octave)
	begin
		flat_indicator <= flat_off_indication;
		note_indicator <= no_note_indication;

		-- set the octave display
		case octave is
			when octave_1 =>
				octave_indicator <= octave_1_indication;
			when octave_2 =>
				octave_indicator <= octave_2_indication;
			when octave_3 =>
				octave_indicator <= octave_3_indication;
			when others =>
				octave_indicator <= octave_2_indication;
		end case;

		-- set the note display
		case keyboard_value is 
			when A =>
				flat_indicator <= flat_off_indication;
				note_indicator <= A_indication;
			when B_flat =>
				flat_indicator <= flat_on_indication;
				note_indicator <= B_indication;
			when B =>
				flat_indicator <= flat_off_indication;
				note_indicator <= B_indication;
			when C =>
				flat_indicator <= flat_off_indication;
				note_indicator <= C_indication;
			when D_flat =>
				flat_indicator <= flat_on_indication;
				note_indicator <= D_indication;
			when D =>
				flat_indicator <= flat_off_indication;
				note_indicator <= D_indication;
			when E_Flat =>
				flat_indicator <= flat_on_indication;
				note_indicator <= E_indication;
			when E =>
				flat_indicator <= flat_off_indication;
				note_indicator <= E_indication;
			when F =>
				flat_indicator <= flat_off_indication;
				note_indicator <= F_indication;
			when G_flat =>
				flat_indicator <= flat_on_indication;
				note_indicator <= G_indication;
			when G =>
				flat_indicator <= flat_off_indication;
				note_indicator <= G_indication;
			when A_flat =>
				flat_indicator <= flat_on_indication;
				note_indicator <= A_indication;
			when others =>
				flat_indicator <= flat_off_indication;
				note_indicator <= no_note_indication;
		end case;

	end process Segment_Process;
	
	-- mux that tells which seven segment display to show which indivator
	Multiplexer: process(adcount, flat_indicator, note_indicator, octave_indicator, octave_letter_indicator)
	begin
		case adcount is
			when "00" => muxy <= flat_indicator;
			when "01" => muxy <= note_indicator;
			when "10" => muxy <= octave_indicator;
			when "11" => muxy <= octave_letter_indicator;
			when others => muxy <= "0000";
		end case;
	end process Multiplexer;
	
	-- all active high
	with muxy select segh <=
		no_display		when no_note_indication,
		A_display 		when A_indication,
		B_display 		when B_indication,
		C_display 		when C_indication,
		D_display 		when D_indication,
		E_display 		when E_indication,
		F_display 		when F_indication,
		G_display 		when G_indication,
		one_display 		when Octave_1_indication,
		two_display 		when Octave_2_indication,
		three_display 		when Octave_3_indication,
		no_display 		when flat_off_indication,
		flat_display 	when flat_on_indication,
		no_display 		when others;
	seg <= not(segh);	-- convert to active low
	
end Behavioral;

