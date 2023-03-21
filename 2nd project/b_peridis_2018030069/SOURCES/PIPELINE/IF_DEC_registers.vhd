----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:10:49 05/20/2021 
-- Design Name: 
-- Module Name:    IF_DEC_registers - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--datapath if dec registers 
entity IF_DEC_registers is
    Port ( Instr_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Instr_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           Instr_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  CLK : in  STD_LOGIC;
			  Reset : in  STD_LOGIC);
end IF_DEC_registers;


architecture Behavioral of IF_DEC_registers is
--32 bits register
component REG 
Port ( CLK : in  STD_LOGIC;
       RST : in  STD_LOGIC;
       Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
       WE : in  STD_LOGIC;
       Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

begin
--always can write
 instruction_address_register:REG
 port map(CLK=>CLK,
			 RST=>Reset,
			 Datain=>Instr_addr_in,
			 WE=>'1',
			 Dataout=>Instr_addr_out);
 
 instruction_register:REG 
 port map(CLK=>CLK,
			 RST=>Reset,
			 Datain=>Instr_in,
			 WE=>'1',
			 Dataout=>Instr_out);

end Behavioral;

