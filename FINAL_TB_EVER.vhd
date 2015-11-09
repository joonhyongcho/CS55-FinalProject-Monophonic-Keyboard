--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:56:35 08/26/2015
-- Design Name:   
-- Module Name:   O:/engs31/CS56-FinalProject/FINAL_TB_EVER.vhd
-- Project Name:  CS56-FinalProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Keyboard_TOP
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FINAL_TB_EVER IS
END FINAL_TB_EVER;
 
ARCHITECTURE behavior OF FINAL_TB_EVER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Keyboard_TOP
    PORT(
         CLK : IN  std_logic;
         Button_octave : IN  std_logic;
         Button1 : IN  std_logic;
         Button2 : IN  std_logic;
         Button3 : IN  std_logic;
         Button4 : IN  std_logic;
         Button5 : IN  std_logic;
         Button6 : IN  std_logic;
         Button7 : IN  std_logic;
         Button8 : IN  std_logic;
         Button9 : IN  std_logic;
         Button10 : IN  std_logic;
         Button11 : IN  std_logic;
         Button12 : IN  std_logic;
         onoff : IN  std_logic;
         ain : OUT  std_logic;
         gain : OUT  std_logic;
         shutdown : OUT  std_logic;
         segments : OUT  std_logic_vector(0 to 6);
         anodes : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Button_octave : std_logic := '0';
   signal Button1 : std_logic := '0';
   signal Button2 : std_logic := '0';
   signal Button3 : std_logic := '0';
   signal Button4 : std_logic := '0';
   signal Button5 : std_logic := '0';
   signal Button6 : std_logic := '0';
   signal Button7 : std_logic := '0';
   signal Button8 : std_logic := '0';
   signal Button9 : std_logic := '0';
   signal Button10 : std_logic := '0';
   signal Button11 : std_logic := '0';
   signal Button12 : std_logic := '0';
   signal onoff : std_logic := '0';

 	--Outputs
   signal ain : std_logic;
   signal gain : std_logic;
   signal shutdown : std_logic;
   signal segments : std_logic_vector(0 to 6);
   signal anodes : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Keyboard_TOP PORT MAP (
          CLK => CLK,
          Button_octave => Button_octave,
          Button1 => Button1,
          Button2 => Button2,
          Button3 => Button3,
          Button4 => Button4,
          Button5 => Button5,
          Button6 => Button6,
          Button7 => Button7,
          Button8 => Button8,
          Button9 => Button9,
          Button10 => Button10,
          Button11 => Button11,
          Button12 => Button12,
          onoff => onoff,
          ain => ain,
          gain => gain,
          shutdown => shutdown,
          segments => segments,
          anodes => anodes
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		onoff <= '1';
		
		wait for 10 us;
		
		button1 <= '1';
		
		wait for 500 us;
		
		button1 <= '0';
		
		wait for 200 us;
		
		button2 <= '1';
		
		wait for 500 us;
		
		button_octave <= '1';
		
		wait for 300 us;
		
		button_octave <= '0';
		
		wait for 500 us;
		
		button2 <= '0';
		
		wait for 200 us;
		
		button10 <= '1';
		
		wait for 300 us;
		
		button6 <= '1';
		
		wait for 500 us;
		
		button10 <= '0';
		
		wait for 300 us;
		
		button_octave <= '1';
		
		wait for 300 us;
		
		button_octave <= '0';
		
		wait for 400 us;
		
		button_octave <= '1';
		
		wait for 300 us;
		
		button_octave <= '0';
		
		wait for 300 us;
		
		button6 <= '0';

      wait;
   end process;

END;
