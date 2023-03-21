--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:28:11 04/06/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/mux2x1_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux2x1
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
 
ENTITY mux2x1_testBench IS
END mux2x1_testBench;
 
ARCHITECTURE behavior OF mux2x1_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux2x1
    PORT(
         muxIN0 : IN  std_logic_vector(31 downto 0);
         muxIN1 : IN  std_logic_vector(31 downto 0);
         muxSELECT : IN  std_logic;
         muxOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal muxIN0 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN1 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxSELECT : std_logic := '0';

 	--Outputs
   signal muxOUT : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux2x1 PORT MAP (
          muxIN0 => muxIN0,
          muxIN1 => muxIN1,
          muxSELECT => muxSELECT,
          muxOUT => muxOUT
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
  -- hold reset state for 50 ns.
   wait for 50 ns;
	--trying different inputs, with different select
	muxIN0<=X"0000FFFF";
	muxIN1<=X"FFFF0000";
	muxSELECT<='0';
	wait for 100 ns;
	muxIN0<=X"0000FFFF";
	muxIN1<=X"FFFF0000";
	muxSELECT<='1';
	wait for 100 ns;
	muxIN0<=X"0000FFFF";
	muxIN1<=X"FFFF0000";
	muxSELECT<='0';
	wait for 100 ns;
	muxIN0<=X"0000FFFF";
	muxIN1<=X"FFFF0000";
	muxSELECT<='1';
	wait for 100 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
