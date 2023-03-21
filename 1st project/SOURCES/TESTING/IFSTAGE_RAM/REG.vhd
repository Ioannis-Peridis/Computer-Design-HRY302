----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    13:10:41 04/01/2021 
-- Design Name: 
-- Module Name:    REG - Behavioral 
-- Project Name: organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;-- libraries and packages that were used
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--32 bit register with reset and write enable signals
entity REG is
    Port ( CLK : in  STD_LOGIC;									--clock
           RST : in  STD_LOGIC;									-- reset signal, if it is activated to '1' then the output becomes zero
           Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);	--input 32 bits
           WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
           Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));--32 bit output
end REG;

architecture Behavioral of REG is

signal out_top:std_logic_vector(31 downto 0);--integral signal that helps to calculate the output

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

