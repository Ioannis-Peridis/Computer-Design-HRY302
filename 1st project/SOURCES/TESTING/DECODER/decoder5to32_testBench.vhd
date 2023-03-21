--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:40:20 04/01/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH1/decoder5to32_testBench.vhd
-- Project Name:  FASH1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decoder5to32
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
 
ENTITY decoder5to32_testBench IS
END decoder5to32_testBench;
 
ARCHITECTURE behavior OF decoder5to32_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder5to32
    PORT(
         decoderIN : IN  std_logic_vector(4 downto 0);
         decoderOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal decoderIN : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal decoderOUT : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder5to32 PORT MAP (
          decoderIN => decoderIN,
          decoderOUT => decoderOUT
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      --we hold the reset state of every different inputs for 100 ns, so we can see the changes
      wait for 50 ns;-- se there is no problem with the timing diagram
		--we intialize in every 100ns every possible input of the decoder se we can see all the different outputs
		decoderIN<="00000";
		wait for 100 ns;
		decoderIN<="00001";
		wait for 100 ns;
		decoderIN<="00010";
		wait for 100 ns;
		decoderIN<="00011";
		wait for 100 ns;
		decoderIN<="00100";
		wait for 100 ns;
		decoderIN<="00101";
		wait for 100 ns;
		decoderIN<="00110";
		wait for 100 ns;
		decoderIN<="00111";
		wait for 100 ns;
		decoderIN<="01000";
		wait for 100 ns;
		decoderIN<="01001";
		wait for 100 ns;
		decoderIN<="01010";
		wait for 100 ns;
		decoderIN<="01011";
		wait for 100 ns;
		decoderIN<="01100";
		wait for 100 ns;
		decoderIN<="01101";
		wait for 100 ns;
		decoderIN<="01110";
		wait for 100 ns;
		decoderIN<="01111";
		wait for 100 ns;
		decoderIN<="10000";
		wait for 100 ns;
		decoderIN<="10001";
		wait for 100 ns;
		decoderIN<="10010";
		wait for 100 ns;
		decoderIN<="10011";
		wait for 100 ns;
		decoderIN<="10100";
		wait for 100 ns;
		decoderIN<="10101";
		wait for 100 ns;
		decoderIN<="10110";
		wait for 100 ns;
		decoderIN<="10111";
		wait for 100 ns;
		decoderIN<="11000";
		wait for 100 ns;
		decoderIN<="11001";
		wait for 100 ns;
		decoderIN<="11010";
		wait for 100 ns;
		decoderIN<="11011";
		wait for 100 ns;
		decoderIN<="11100";
		wait for 100 ns;
		decoderIN<="11101";
		wait for 100 ns;
		decoderIN<="11110";
		wait for 100 ns;
		decoderIN<="11111";
		wait for 100 ns;
		


      -- insert stimulus here 

      wait;
   end process;

END;
