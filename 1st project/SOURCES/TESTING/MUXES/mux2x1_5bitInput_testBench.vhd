--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:34:33 04/06/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/mux2x1_5bitInput_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux2x1_5bitInput
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
 
ENTITY mux2x1_5bitInput_testBench IS
END mux2x1_5bitInput_testBench;
 
ARCHITECTURE behavior OF mux2x1_5bitInput_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux2x1_5bitInput
    PORT(
         mux_IN0 : IN  std_logic_vector(4 downto 0);
         mux_IN1 : IN  std_logic_vector(4 downto 0);
         mux_OUT : OUT  std_logic_vector(4 downto 0);
         mux_SELECT : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mux_IN0 : std_logic_vector(4 downto 0) := (others => '0');
   signal mux_IN1 : std_logic_vector(4 downto 0) := (others => '0');
   signal mux_SELECT : std_logic := '0';

 	--Outputs
   signal mux_OUT : std_logic_vector(4 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux2x1_5bitInput PORT MAP (
          mux_IN0 => mux_IN0,
          mux_IN1 => mux_IN1,
          mux_OUT => mux_OUT,
          mux_SELECT => mux_SELECT
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 50 ns.
     wait for 50 ns;
	--try out the different selections
	mux_IN0<="11111";
	mux_IN1<="00000";
	mux_SELECT<='0';
	wait for 100 ns;
	mux_IN0<="11111";
	mux_IN1<="00000";
	mux_SELECT<='1';
	wait for 100 ns;
	mux_IN0<="11111";
	mux_IN1<="00000";
	mux_SELECT<='1';
	wait for 100 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
