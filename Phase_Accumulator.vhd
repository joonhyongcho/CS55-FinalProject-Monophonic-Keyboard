----------------------------------------------------------------------------------
-- Company: Dartmouth College
-- Engineer: Audyn Curless, Joon Cho
-- 
-- Create Date:    09:34:20 08/24/2015 
-- Design Name: 
-- Module Name:    Phase_Accumulator - Behavioral 
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

entity Phase_Accumulator is
    Port ( clk : in std_logic;
				Skip_increment : in  STD_LOGIC_VECTOR (10 downto 0); -- current skip increment
			  reset_sineCounter : in std_LOGIC; -- mute on or off
			  enable_sinecounter : in std_logic; -- enable from controller
           LUT_Address : out  STD_LOGIC_VECTOR (14 downto 0)); -- lut address output that goes to sine LUT
end Phase_Accumulator;

architecture Behavioral of Phase_Accumulator is

	-- internal sine count signals
	signal Sine_count : unsigned(14 downto 0) := (others => '0');
	signal skip_int : unsigned(10 downto 0) := (others => '0');

begin

	-- counter that takes skip_increment and based on when the enable signal is high produces an LUT address.
	SineCounter : process (clk, reset_SineCounter, enable_SineCounter) 
	begin
		skip_int <= unsigned(skip_increment);
		if (rising_edge(clk)) then
			if (reset_SineCounter = '1') then
				Sine_count <= (others => '0');
			elsif (enable_SineCounter = '1') then
				if (sine_count+skip_int)>32767 then
					Sine_Count <= Sine_count + skip_int - 32767;
				else
					Sine_Count <= Sine_count + skip_int;
				end if;
			end if;
		end if;

		LUT_Address <= std_logic_vector(sine_count);
		
	end process SineCounter;

end Behavioral;

