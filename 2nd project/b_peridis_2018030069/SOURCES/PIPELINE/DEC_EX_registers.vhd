----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:10:49 05/20/2021 
-- Design Name: 
-- Module Name:    DEC_EX_registers - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--DATAPATH dec_ex registers 
entity DEC_EX_registers is
    Port ( RF_A_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           Instr_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_A_out : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_out : out  STD_LOGIC_VECTOR (31 downto 0);
           Immed_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
           Instr_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end DEC_EX_registers;

architecture Behavioral of DEC_EX_registers is
--reg 32 bits
component REG 
Port ( CLK : in  STD_LOGIC;
       RST : in  STD_LOGIC;
       Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
       WE : in  STD_LOGIC;
       Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;
--reg 5 bits
component REG_5bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 5 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--5 bit output
end component;

begin
--the can always write
instruction_address_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>Instr_addr_in,
			WE=>'1',
			Dataout=>Instr_addr_out);

instruction_write_address_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>WriteAddr_in,
			WE=>'1',
			Dataout=>WriteAddr_out);

RF_A_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>RF_A_in,
			WE=>'1',
			Dataout=>RF_A_out);

RF_B_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>RF_B_in,
			WE=>'1',
			Dataout=>RF_B_out);

Immed_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>Immed_in,
			WE=>'1',
			Dataout=>Immed_out);


end Behavioral;

