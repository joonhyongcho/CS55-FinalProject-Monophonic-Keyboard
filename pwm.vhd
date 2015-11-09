----------------------------------------------------------------------------------
-- Company: Dartmouth College
-- Engineer: Audyn Curless, Joon Cho
-- 
-- Create Date:    15:46:40 08/25/2015 
-- Design Name: 
-- Module Name:    pwm - Behavioral 
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
USE ieee.std_logic_unsigned.all;

entity pwm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC; -- asynchronous reset 
           enable : in  STD_LOGIC; -- enable intake of new signal
			  sine_lut : in STD_LOGIC_VECTOR(11 downto 0); -- input signal
           ain : out  STD_LOGIC; -- signal to amp that becomes audio
           gain : out  STD_LOGIC; -- loudness of signal
           shutdown : out  STD_LOGIC); -- mute on/off signal
end pwm;

architecture Behavioral of pwm is

	-- constants for calculation
	constant system_clk : integer := 10000000;
	constant pwm_freq : integer := 24000;
	constant resolution : integer := 12;
	constant num_phases : integer := 1;
	constant period : integer := system_clk/pwm_freq;
	
	-- internal calculation signals
	signal pwm_out : std_logic;
   signal count : integer range 0 to period - 1 := 0;
   signal hdn : integer range 0 to period/2 := 0;
   signal hd : integer range 0 to period/2 := 0;
	
begin

	pwm_proc : process(clk)
	begin
	
		-- check if asynch reset is enabled
		if (reset = '0') then
			count <= 0;
			pwm_out <= '0';
		elsif rising_edge(clk) then
		
			-- get new input signal
			if (enable = '1') then
				hdn <= conv_integer(sine_lut)*period/(2**resolution)/2;
			end if;
			
			-- check to see if counter = period, and conditionally reset/update count
			if (count = period - 1) then
				count <= 0;
				hd <= hdn;
			else
				count <= count + 1;
			end if;
			
			-- set ain output based on length of hd
			if (count = hd) then
				pwm_out <= '0';
			elsif (count = period - hd) then
				pwm_out <= '1';
			end if;
		end if;
		
		-- assign outputs
		ain <= std_logic(pwm_out);
		gain <= '1';
		shutdown <= '1';
	
	end process pwm_proc;

end Behavioral;

















