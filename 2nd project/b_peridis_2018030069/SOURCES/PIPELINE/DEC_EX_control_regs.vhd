----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:36:16 05/21/2021 
-- Design Name: 
-- Module Name:    DEC_EX_control_regs - Behavioral 
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

--dec ex control registers
entity DEC_EX_control_regs is
Port( DEC_EX_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		DEC_EX_MEM_in: in STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_EX_in: in STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		DEC_EX_MEM_out: out STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_EX_out: out STD_LOGIC_VECTOR(4 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end DEC_EX_control_regs;

architecture Behavioral of DEC_EX_control_regs is
--5 bits register
component REG_5bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--input 5 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(4 DOWNTO 0));--5 bit output
end component;
--2 bit registers 
component REG_2bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(1 DOWNTO 0);	--input 2 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(1 DOWNTO 0));--5 bit output
end component;

begin
--they can alwyasy write 
write_back_register:REG_2bits 
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>DEC_EX_WB_in,
			WE=>'1',									
			Dataout=>DEC_EX_WB_out);

memory_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>DEC_EX_MEM_in,
			WE=>'1',									
			Dataout=>DEC_EX_MEM_out);
			
execute_register:REG_5bits
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>DEC_EX_EX_in,
			WE=>'1',									
			Dataout=>DEC_EX_EX_out);
			
end Behavioral;

