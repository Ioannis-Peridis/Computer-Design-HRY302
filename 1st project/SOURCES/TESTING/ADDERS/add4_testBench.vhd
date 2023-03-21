--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:20:21 04/05/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/add4_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: add4
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
 
ENTITY add4_testBench IS
END add4_testBench;
 
ARCHITECTURE behavior OF add4_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add4
    PORT(
         Input : IN  std_logic_vector(31 downto 0);
         Output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Input : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add4 PORT MAP (
          Input => Input,
          Output => Output
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 50 ns.
      wait for 50 ns;
		--try out different inputs, the result is the input increased by 4
		Input<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 200ns;
		Input<=B"0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 200ns;
		Input<=B"0000_0000_0000_0000_0001_0000_0000_0000";
		wait for 200ns;
		Input<=B"0000_0000_0000_0000_0010_0110_0000_0001";
		wait for 200ns;
		Input<=B"0111_1111_1111_1111_1111_1111_1111_1111";
		wait for 200ns;

      -- insert stimulus here 

      wait;
   end process;

END;
