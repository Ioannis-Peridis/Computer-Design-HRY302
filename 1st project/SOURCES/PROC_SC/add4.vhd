----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:11:06 04/05/2021 
-- Design Name: 
-- Module Name:    add4 - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--adder that increases the input by 4 
entity add4 is
    Port ( Input : in  STD_LOGIC_VECTOR (31 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
end add4;

architecture Behavioral of add4 is

--integral signal to help calculate th eoutput
signal Output_top:std_logic_vector(31 downto 0);

begin

--output=input+4
Output_top<=std_logic_vector(Input+"100");
Output<=Output_top after 10ns;--10 ns delay to the adder

end Behavioral;

