----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:21:03 12/10/2014 
-- Design Name: 
-- Module Name:    conv_7seg - Behavioral 
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

entity conv_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
end conv_7seg;

    architecture Behavioral of conv_7seg is
signal display_aux: STD_LOGIC_VECTOR (6 downto 0);
begin

with x select
	display_aux<= "0111000" when "0000", -- l
	      	"0111111" when "0001", -- o
	      	"1101101" when "0010", -- s
	      	"1111001" when "0011", -- e
	      	"1111101" when "0100", -- g
	      	"1110111" when "0101", -- a 
	      	"1010100" when "0110", -- n 
	      	"1110011" when "0111", -- p
	      	"0001110" when "1000", -- j
	      	"0111110" when "1001", -- u
	      	"0011100" when "1010", -- v
	      	"0111001" when "1011", -- c
	      	"1100011" when "1100", -- o arriba
	      	"1011100" when "1101", -- o abajo
	      	"1000000" when others;
display <= not display_aux;

end Behavioral;

