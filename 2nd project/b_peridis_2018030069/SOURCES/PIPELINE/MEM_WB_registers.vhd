----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    20:10:49 05/20/2021 
-- Design Name: 
-- Module Name:    MEM_WB_registers - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--mem write back registers fro datapath 
entity MEM_WB_registers is
    Port ( ALU_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
           CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end MEM_WB_registers;

architecture Behavioral of MEM_WB_registers is
--32 bit registers
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
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 32 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--4 bit output
end component;

begin
--they can always write 
ALU_out_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>ALU_out_in,
			WE=>'1',
			Dataout=>ALU_out_out);

instruction_write_address_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>WriteAddr_in,
			WE=>'1',
			Dataout=>WriteAddr_out);

MEM_out_register:REG
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>MEM_out_in,
			WE=>'1',
			Dataout=>MEM_out_out);

end Behavioral;

