----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    23:35:34 03/28/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;-- libraries and packages that were used
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--Arithmetic and Logic Unit, it is responsible to calculate the  different operations (depending on the operation code) between the two operands 
entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR(31 DOWNTO 0);		 --first 32bits number input	
           B : in  STD_LOGIC_VECTOR(31 DOWNTO 0);		 --second 32bits number input
           Op : in  STD_LOGIC_VECTOR(3 DOWNTO 0);      --operation code
           Output : out  STD_LOGIC_VECTOR(31 DOWNTO 0);--output after the operation
           Zero : out  STD_LOGIC; 							 --signal activated when output=zero
           Cout : out  STD_LOGIC;							 --signal activatd when there is a carry out in the output
           Ovf : out  STD_LOGIC);							 --signal if the operation's output overflows
end ALU;

architecture Behavioral of ALU is

signal Cout_top:STD_LOGIC_VECTOR(32 DOWNTO 0);				--integral 33 bits signal to be used to calculate the carry out
signal Output_top,ZEROnum:STD_LOGIC_VECTOR(31 DOWNTO 0); --integral 32 bits signals , used to store the output and the numer zero 

begin
	ZEROnum<=B"0000_0000_0000_0000_0000_0000_0000_0000"; 	--initialization to zero
	
	--these are the different outputs that occure for every different operation code
	with Op select	
		Output_top<=
		std_logic_vector(A + B) when "0000",--addision of the two 32bit input  vectors
		std_logic_vector(A - B) when "0001",--substraction of the two 32bit input vectors
		A AND B                 when "0010",--logical gates 
		A OR B                  when "0011",
		NOT A                   when "0100",
		A NAND B		    	      when "0101",
		A NOR B                 when "0110",
		--different kind of shifts of input A
	   A(31) & A(31 DOWNTO 1)  when "1000",--arithmetic shift right
		'0' & A(31 DOWNTO 1)    when "1001",--logical shift right																			        
		A(30 DOWNTO 0) & '0'    when "1010",--logical shift left
		A(30 DOWNTO 0) & A(31)  when "1100",--cycle rotation left
		A(0) & A(31 DOWNTO 1)   when "1101",--cycle rotation right
		--in case the operation code inpute is invalid
		ZEROnum			         when others;
	
	--this how the different carry out occures in addision or substraction(the value of the carry out is stored in the first bit(that we added extra)	
	with Op select
		Cout_top<=
		std_logic_vector(('0'& A) + ('0'& B))  when "0000",
		std_logic_vector(('0'& A) - ('0'& B))  when "0001",
		--in case there is no add or sub the carry out is zero
		'0'& ZEROnum                           when others;
		
		-- in every out signal we make a delay 10ns 
		--zero=1 if the ouput is zero or else its 0
		Zero<='1' after 10ns when (Output_top=ZEROnum) else '0' after 10ns;
		--cout=1 if first bit is 1 or else its 0		
		Cout<='1' after 10ns when (Cout_top(32)='1')   else '0' after 10ns;									   
		--different cases that we have overflow in addision and substraction
		--addition ovf: when A>0,B>0 and A+B<0 OR when A<0,B<0 and A+B>0
		--subtraction ovf: when A>0,B<0 and A-B<0 OR when A<0,B>0 and A-B>0
		Ovf <='1' after 10ns when ((A(31)='0' AND B(31)='0' AND Op="0000" AND (Output_top(31)='1' )) OR
										  (A(31)='1' AND B(31)='1'  AND Op="0000" AND (Output_top(31)='0' )) OR
										  (A(31)='0' AND B(31)='1'  AND Op="0001" AND (Output_top(31)='1' )) OR
										  (A(31)='1' AND B(31)='0'  AND Op="0001" AND (Output_top(31)='0' )))else '0' after 10ns;
										  
		Output<=Output_top after 10ns;--output occures after 10ns
		
end Behavioral;

