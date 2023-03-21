----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:34:01 05/22/2021 
-- Design Name: 
-- Module Name:    PC_Branch_selection - Behavioral 
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

--It is used for calculating the pc_selection if there is going to be PC+4 or in case of 
--a branch instruction if its going to be PC+4+4*IMMEDIATE
entity PC_Branch_selection is
    Port ( b_sig : in  STD_LOGIC;
           beq_sig : in  STD_LOGIC;
           bne_sig : in  STD_LOGIC;
			  alu_zero_sig : in  STD_LOGIC;
           branch_selection : out  STD_LOGIC);
end PC_Branch_selection;

architecture Behavioral of PC_Branch_selection is

signal beq,bne : STD_LOGIC;

begin
 
beq<=alu_zero_sig AND beq_sig;
bne<=(NOT(alu_zero_sig)) AND bne_sig;
--IF  a branch or beq or bne occures
branch_selection<=b_sig OR beq OR bne;

end Behavioral;

