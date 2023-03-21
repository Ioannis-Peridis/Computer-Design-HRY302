----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:38:44 05/21/2021 
-- Design Name: 
-- Module Name:    MEM_WB_control_regs - Behavioral 
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
--2 bits register
--it is used to store the control signals of RF write enable and the MEM write enable
--its bettween memory and write back stages
entity MEM_WB_control_regs is
Port( MEM_WB_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		MEM_WB_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end MEM_WB_control_regs;

architecture Behavioral of MEM_WB_control_regs is

component REG_2bits 
Port ( CLK : in  STD_LOGIC;								--clock
       RST : in  STD_LOGIC;								-- reset signal, if it is activated to '1' then the output becomes zero
       Datain : in  STD_LOGIC_VECTOR(1 DOWNTO 0);	--input 2 bits
       WE : in  STD_LOGIC;									-- write enable signal , if it is actived to '1', we can write to the register
		 Dataout : out  STD_LOGIC_VECTOR(1 DOWNTO 0));--2 bit output
end component;

begin
--always can write
write_back_register:REG_2bits 
port map(CLK=>CLK,
			RST=>Reset,
			Datain=>MEM_WB_WB_in,
			WE=>'1',									
			Dataout=>MEM_WB_WB_out);

end Behavioral;

