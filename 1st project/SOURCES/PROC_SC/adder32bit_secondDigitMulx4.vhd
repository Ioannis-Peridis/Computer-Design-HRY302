----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:11:06 04/05/2021 
-- Design Name: 
-- Module Name:    adder32bit_secondDigitMulx4 - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- adder that adds two 32 bit numbers  and multiplies the second number given with 4
entity adder32bit_secondDigitMulx4 is
    Port ( --Inputs
			  IN0 : in  STD_LOGIC_VECTOR (31 downto 0);
           IN1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  --Outputs
           Result : out  STD_LOGIC_VECTOR (31 downto 0));
end adder32bit_secondDigitMulx4;

architecture Behavioral of adder32bit_secondDigitMulx4 is

--integral signal to help calculate th eoutput
signal Result_top:STD_LOGIC_VECTOR(31 downto 0);

begin
	-- second input is multiplied by 4 and then added to the firts input
	--multiply by 4 equals two bits logical shift left
	Result_top<=std_logic_vector(IN0+(IN1(29 downto 0) & "00"));
	--Output delay 10 ns
	Result<=Result_top after 10ns;

end Behavioral;

