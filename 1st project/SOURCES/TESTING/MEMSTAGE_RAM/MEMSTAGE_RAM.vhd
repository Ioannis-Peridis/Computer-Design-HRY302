----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    15:29:10 04/07/2021 
-- Design Name: 
-- Module Name:    MEMSTAGE_RAM - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Memory Stage actually conected to the RAM memory in a top module
--It is the same thing but now we can load and store values from the RAM memory
entity MEMSTAGE_RAM is
    Port ( --Inputs
			  CLK : in  STD_LOGIC;
			  ByteOp : in  STD_LOGIC;
           MEM_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
			  --Output
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE_RAM;

architecture Behavioral of MEMSTAGE_RAM is

--component of the memory stage
component MEMSTAGE
Port(ByteOp : in  STD_LOGIC;
	  Mem_WrEn : in  STD_LOGIC;
	  ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
	  MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
	  MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
	  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
	  MM_WrEn : out  STD_LOGIC;
	  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
	  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end component;

--Ram memory component
component RAM
Port(clk : in std_logic;
	  inst_addr : in std_logic_vector(10 downto 0);
	  inst_dout : out std_logic_vector(31 downto 0);
	  data_we : in std_logic;
	  data_addr : in std_logic_vector(10 downto 0);
	  data_din : in std_logic_vector(31 downto 0);
	  data_dout : out std_logic_vector(31 downto 0));
end component;

--integral signals used to help us make the conections between the two modules
signal data_din_top,data_dout_top:std_logic_vector(31 downto 0);
signal data_we_top:std_logic;
signal data_addr_top:std_logic_vector(31 downto 0);

begin

--port mapping memory stage
--we pass the inputs to the RAM , after ofcourse we have made the nccessary conversions at the MEM stage
memory_stage:MEMSTAGE
port map(ByteOp=>ByteOp,
			Mem_WrEn=>Mem_WrEn,
			ALU_MEM_Addr=>ALU_MEM_Addr,
			MEM_DataIn=>MEM_DataIn,
			MEM_DataOut=>MEM_DataOut,
			MM_Addr=>data_addr_top,
			MM_WrEn=>data_we_top,
			MM_WrData=>data_din_top,
			MM_RdData=>data_dout_top);

--port mapping RAM memory
--here we are interacting only with the data segment of the RAM memory , so we intialize the instruction section inputs to zero and outputs to open
--we pass the output to the MEM stage
--the address going to the RAM, will be  cuted when passed to 12 down to 2 bits, because its only 11 bits and not 32 bits like the address of the ALU
ram_memory:RAM
port map(clk=>CLK,
			inst_addr=>"00000000000",
			inst_dout=>open,
			data_we=>data_we_top,
			data_addr=>data_addr_top(10 downto 0),
			data_din=>data_din_top,
			data_dout=>data_dout_top);

end Behavioral;

