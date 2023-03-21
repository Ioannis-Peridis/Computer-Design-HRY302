----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    13:13:57 04/06/2021 
-- Design Name: 
-- Module Name:    IFSTAGE_RAM - Behavioral 
-- Project Name: Organosi ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Instruction Fetch Stage actually conected to the RAM memory in a top module
--Its the same with the ifstage , but now there is the difference that we actually load the instructions from a real memory , not the test bench
--Also, the PC out now is conected to the address input of the memory
entity IFSTAGE_RAM is
    Port ( --Inputs
			  PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  --Outputs
           Instr : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE_RAM;

architecture Behavioral of IFSTAGE_RAM is

--instruction fetch stage component 
component IFSTAGE
Port(PC_Immed : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
     PC_sel : in  STD_LOGIC;
     PC_LdEn : in  STD_LOGIC;
     Reset : in  STD_LOGIC;
     Clk : in  STD_LOGIC;
     PC : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
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

-- integral signal to help us caclculate the output
signal PC_top:std_logic_vector(31 downto 0);

begin

--port mapping of the if stage
if_stage:IFSTAGE
port map(PC_Immed=>PC_Immed ,
			PC_sel=> PC_sel  ,
			PC_LdEn=>PC_LdEn ,
			Reset=>Reset ,
			Clk=>Clk,
			PC=>PC_top);

--port mapping of the Ram
-- input address is 11 bits so we take 12 downto 2 from the 32 bits PC output
--we care only for the instruction text segmnet and not the data segment of th ememory , so we intialize the data inputs and outputs to zero and open 
ram_memory:RAM
port map(clk=>Clk,
			inst_addr=>PC_top(12 downto 2),
			inst_dout=>Instr,
			data_we=>'0',
			data_addr=>"00000000000",
			data_din=>X"00000000",
			data_dout=>open);

end Behavioral;

