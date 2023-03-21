----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    23:42:59 04/06/2021 
-- Design Name: 
-- Module Name:    MEMSTAGE - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--Memory stage:
--In this stage we access the memeory,either to load or store a word or a byte, particularly the RAM data section 0x400 to 0x800
--This stage is only used when we are executing instructions that need to interact with the RAM memory ,instructions such as lw,sw,lb,sb
entity MEMSTAGE is
    Port ( --Inputs	
			  ByteOp : in  STD_LOGIC;									 --Byte operations, signal tha controls if we are going to load/store byte or word
           Mem_WrEn : in  STD_LOGIC;								 --Memory write enable, signal that allows to write on memory
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);--ALU output from instructions lb/sb/sw/lw from execution stage
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);	 --RF[rd] output for storing to the memory, instructions swap,sb,sw from execution stage
			  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);	 --data that was read from the memory module(RAM)
			  --Outputs
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);--data that wa sloaded from memory, to write into a register,instructions lb,lw
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);	 --address to memory module(RAM)
           MM_WrEn : out  STD_LOGIC;								 --signal that enables writing to memory module(RAM)
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0)); --data for writing to memory module(RAM)
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is

--mux 2x1, it is used to decide if the operation(load or store) is going to be on a byte or a word
component mux2x1
Port(muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  muxSELECT:in STD_LOGIC;
     muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--integral singal used to help to calculate the alu memory address
signal ALU_MEM_Addr_top:STD_LOGIC_VECTOR(31 DOWNTO 0);
--integral signals that help us to cut the word to byte so we cna load or store it
signal storeByte,loadByte:STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

--connect the write enables
MM_WrEn<=MEM_WrEn;

--the address of the ALU is increased by an offset equal to 4096 dec, because we want to interact with the data segment of the memory
--that starts from  address from 1024 to 2047
ALU_MEM_Addr_top<=ALU_MEM_Addr + X"1000";

--the address going to the RAM, will be  cuted when passed to 12 down to 2 bits, because its only 11 bits and not 32 bits like the address of the ALU
MM_Addr<=ALU_MEM_Addr_top;

--to store a byte we take the last 8 bits from the memory data input
storeByte<=std_logic_vector(resize(unsigned(MEM_DataIn(7 downto 0)),32));
--to load a byte we take the last 8 bits from memory module read data
loadByte<=std_logic_vector(resize(unsigned(MM_RdData(7 downto 0)),32));

--With byte operation we select if we are going to store a word(4 bytes=32 bits) or a byte(=8 bits)
--if byteOp=1-> store byte -> MM_WrData=last byte from MEM_DataIn
--else if byteOp=0 store word-> MM_WrData= MEM_DataIn
mux1Store:mux2x1
port map(muxIN0=>MEM_DataIn,
			muxIN1=>storeByte,
			muxSELECT=>ByteOp,
			muxOUT=>MM_WrData);
	
--With byte operation we select if we are going to load a word(4 bytes=32 bits) or a byte(=8 bits)
--if byteOp=1-> load byte->MEM_DataOut=last byte from MM_RdData
--else if byteOp=0 load word->MEM_DataOut= MM_RdData
mux2Load:mux2x1 
port map(muxIN0=>MM_RdData,
			muxIN1=>loadByte,
			muxSELECT=>ByteOp,
			muxOUT=>MEM_DataOut);

end Behavioral;

