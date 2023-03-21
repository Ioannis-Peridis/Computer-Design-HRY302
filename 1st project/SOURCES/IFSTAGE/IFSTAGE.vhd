----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    17:46:48 04/05/2021 
-- Design Name: 
-- Module Name:    IFSTAGE - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Instruction Fetch Stage:
-- In this stage we load(read) an instruction from the memory , particularly from the RAM text section 0x000 to 0x400
-- to the register called Programm Counter, that it contains the address of the instruction being executed at the current time.(Every instruction must be fetched first to be executed later)
-- This address is also used to caculate the address of the next instruction(depending on the instructions form) loaded in the Programm Counter
entity IFSTAGE is
    Port ( --Inputs
			  PC_Immed : in  STD_LOGIC_VECTOR(31 DOWNTO 0);--immediate value, used for instructions b,beq,bne
           PC_sel : in  STD_LOGIC;							  --selection of updating the PC
           PC_LdEn : in  STD_LOGIC;							  --PC write enable 
           Reset : in  STD_LOGIC;							  --Reset signal of the register PC
           Clk : in  STD_LOGIC;								  --clock
			  --Output
           PC : out  STD_LOGIC_VECTOR(31 DOWNTO 0));	  --Programm Counter output
end IFSTAGE;


architecture Behavioral of IFSTAGE is

--its an 32 bit operands adder , that multiplies the second digit of the addition with demical 4
--it is used to caclculate the input of the PC, when the instructions format type contains Immediate values
component adder32bit_secondDigitMulx4
Port(IN0 : in  STD_LOGIC_VECTOR (31 downto 0);
     IN1 : in  STD_LOGIC_VECTOR (31 downto 0);
     Result : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--multiplexer 2x1 that is used for deciding witch will be the new address tha the PC will contain( immediate*4+PC+4 OR PC+4)
--selecting by the pc_sel input
component mux2x1
Port(muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxSELECT:in STD_LOGIC;
     muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--Programm Counter Register, it is used to contain the address of the instruction that is getting executed at the moment
component REG
Port(CLK : in  STD_LOGIC;									
     RST : in  STD_LOGIC;									
     Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);	
     WE : in  STD_LOGIC;									
     Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--this is an adder that adds demical 4 to the given Input, it is used for increase the PC+4 , in every different cycle,
--that we move on to the next instruction
component add4
Port(Input : in  STD_LOGIC_VECTOR (31 downto 0);
     Output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--internal signals used to help calculate some components outputs
signal adder_top,add4_top,muxOUT_top,PCout_top:STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

--port mapping of the adder thta multiplies the second operand with 4
--first input its the PC+4, second input its PC_Immediate
adder:adder32bit_secondDigitMulx4
port map(IN0=>add4_top,
			IN1=>PC_Immed,
			Result=>adder_top);
			
--	port mapping of the multiplexer
--the two inputs are PC+4 and  immediate*4+PC+4, the output is going to the PC as input 	
mux:mux2x1
port map(muxIN0=>add4_top,
			muxIN1=>adder_top,
			muxSELECT=>PC_sel,
			muxOUT=>muxOUT_top);

--port mapping programm counter
--input comes from the multiplexers output, output is send back to adder to be increased by 4
ProgramCounter:REG
port map(CLK=>Clk,
			RST=>Reset,
			Datain=>muxOUT_top,
			WE=>PC_LdEn,
			Dataout=>PCout_top);

--port mapping adder that increases the second digit by 4
--input its PC , output its PC+4			
add4toPC:add4
port map(Input=>PCout_top,
			Output=>add4_top);
			
--if programm counter overpassed the address of the instruction segment 1024 then set PC output to 0
--and we are no longer able to fetch any instrucitons	  
PC<=PCout_top when (PCout_top<X"00000404") else
	 X"00000000";

end Behavioral;

