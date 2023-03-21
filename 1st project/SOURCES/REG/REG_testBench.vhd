--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:15:44 04/01/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH1/REG_testBench.vhd
-- Project Name:  FASH1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: REG
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY REG_testBench IS
END REG_testBench;
 
ARCHITECTURE behavior OF REG_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT REG
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Datain : IN  std_logic_vector(31 downto 0);
         WE : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal Datain : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';

 	--Outputs
   signal Dataout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 200 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: REG PORT MAP (
          CLK => CLK,
          RST => RST,
          Datain => Datain,
          WE => WE,
          Dataout => Dataout
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      --we hold the reset state of every different inputs for 100 ns, so we can see the changes
		wait for 50 ns;-- se there is no problem with the timing diagram
		RST<='1';--in start we reset input and output to zero
		--we deactivated reset , so the new output becomes same as the input 
		--if write enable its 1 or same to  the output before that if write enable is 0
		RST<='0';
		Datain<=X"45DFA891";
		WE<='1';--new output
		wait for CLK_period;
		RST<='0';
		Datain<=X"003245DB";
		WE<='1';--new output
		wait for CLK_period;
		RST<='0';
		Datain<=X"298434FA";
		WE<='0';-- output stays the same as before , no matter the new input
		wait for CLK_period;
		RST<='0';
		Datain<=X"6798ADFF";
		WE<='0';-- output stays the same as before , no matter the new input
		wait for CLK_period;
		RST<='0';
		Datain<=X"1234567D";
		WE<='1';--new output
		wait for CLK_period;
		RST<='1';
		Datain<=X"00000001";
		WE<='1';--new output
		wait for CLK_period;

   

      -- insert stimulus here 

      wait;
   end process;

END;
