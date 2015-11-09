----------------------------------------------------------------------------------
-- Company: Dartmouth College
-- Engineer: Audyn Curless, Joon Cho
-- 
-- Create Date:    09:02:43 08/24/2015 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port ( clk 			  : in STD_LOGIC;
			  Keyboard_Value : in  STD_LOGIC_VECTOR (3 downto 0); --current key being pressed
			  Octave 		  : in STD_LOGIC_VECTOR (1 downto 0); --current octave
			  OnOff			  : in STD_LOGIC;
			  key_set_value  : out std_logic_vector (3 downto 0); --key being played
			  Increment 	  : out STD_LOGIC_VECTOR (10 downto 0); --increment associated with that key/octave
			  enablediv_tog  : out STD_logic; --enables LUT
			  Reset_sine_count : out STD_LOGIC); --enabled if no note is being played to mute sound
end Controller;

architecture Behavioral of Controller is

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
	constant octave_2 	: std_logic_vector (1 downto 0) := 		"10";
	constant octave_1		: std_logic_vector (1 downto 0) := 		"01";
	constant octave_3 	: std_logic_vector (1 downto 0) := 		"11";
	
	-- Constant: clock divider
	constant ENABLE_DIVIDER_VALUE : integer := 100E6 / 24000;
	
	-- enable counter signals
	signal enablediv : integer := 0;
	signal enable_count : unsigned (15 downto 0) := (others => '0');
	
	--increment signals
	signal skip_increment : integer := 0;
	signal increment_temp : unsigned(10 downto 0):=(others=>'0');
	signal temp_increment_temp : unsigned(10 downto 0):=(others=>'0');

	-- States
	type state_type is (waiting, Turned_on, idle, play_note, Turned_Off);
	signal PS : state_type := waiting;
	signal NS : state_type;
	
begin
	
	-- Calcualte the increment that the phase accumulator skips based on note
	Increment_Calculator : process (keyboard_value)
	begin
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
			when others =>
				skip_increment <= 151;
		end case;
	end process increment_calculator;
	
	-- assigns the skip increment to the temp_increment_temp var
	process(clk)
	begin
		if rising_edge(clk) then
			temp_increment_temp <= to_unsigned(skip_increment, 11);
		end if;
	end process;
	
	-- calculates actual increment based on temp_increment_temp and current octave
	octave_multi : process(octave, temp_increment_temp)
	begin
		case octave is
			when octave_1 =>
				increment_temp <= temp_increment_temp;
			
			when octave_2 =>
				increment_temp <= temp_increment_temp + temp_increment_temp;
				
			when octave_3 =>
				increment_temp <= temp_increment_temp + temp_increment_temp + temp_increment_temp + temp_increment_temp;
			when others =>
				increment_temp <= temp_increment_temp;
		end case;		
	end process octave_multi;
	
	-- Counter that gives the enable to the LUT
	Enable_Counter : process(clk)
	begin
		if rising_edge(clk) then
			if (enablediv = (ENABLE_DIVIDER_VALUE - 1)) then
				enablediv_tog <='1';
				enablediv <= 0;
				enable_count <= enable_count + 1;
			else
				enablediv <= enablediv + 1;
				enablediv_tog <='0';
			end if;
		end if;
	end process Enable_Counter;

	-- controller for updating states
	sync_state : process(clk, PS)
	begin
		if ( rising_edge(CLK) ) then 
			PS <= NS;
		end if;
	end process sync_state;
	
	-- updates the outputs increment and key_value 
	note_select : process(clk)
	begin
		if rising_edge(clk) then
			increment <= std_logic_vector(increment_temp);
			key_set_value <= keyboard_value;
		end if;
	end process note_select;
	
	-- state machine
	change_state : process(clk)
	begin
		case PS is 
		
			-- when the machine is first powered up but not turned on
			when waiting =>
				reset_sine_count <= '1';
				if (OnOff = '1') then
					NS <= turned_on;
				else
					NS <= waiting;
				end if;
			
			-- when the machine has been turned off, keyboard buttons are deactivated
			when turned_off => 
				reset_sine_count <= '1';
				if (onoff = '0') then
					NS <= turned_off;
				else
					NS <= idle;
				end if;
				
			-- inbetween state when machine is turned on from waiting state
			when turned_on =>
				NS <= idle;

			-- when no button is being pressed, display only shows octave and no sound is produced
			when idle =>
				reset_sine_count <= '1';
				if (onoff = '0') then 
					NS <= turned_off;
				elsif (keyboard_value /= "1111" and keyboard_value /= "0000") then			
					NS <= play_note;
				else
					NS <= idle;
				end if;
				
			-- when button is pressed, note is displayed on display and appropriate sound is produced
			when play_note =>
				reset_sine_count <= '0';
				if (onoff = '0') then 
					NS <= turned_off;
				elsif (keyboard_value /= "1111" and keyboard_value /= "0000") then
					NS <= play_note;
				else
					NS <= idle;
				end if;
			
		end case;
	end process change_state;

end Behavioral;

