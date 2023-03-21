----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    15:08:32 04/06/2021 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Instruction Decode Stage:
--In this stage we decode the isntruction that we take from memory instruction/text segment
--By reading the instruciton:
--1)We indicate witch registers data will be read and used as the first and second operand in the ALU
--2)We indicate which register will have the results of the operation written to when calculated
--3)We send to the programm counter and to the ALU the converted immediate 32 bit number
entity DECSTAGE is
    Port ( --Inputs
			  Instr : in  STD_LOGIC_VECTOR (31 downto 0);  --Instruction that is going to be decoded
           RF_WrEn : in  STD_LOGIC;							  --Write enable of the register file
			  Reset: in  STD_LOGIC;								  --Reset signal of the RF
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);--data to be written to the register coming from the ALU
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);--data data to be written to the register coming from the MEM
           RF_WrData_sel : in  STD_LOGIC;					  --selection that determines the data origin coming from the ALU or the MEM
           RF_B_sel : in  STD_LOGIC;						  --selection that determines the second read register
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);  --zero fill, sign extension, shifting
           Clk : in  STD_LOGIC;								  --clock
			  --Outputs
           Immed : out  STD_LOGIC_VECTOR (31 downto 0); --immediate value for the next stage
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);  --value of the first register
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0)); --value of the second register
end DECSTAGE;

architecture Behavioral of DECSTAGE is

--register file component
--used to read two of the registers data and send the output to the ALU operands
--also used to write on it the ALU result
component RF
Port(Adr1 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
	  Adr2 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
	  Awr : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	
	  Din : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  WrEn : in  STD_LOGIC;							
	  RST : in  STD_LOGIC; 							
	  CLK : in  STD_LOGIC;							
	  Dout1 : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  Dout2 : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--multiplexers 2x1 with 32 bit inputs, selection that determines the data origin coming from the ALU or the MEM
component mux2x1
Port(muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
     muxSELECT:in STD_LOGIC;
     muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--multiplexer 2x1 with 5 bit inputs, selection that determines the second read register
component mux2x1_5bitInput
Port(mux_IN0 : in  STD_LOGIC_VECTOR (4 downto 0);
     mux_IN1 : in  STD_LOGIC_VECTOR (4 downto 0);
     mux_OUT : out  STD_LOGIC_VECTOR (4 downto 0);
     mux_SELECT : in  STD_LOGIC);
end component;

--converter that gets as input the 16 lower bits of the instruction and as output it convertes the input into a 32 bit immediate
component converter
Port(Input : in  STD_LOGIC_VECTOR (15 downto 0);
     Output : out  STD_LOGIC_VECTOR (31 downto 0);
	  Selection:in STD_LOGIC_VECTOR(1 downto 0));
end component;

--integral signals used to help to conect the  multiplxers outs to the RF
signal muxOUT_din:STD_LOGIC_VECTOR (31 downto 0);
signal muxOUT_adr2:STD_LOGIC_VECTOR (4 downto 0);

begin

--port mapping of the register file
--the first read register is connected to the 25 downto 21, 5 bits of the instruction
--the second read register is conected to the mux output , that decides witch bits of the instruction are going to be loaded
--the write register is always the 20 down to 16 bits of the instruction
RegisterFile:RF
port map(Adr1=>Instr(25 downto 21),
			Adr2=>muxOUT_adr2,
			Din=>muxOUT_din,
			Awr=>Instr(20 downto 16),
			WrEn=>RF_WrEn,
			RST=>Reset,
			CLK=>Clk,
			Dout1=>RF_A,
			Dout2=>RF_B);

--port mapping of the multiplxer that desides where the data is coming from
-- inputs are the ALU and MEM data
--the output is the RF , write data input
mux_din:mux2x1
port map(muxIN0=>ALU_out,
			muxIN1=>MEM_out,
			muxSELECT=>RF_WrData_sel,
			muxOUT=>muxOUT_din);

--converter that converts the lats 16 bits of the instruction to the immediate signal		
convert_instr:converter
port map(Input=>Instr(15 downto 0),
			Output=>Immed,
			Selection=>ImmExt);

--multiplexer that desides which is going ot be the second read register
--inputs are the instruction bits 15 downto 11 or 20 downto 16
mux_adr2:mux2x1_5bitInput
port map(mux_IN0=>Instr(15 downto 11),
			mux_IN1=>Instr(20 downto 16),
			mux_OUT=>muxOUT_adr2,
			mux_SELECT=>RF_B_sel);

end Behavioral;

