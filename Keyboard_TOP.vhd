----------------------------------------------------------------------------------
-- Company: Dartmouth College
-- Engineer: Audyn Curless, Joon Cho
-- 
-- Create Date:    13:06:24 08/20/2015 
-- Design Name: 
-- Module Name:    Keyboard_TOP - Behavioral 
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

entity Keyboard_TOP is
    Port ( CLK : in  STD_LOGIC;
				Button_octave : STD_LOGIC; --button to cycle through octaves
				Button1 : in  STD_LOGIC; --keyboard buttons
				Button2 : in  STD_LOGIC;
				Button3 : in  STD_LOGIC;
				Button4 : in  STD_LOGIC;
				Button5 : in  STD_LOGIC;
				Button6 : in  STD_LOGIC;
				Button7 : in  STD_LOGIC;
				Button8 : in  STD_LOGIC;
				Button9 : in  STD_LOGIC;
				Button10 : in  STD_LOGIC;
				Button11 : in  STD_LOGIC;
				Button12 : in  STD_LOGIC;
				onoff : in std_logic; --on/off switch
				ain : out std_logic; --output signal that is turned into audio by ampifier
				gain : out std_logic; --loudness of sound (set at lower setting permentantly)
				shutdown : out std_logic; 
				segments : out std_logic_vector(0 to 6); --seven segment display output
				anodes : out std_logic_vector(3 downto 0) --anode driver for display output
			);
end Keyboard_TOP;

architecture Behavioral of Keyboard_TOP is

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
	
	-- keyboard signals
	signal keyboard_value : std_logic_vector (3 downto 0) := "1111";
	signal key_hold_value : std_logic_vector (3 downto 0) := "1111";
	
	-- phase accumulator signals
	signal LUT_Address : std_logic_vector (14 downto 0);
	signal sine : std_logic_vector (11 downto 0);
	signal enable_div_tog : std_logic;
	signal increment_intern : STD_LOGIC_VECTOR (10 downto 0);
	
	--pwm signals
	signal reset : std_logic := '1';
	signal enable : std_logic := '1';
	signal reset_sine_count : std_logic := '0';
	
	--octave button debounce and monopulse signals
	signal pulse, latch, button_octave_db : std_logic;

	--octave assignment signals
	signal cur_octave : std_logic_vector (1 downto 0) := "10";
	signal curcur_octave : std_logic_vector (1 downto 0) := "10";
	
	--clock divider for display signals and constants
	constant CLOCK_DIVIDER_VALUE2: integer := 1E4; 
	signal clkdiv2: integer := 0;	
	signal clkdiv_tog2: std_logic := '0';
	
	--controller that outputs increment size to phase accumulator
	COMPONENT Controller
	PORT(
		clk : IN std_logic;
		Keyboard_Value : IN std_logic_vector(3 downto 0);
		Octave : IN std_logic_vector(1 downto 0);
		OnOff : IN std_logic;  
		key_set_value : OUT std_logic_vector(3 downto 0);
		enablediv_tog  : out STD_logic;
		Increment : OUT std_logic_vector(10 downto 0);
		Reset_sine_count : OUT std_logic
		);
	END COMPONENT;
	
	--seven segment display that shows current note and octave
	COMPONENT mux7seg_final
	PORT(
		clk : IN std_logic;
		keyboard_value : IN std_logic_vector(3 downto 0);
		octave : IN std_logic_vector(1 downto 0);          
		seg : OUT std_logic_vector(0 to 6);
		an : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	--phase accumulator
	COMPONENT Phase_Accumulator
	PORT(
		clk : in std_logic;
		Skip_increment : IN std_logic_vector(10 downto 0);
		reset_sineCounter : IN std_logic;       
		enable_sinecounter : in std_logic;
		LUT_Address : OUT std_logic_vector(14 downto 0)
		);
	END COMPONENT;
	
	--sine wave look up table that produces signal to the pulse width modulator
	COMPONENT SineWave 
	  PORT (
		 clk : IN STD_LOGIC;
		 phase_in : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		 sine : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	  );
	END COMPONENT;
  
	--pulse width modulator that sends signal to amplifier that is turned into audio
	COMPONENT pwm
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		enable : IN std_logic;  
		sine_lut : IN STD_LOGIC_VECTOR(11 downto 0);
		ain : OUT std_logic;
		gain : OUT std_logic;
		shutdown : OUT std_logic
		);
	END COMPONENT;
	
	--debouncer to debounce the button_octave input
	COMPONENT debouncer
	PORT(
		clk : IN std_logic;
		switch : IN std_logic;          
		dbswitch : OUT std_logic
		);
	END COMPONENT;
  
begin

	Inst_Controller: Controller PORT MAP(
		clk => clk,
		Keyboard_Value => keyboard_value,
		Octave => cur_octave,
		OnOff => onoff,
		key_set_value => key_hold_value,
		enablediv_tog => enable_div_tog,
		Increment => increment_intern,
		Reset_sine_count => reset_sine_count
	);
	
	Inst_Phase_Accumulator: Phase_Accumulator PORT MAP(
		clk => clk,
		Skip_increment => increment_intern,
		reset_sineCounter => reset_sine_count,
		enable_sinecounter => enable_div_tog,
		LUT_Address => LUT_address
	);

	sineWave_LUT : SineWave
	  PORT MAP (
		 clk => CLK,
		 phase_in => LUT_address,
		 sine => sine
	  );
	  
	Inst_debouncer: debouncer PORT MAP(
		clk => clk,
		switch => button_octave,
		dbswitch => button_octave_db
	);
	  
	Inst_mux7seg_final: mux7seg_final PORT MAP(
		clk => clkdiv_tog2,
		keyboard_value => key_hold_value,
		octave => cur_octave,
		seg => segments,
		an => anodes
	);
	
	Inst_pwm: pwm PORT MAP(
		clk => clk,
		reset => reset,
		enable => enable,
		sine_lut => sine,
		ain => ain,
		gain => gain,
		shutdown => shutdown
	);
	
	--clock divider to slow clock down for seven segment display
	Clock_divider: process(clk)
	begin
		if rising_edge(clk) then
				if clkdiv2 = CLOCK_DIVIDER_VALUE2-1 then 
					clkdiv_tog2 <= NOT(clkdiv_tog2);		
				clkdiv2 <= 0;
			else
				clkdiv2 <= clkdiv2 + 1;
			end if;
		end if;
	end process Clock_divider;

	-- checks button signals and outputs signal for which keyboard value has been pressed
	Button_Interpret : process(button1, button2, button3, button4, button5, button6, button7,
											button8, button9, button10, button11, button12)
	begin
		
		if (button1 = '1') then
			keyboard_value <= A;
		elsif (button2 = '1') then
			keyboard_value <= B_Flat;
		elsif (button3 = '1') then
			keyboard_value <= B;
		elsif (button4 = '1') then
			keyboard_value <= C;
		elsif (button5 = '1') then
			keyboard_value <= C_sharp;
		elsif (button6 = '1') then
			keyboard_value <= D;
		elsif (button7 = '1') then
			keyboard_value <= D_sharp;
		elsif (button8 = '1') then
			keyboard_value <= E;
		elsif (button9 = '1') then
			keyboard_value <= F;
		elsif (button10 = '1') then
			keyboard_value <= F_sharp;
		elsif (button11 = '1') then
			keyboard_value <= G;
		elsif (button12 = '1') then
			keyboard_value <= G_sharp;
		else
			keyboard_value <= "1111";
		end if;
	
	end process Button_interpret;
	
	--monopulser for octave button
	mono_proc: process(clk, button_octave_db)
	begin
		if (rising_edge(clk)) then
			if (button_octave_db = '1') then
				if (latch = '0') then
					pulse <= '1';
					latch <= '1';
				else pulse <= '0';
				end if;
			else
				latch <= '0';
				pulse <= '0';
			end if;
		end if;
	end process mono_proc;
	
	--changes octave when octave button is pressed
	octave_shift : process(pulse)
	begin
		case cur_octave is
			when octave_2 =>
				if pulse = '1' then
					curcur_octave <= octave_3;
				end if;
			when octave_3 =>
				if pulse = '1' then
					curcur_octave <= octave_1;
				end if;
			when octave_1 =>
				if pulse = '1' then
					curcur_octave <= octave_2;
				end if;
			when others =>
			
		end case;
	end process octave_shift;
	
	--sets the cur_octave output to correct octave
	octave_set : process(clk)
	begin
		if (rising_edge(clk)) then
			cur_octave <= curcur_octave;
		end if;
		
	end process octave_set;



end Behavioral;

