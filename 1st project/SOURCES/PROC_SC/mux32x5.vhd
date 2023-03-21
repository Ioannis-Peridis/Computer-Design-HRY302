----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    23:35:34 03/28/2021 
-- Design Name: 
-- Module Name:    mux32x5 - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;-- libraries and packages that were used
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--MULTIPLEXER that has 32 inputs ,that every one of them is a 32bit vector
--coming out from every register output
entity mux32x5 is													
    Port ( muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN2 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN3 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN4 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN5 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN6 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN7 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN8 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN9 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN10 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN11 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN12 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN13 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN14 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN15 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN16 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN17 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN18 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN19 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN20 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN21 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN22 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN23 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN24 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN25 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN26 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN27 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN28 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN29 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN30 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           muxIN31 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  --5 bit signal address that will select one of the inputs , as the output of the mux
           muxSELECT : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
			  -- multiplexer output
           muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end mux32x5;

architecture Behavioral of mux32x5 is

signal muxOUT_top:STD_LOGIC_VECTOR(31 DOWNTO 0);--integral 32 bits signal to be used to calculate the output

begin

   --these are the 32 different outputs that occure for every different select address 
	with(muxSELECT)select
		muxOUT_top<= 
			muxIN0  when "00000",
			muxIN1  when "00001",
			muxIN2  when "00010",
			muxIN3  when "00011",
			muxIN4  when "00100",
			muxIN5  when "00101",
			muxIN6  when "00110",
			muxIN7  when "00111",
			muxIN8  when "01000",
			muxIN9  when "01001",
			muxIN10 when "01010",
			muxIN11 when "01011",
			muxIN12 when "01100",
			muxIN13 when "01101",
			muxIN14 when "01110",
			muxIN15 when "01111",
			muxIN16 when "10000",
			muxIN17 when "10001",
			muxIN18 when "10010",
			muxIN19 when "10011",
			muxIN20 when "10100",
			muxIN21 when "10101",
			muxIN22 when "10110",
			muxIN23 when "10111",
			muxIN24 when "11000",
			muxIN25 when "11001",
			muxIN26 when "11010",
			muxIN27 when "11011",
			muxIN28 when "11100",
			muxIN29 when "11101",
			muxIN30 when "11110",
			muxIN31 when "11111";

	muxOUT<=muxOUT_top after 10ns;--we make a 10ns delay for the output
end Behavioral;

