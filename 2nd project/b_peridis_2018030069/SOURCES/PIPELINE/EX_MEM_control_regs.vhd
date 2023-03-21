----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:38:15 05/21/2021 
-- Design Name: 
-- Module Name:    EX_MEM_control_regs - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--5 bits register and 2 bit register
--it is used to store the control signals coming from execute and going to memory
--its between execute and memory stages
entity EX_MEM_control_regs is
Port( EX_MEM_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		EX_MEM_MEM_in: in STD_LOGIC_VECTOR(4 downto 0);
		EX_MEM_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		EX_MEM_MEM_out: out STD_LOGIC_VECTOR(4 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end EX_MEM_control_regs;

architecture Behavioral of EX_MEM_control_regs is

component REG_5bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 5 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--5 bit output
end component;

component REG_2bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(1 DOWNTO 0);	--input 2 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(1 DOWNTO 0));--2 bit output
end component;

begin

write_back_register:REG_2bits 
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>EX_MEM_WB_in,
			WE=>'1',									
			Dataout=>EX_MEM_WB_out);

memory_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>EX_MEM_MEM_in,
			WE=>'1',									
			Dataout=>EX_MEM_MEM_out);

end Behavioral;

