----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:01:47 04/05/2021 
-- Design Name: 
-- Module Name:    mux2x1 - Behavioral 
-- Project Name: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--multiplexer 2x1 
entity mux2x1 is
    Port ( --inputs
			  muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  muxSELECT:in STD_LOGIC;
			  --output
           muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end mux2x1;

architecture Behavioral of mux2x1 is

--integral signal to help calculate the output
signal muxOUT_top:STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
	 --with select choose the output
	 with(muxSELECT)select
		muxOUT_top<= muxIN0 when '0',
			          muxIN1 when '1';
	
	--output has 10 seconds delay
	muxOUT<=muxOUT_top after 10ns;

end Behavioral;

