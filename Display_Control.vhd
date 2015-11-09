----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:18 08/24/2015 
-- Design Name: 
-- Module Name:    Segment_Display_Control - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Segment_Display_Control is
    Port ( clk : in  STD_LOGIC;
           keyboard_value : in  STD_LOGIC_VECTOR (3 downto 0);
           segment : out  STD_LOGIC_VECTOR (0 downto 6);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0));
end Segment_Display_Control;

architecture Behavioral of Segment_Display_Control is

begin


end Behavioral;

