--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:54:47 08/20/2015
-- Design Name:   
-- Module Name:   O:/ENGS31/CS56-FinalProject/Keyboard_to_LUT_tb.vhd
-- Project Name:  CS56-FinalProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Keyboard_to_LUT
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
 
ENTITY Keyboard_to_LUT_tb IS
END Keyboard_to_LUT_tb;
 
ARCHITECTURE behavior OF Keyboard_to_LUT_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Keyboard_to_LUT
    PORT(
         clk : IN  std_logic;
         Button : IN  std_logic_vector(3 downto 0);
         Enable_SineCounter : IN  std_logic;
         LUT_Address : OUT  std_logic_vector(14 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Button : std_logic_vector(3 downto 0) := (others => '0');
   signal Enable_SineCounter : std_logic := '0';

 	--Outputs
   signal LUT_Address : std_logic_vector(14 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Keyboard_to_LUT PORT MAP (
          clk => clk,
          Button => Button,
          Enable_SineCounter => Enable_SineCounter,
          LUT_Address => LUT_Address
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      button <= "0000";
		enable_sinecounter <= '1';
		wait for clk_period * 3;
		button <= "0001";

      wait;
   end process;

END;
