----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:31 08/18/2015 
-- Design Name: 
-- Module Name:    Keyboard_to_LUT - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Keyboard_to_LUT is
    Port ( clk : in STD_LOGIC;
			  Button : in STD_LOGIC_VECTOR ( 3 downto 0 );
			  Enable_SineCounter : in STD_LOGIC;
           LUT_Address : out  STD_LOGIC_VECTOR (14 downto 0)
			 );
end Keyboard_to_LUT;

architecture Behavioral of Keyboard_to_LUT is

	-- octave2 note_contants
	constant A 				: std_logic_vector (3 downto 0) := 		"0000";
	constant B_flat 		: std_logic_vector (3 downto 0) := 		"0001";
	constant B 				: std_logic_vector (3 downto 0) := 		"0010";
	constant C 				: std_logic_vector (3 downto 0) := 		"0011";
	constant C_sharp 		: std_logic_vector (3 downto 0) := 		"0100";
	constant D 				: std_logic_vector (3 downto 0) := 		"0101";
	constant D_sharp 		: std_logic_vector (3 downto 0) := 		"0111";
	constant E 				: std_logic_vector (3 downto 0) := 		"1000";
	constant F 				: std_logic_vector (3 downto 0) := 		"1001";
	constant F_sharp 		: std_logic_vector (3 downto 0) := 		"1010";
	constant G 				: std_logic_vector (3 downto 0) := 		"1011";
	constant G_sharp 		: std_logic_vector (3 downto 0) := 		"1100";
	
	-- signals to hold notes and skip increment for counter
	signal skip_increment : integer := 1;

	-- Counter for LUT signals
	signal Sine_count : integer range 0 to 32768:= 0;
	signal Sine_address : STD_LOGIC_VECTOR (14 downto 0) := (others => '0');
	signal reset_SineCounter : std_logic;

	-- States
	type state_type is (Turned_on, idle, play_note, Turned_Off);
	signal PS, NS : state_type;


begin

	-- process that decides the increment depending on the keyboard button pressed
	Increment_Calculator : process (button)
	begin
		case button is
			when A =>
				skip_increment <= 301;
			when B_flat =>
				skip_increment <= 319;
			when B =>
				skip_increment <= 338;
			when C =>
				skip_increment <= 358;
			when C_sharp =>
				skip_increment <= 379;
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
				skip_increment <= 1071;
			when G_sharp =>
				skip_increment <= 1135;
			when others =>
				skip_increment <= 0;
		end case;
	end process Increment_Calculator;

	-- Counter for the thing
	-- enable sinecounter gets enabled every few clock cycles or whatever 
	SineCounter : process (clk, reset_SineCounter, enable_SineCounter) 
	begin
		if (rising_edge(clk)) then
			if (reset_SineCounter = '1') then
				Sine_count <= 0;
			elsif (enable_SineCounter = '1') then
				if (sine_count+skip_increment)>32767 then
					Sine_Count <= Sine_count + skip_increment-32767;
				else
					Sine_Count <= Sine_count + skip_increment;
				end if;
			end if;
		end if;

		LUT_Address <= std_logic_vector(to_unsigned(Sine_Count, 15));
		
	end process SineCounter;



	-- controller for states
	sync_state : process(clk, PS)
	begin
		if ( rising_edge(CLK) ) then 
			PS <= NS;
		end if;
	end process sync_state;

	change_state : process(clk)
	begin
		case PS is 
			when turned_off => 
				-- make one sound
				-- disable everything
				-- turn power off

			when turned_on =>
				-- initialize shit
				--enable everything
				-- power is on

			-- when no button has been pressed, we are in idle
			when idle =>
				---
			-- when button is pressed, no other buttons will effect the note and we "lock" the note being played
			when play_note =>
			
			

		end case;
	end process change_state;


end Behavioral;

