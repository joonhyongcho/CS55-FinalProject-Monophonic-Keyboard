--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:02:12 08/20/2015
-- Design Name:   
-- Module Name:   O:/ENGS31/CS56-FinalProject/Keyboard_TOP_tb.vhd
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
 
ENTITY Keyboard_TOP_tb IS
END Keyboard_TOP_tb;
 
ARCHITECTURE behavior OF Keyboard_TOP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Keyboard_TOP
    PORT(
         CLK : IN  std_logic;
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
         Button12 : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
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

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Keyboard_TOP PORT MAP (
          CLK => CLK,
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
          Button12 => Button12
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
		button1 <= '1';
		
		wait for 1 ms;
		button1 <= '0';
		
		button2 <= '1';
		wait for 1 ms;
		button2 <= '0';
		wait for 1 ms;
		
		button3 <= '1';
		wait for 1 ms;
		button3 <= '0';
		

      wait;
   end process;

END;
