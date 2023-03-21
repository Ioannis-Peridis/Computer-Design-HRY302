----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    21:31:49 04/06/2021 
-- Design Name: 
-- Module Name:    converter - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--converter that converts a 16 bit input in a 32 bit output depending on the select, there are 4 different cases
entity converter is
    Port ( --inputs
			  Input : in  STD_LOGIC_VECTOR (15 downto 0);
			  Selection:in STD_LOGIC_VECTOR(1 downto 0);
			  --outputs
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
end converter;

architecture Behavioral of converter is

--internal signal to help calculate the output
signal Output_top:std_logic_vector(31 downto 0);

begin

--selection of the output
with Selection select
	Output_top<= --zero fill the input until there are 32 bits
					 std_logic_vector(resize(unsigned(Input),32)) when "00" ,
					 --sign extend the input until there are 32 bits
					 std_logic_vector(resize(signed(Input),32)) when "01",
					 --zero fill the input and thne logical shift by 16 bits left 
					 std_logic_vector (Input & B"0000_0000_0000_0000")	when "10",
					 --sign extend the input and then logical shift by 2 bits left  
					 std_logic_vector	((resize(signed(Input),30)) & "00")when "11";
					 
	--output has a 10 ns delay
	Output<=Output_top after 10ns;
	
end Behavioral;

