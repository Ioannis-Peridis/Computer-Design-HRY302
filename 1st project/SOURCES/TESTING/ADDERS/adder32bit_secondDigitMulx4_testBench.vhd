--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:47:40 04/05/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/adder32bit_secondDigitMulx4_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adder32bit_secondDigitMulx4
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
 
ENTITY adder32bit_secondDigitMulx4_testBench IS
END adder32bit_secondDigitMulx4_testBench;
 
ARCHITECTURE behavior OF adder32bit_secondDigitMulx4_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adder32bit_secondDigitMulx4
    PORT(
         IN0 : IN  std_logic_vector(31 downto 0);
         IN1 : IN  std_logic_vector(31 downto 0);
         Result : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN0 : std_logic_vector(31 downto 0) := (others => '0');
   signal IN1 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Result : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adder32bit_secondDigitMulx4 PORT MAP (
          IN0 => IN0,
          IN1 => IN1,
          Result => Result
        ); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 50 ns.
      wait for 50 ns;
		--different input testing, result= input0+4*input1
      IN0<=B"0000_0000_0000_0000_0000_0000_0000_0001";
		IN1<=B"0000_0000_0000_0000_0000_0000_0000_1111";
		wait for 200 ns;
		IN0<=B"0000_0000_0000_0000_0000_0001_0000_0000";
		IN1<=B"0000_0000_0000_0000_0000_0000_0000_0010";
		wait for 200 ns;
		IN0<=B"0010_0000_0000_0000_0000_0000_0000_0000";
		IN1<=B"0010_0000_0000_0000_0000_0000_0000_0000";
		wait for 200 ns;
		IN0<=B"0000_0000_0000_0000_0000_0000_0000_0100";
		IN1<=B"0000_0000_0000_0000_0000_0010_0000_0000";
		wait for 200 ns;


      wait;
   end process;

END;
