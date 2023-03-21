--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:56:25 04/06/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/converte_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: converter
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
 
ENTITY converter_testBench IS
END converter_testBench;
 
ARCHITECTURE behavior OF converter_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT converter
    PORT(
         Input : IN  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         Selection : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Input : std_logic_vector(15 downto 0) := (others => '0');
   signal Selection : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: converter PORT MAP (
          Input => Input,
          Output => Output,
          Selection => Selection
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 50 ns.
      wait for 50 ns;
		--trying out all the different cases of selection that convert the input
		Input<=X"0001";
		Selection<="00";
		wait for 100 ns;
		Input<=X"0001";
		Selection<="01";
		wait for 100 ns;
		Input<=X"FFFF";
		Selection<="00";
		wait for 100 ns;
		Input<=X"FFFF";
		Selection<="01";
		wait for 100 ns;
		Input<=X"FFFF";
		Selection<="10";
		wait for 100 ns;
		Input<=X"FFFF";
		Selection<="11";
		wait for 100 ns;
		Input<=X"0001";
		Selection<="10";
		wait for 100 ns;
		Input<=X"0001";
		Selection<="11";
		wait for 100 ns;



      -- insert stimulus here 

      wait;
   end process;

END;
