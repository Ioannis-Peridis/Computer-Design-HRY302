----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:10:49 05/20/2021 
-- Design Name: 
-- Module Name:    EX_MEM_registers - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--ex_mem registers
entity EX_MEM_registers is
    Port ( Branch_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero_in : in  STD_LOGIC;
           ALU_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           Branch_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero_out : out  STD_LOGIC;
           ALU_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
			  CLK : in STD_LOGIC;
			  Reset : in STD_LOGIC);
end EX_MEM_registers;

architecture Behavioral of EX_MEM_registers is

component REG 
Port ( CLK : in  STD_LOGIC;
       RST : in  STD_LOGIC;
       Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
       WE : in  STD_LOGIC;
       Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;
--5 bit registers
component REG_5bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 5 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--5 bit output
end component;

--1 bit register 
component REG_1bit 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC;							--input 1 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
       Dataout : out  STD_LOGIC);						--1 bit output
end component;

begin
-- they can always write 
branch_address_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>Branch_addr_in,
			WE=>'1',
			Dataout=>Branch_addr_out);
			
ALU_zero_register:REG_1bit
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>ALU_zero_in,
			WE=>'1',
			Dataout=>ALU_zero_out);
			
ALU_out_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>ALU_out_in,
			WE=>'1',
			Dataout=>ALU_out_out);

RF_B_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>RF_B_in,
			WE=>'1',
			Dataout=>RF_B_out);

instruction_write_address_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>WriteAddr_in,
			WE=>'1',
			Dataout=>WriteAddr_out);
			



end Behavioral;

