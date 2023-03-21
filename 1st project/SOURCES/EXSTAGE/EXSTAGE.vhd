----------------------------------------------------------------------------------
-- Company: Technical Univeristy Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    22:32:43 04/06/2021 
-- Design Name: 
-- Module Name:    EXSTAGE - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Execution Stage:
--In this stage the instruction is executed and so the result is calculated by the ALU unit
--the two operands of the ALU unit are coming from the RF, there are the first register and then the second register or the immediate value
entity EXSTAGE is
    Port ( --Inputs
			  RF_A : in  STD_LOGIC_VECTOR (31 downto 0);		--RF[rs]
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);	   --RF[rs] or RF[rd]
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);	--Immediate value
           ALU_Bin_sel : in  STD_LOGIC;						--selection of the ALUs input B ,Immediate or RF_B 
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0); --the function that the ALU will execute
			  --Outputs
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);--ALU result output
           ALU_zero : out  STD_LOGIC;							--if output is zero
			  ALU_Cout: out  STD_LOGIC;							--if there is cout=1
			  ALU_Ovf: out  STD_LOGIC);							--if there is an overflow to the output
end EXSTAGE;

architecture Behavioral of EXSTAGE is

--ALU component, its responsible for taking the operands and the function and calculating the result
component ALU
Port(A : in  STD_LOGIC_VECTOR(31 DOWNTO 0);		
	  B : in  STD_LOGIC_VECTOR(31 DOWNTO 0);		 
	  Op : in  STD_LOGIC_VECTOR(3 DOWNTO 0);     
	  Output : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  Zero : out  STD_LOGIC; 							 
	  Cout : out  STD_LOGIC;							 
	  Ovf : out  STD_LOGIC);
end component;

--mux2x1 component, it is responsible for choosing the second operand of the ALUs input
component mux2x1
Port(muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxSELECT:in STD_LOGIC;
	  muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--integral signal used to help us conect the components
signal muxOUT_top:STD_LOGIC_VECTOR (31 downto 0);

begin

--port mapping of the ALU
--the second operand is conected to the mux output
ALU_portmap:ALU
port map(A=>RF_A,
			B=>muxOUT_top,
			Op=>ALU_func,
			Output=>ALU_out,
			Zero=>ALU_zero,
			Cout=>ALU_Cout,
			Ovf=>ALU_Ovf);

--port mapping of mux2x1
--the two inputws are the RF_B and the immediate value
mux:mux2x1			
port map(muxIN0=>RF_B,
			muxIN1=>Immed,
			muxSELECT=>ALU_Bin_sel,
			muxOUT=>muxOUT_top);


end Behavioral;

