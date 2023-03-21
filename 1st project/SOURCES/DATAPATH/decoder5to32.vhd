----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    13:10:41 04/01/2021 
-- Design Name: 
-- Module Name:    decoder5to32 - Behavioral 
-- Project Name: organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;-- libraries and packages that were used
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--decoder that turns a 5 bit intput into a 32 bit output
--that has only one bit equal to '1' and all the others '0'for each different output
entity decoder5to32 is												
    Port ( decoderIN : in  STD_LOGIC_VECTOR( 4 DOWNTO 0);
           decoderOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end decoder5to32;

architecture Behavioral of decoder5to32 is

signal decoderOUT_top:STD_LOGIC_VECTOR(31 DOWNTO 0);--integral 32 bits signal to be used to calculate the output

begin

	-- these are the 32 different outputs that occure for every different input number
	--in each one there is only 1 bit equal to '1'
	with (decoderIN) select
		decoderOUT_top<= 	  
						B"0000_0000_0000_0000_0000_0000_0000_0001" when "00000",
						B"0000_0000_0000_0000_0000_0000_0000_0010" when "00001",
						B"0000_0000_0000_0000_0000_0000_0000_0100" when "00010",
						B"0000_0000_0000_0000_0000_0000_0000_1000" when "00011",
						B"0000_0000_0000_0000_0000_0000_0001_0000" when "00100",
						B"0000_0000_0000_0000_0000_0000_0010_0000" when "00101",
						B"0000_0000_0000_0000_0000_0000_0100_0000" when "00110",
						B"0000_0000_0000_0000_0000_0000_1000_0000" when "00111",
						B"0000_0000_0000_0000_0000_0001_0000_0000" when "01000",
						B"0000_0000_0000_0000_0000_0010_0000_0000" when "01001",
						B"0000_0000_0000_0000_0000_0100_0000_0000" when "01010",
						B"0000_0000_0000_0000_0000_1000_0000_0000" when "01011",
						B"0000_0000_0000_0000_0001_0000_0000_0000" when "01100",
						B"0000_0000_0000_0000_0010_0000_0000_0000" when "01101",
						B"0000_0000_0000_0000_0100_0000_0000_0000" when "01110",
						B"0000_0000_0000_0000_1000_0000_0000_0000" when "01111",
						B"0000_0000_0000_0001_0000_0000_0000_0000" when "10000",
						B"0000_0000_0000_0010_0000_0000_0000_0000" when "10001",
						B"0000_0000_0000_0100_0000_0000_0000_0000" when "10010",
						B"0000_0000_0000_1000_0000_0000_0000_0000" when "10011",
						B"0000_0000_0001_0000_0000_0000_0000_0000" when "10100",
						B"0000_0000_0010_0000_0000_0000_0000_0000" when "10101",
						B"0000_0000_0100_0000_0000_0000_0000_0000" when "10110",
						B"0000_0000_1000_0000_0000_0000_0000_0000" when "10111",
						B"0000_0001_0000_0000_0000_0000_0000_0000" when "11000",
						B"0000_0010_0000_0000_0000_0000_0000_0000" when "11001",
						B"0000_0100_0000_0000_0000_0000_0000_0000" when "11010",
						B"0000_1000_0000_0000_0000_0000_0000_0000" when "11011",
						B"0001_0000_0000_0000_0000_0000_0000_0000" when "11100",
						B"0010_0000_0000_0000_0000_0000_0000_0000" when "11101",
						B"0100_0000_0000_0000_0000_0000_0000_0000" when "11110",
						B"1000_0000_0000_0000_0000_0000_0000_0000" when "11111";

decoderOUT<=decoderOUT_top after 10ns;--we make a 10ns delay for the output						 
end Behavioral;

