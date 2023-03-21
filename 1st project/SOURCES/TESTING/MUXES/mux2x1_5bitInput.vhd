----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    21:31:49 04/06/2021 
-- Design Name: 
-- Module Name:    mux2x1_5bitInput - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--multiplexer 2x1 with 5 bit inputs
entity mux2x1_5bitInput is
    Port ( --inputs
			  mux_IN0 : in  STD_LOGIC_VECTOR (4 downto 0);
           mux_IN1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_SELECT : in  STD_LOGIC;
			  --output
           mux_OUT : out  STD_LOGIC_VECTOR (4 downto 0));
end mux2x1_5bitInput;

architecture Behavioral of mux2x1_5bitInput is

--intergal signal to help calculate the output
signal mux_OUT_top:STD_LOGIC_VECTOR(4 DOWNTO 0);

begin
	 
	 --selection of the input that are going to pass to the output
	 with(mux_SELECT)select
		mux_OUT_top<= mux_IN0 when '0',
			          mux_IN1 when '1';
	
--output has a 10 ns delay	
	mux_OUT<=mux_OUT_top after 10ns;

end Behavioral;

