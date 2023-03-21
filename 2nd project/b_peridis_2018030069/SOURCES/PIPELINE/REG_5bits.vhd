----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:55:16 05/20/2021 
-- Design Name: 
-- Module Name:    REG_5bits - Behavioral 
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

entity REG_5bits is
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 5 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--5 bit output
end REG_5bits;

architecture Behavioral of REG_5bits is

signal out_top:std_logic_vector(4 downto 0);--integral signal that helps to calculate the output

begin
process_register: process(CLK)
	begin
		if rising_edge(CLK) then						  --its a synchronous circuit , that takes input in every rising edge of the clock
			if RST='1'   then out_top<=(others=>'0');-- if reset =1 then output is zero 
			elsif WE='1' then out_top<=Datain;       --else if reset its 0 and write enable 1 the output its the input we write
			else 				   out_top<=out_top;		  --else if write enable=0, output its same than the rising edge before it
			end if;													
		end if;
end process process_register;

Dataout<=out_top after 10ns;--we make a 10ns delay to the output



end Behavioral;

