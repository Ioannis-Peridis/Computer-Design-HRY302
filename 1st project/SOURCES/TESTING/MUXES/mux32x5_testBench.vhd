--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:50:35 04/01/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH1/mux32x5_testBench.vhd
-- Project Name:  FASH1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux32x5
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
 
ENTITY mux32x5_testBench IS
END mux32x5_testBench;
 
ARCHITECTURE behavior OF mux32x5_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux32x5
    PORT(
         muxIN0 : IN  std_logic_vector(31 downto 0);
         muxIN1 : IN  std_logic_vector(31 downto 0);
         muxIN2 : IN  std_logic_vector(31 downto 0);
         muxIN3 : IN  std_logic_vector(31 downto 0);
         muxIN4 : IN  std_logic_vector(31 downto 0);
         muxIN5 : IN  std_logic_vector(31 downto 0);
         muxIN6 : IN  std_logic_vector(31 downto 0);
         muxIN7 : IN  std_logic_vector(31 downto 0);
         muxIN8 : IN  std_logic_vector(31 downto 0);
         muxIN9 : IN  std_logic_vector(31 downto 0);
         muxIN10 : IN  std_logic_vector(31 downto 0);
         muxIN11 : IN  std_logic_vector(31 downto 0);
         muxIN12 : IN  std_logic_vector(31 downto 0);
         muxIN13 : IN  std_logic_vector(31 downto 0);
         muxIN14 : IN  std_logic_vector(31 downto 0);
         muxIN15 : IN  std_logic_vector(31 downto 0);
         muxIN16 : IN  std_logic_vector(31 downto 0);
         muxIN17 : IN  std_logic_vector(31 downto 0);
         muxIN18 : IN  std_logic_vector(31 downto 0);
         muxIN19 : IN  std_logic_vector(31 downto 0);
         muxIN20 : IN  std_logic_vector(31 downto 0);
         muxIN21 : IN  std_logic_vector(31 downto 0);
         muxIN22 : IN  std_logic_vector(31 downto 0);
         muxIN23 : IN  std_logic_vector(31 downto 0);
         muxIN24 : IN  std_logic_vector(31 downto 0);
         muxIN25 : IN  std_logic_vector(31 downto 0);
         muxIN26 : IN  std_logic_vector(31 downto 0);
         muxIN27 : IN  std_logic_vector(31 downto 0);
         muxIN28 : IN  std_logic_vector(31 downto 0);
         muxIN29 : IN  std_logic_vector(31 downto 0);
         muxIN30 : IN  std_logic_vector(31 downto 0);
         muxIN31 : IN  std_logic_vector(31 downto 0);
         muxSELECT : IN  std_logic_vector(4 downto 0);
         muxOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal muxIN0 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN1 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN2 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN3 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN4 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN5 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN6 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN7 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN8 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN9 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN10 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN11 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN12 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN13 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN14 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN15 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN16 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN17 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN18 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN19 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN20 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN21 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN22 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN23 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN24 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN25 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN26 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN27 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN28 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN29 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN30 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxIN31 : std_logic_vector(31 downto 0) := (others => '0');
   signal muxSELECT : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal muxOUT : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux32x5 PORT MAP (
          muxIN0 => muxIN0,
          muxIN1 => muxIN1,
          muxIN2 => muxIN2,
          muxIN3 => muxIN3,
          muxIN4 => muxIN4,
          muxIN5 => muxIN5,
          muxIN6 => muxIN6,
          muxIN7 => muxIN7,
          muxIN8 => muxIN8,
          muxIN9 => muxIN9,
          muxIN10 => muxIN10,
          muxIN11 => muxIN11,
          muxIN12 => muxIN12,
          muxIN13 => muxIN13,
          muxIN14 => muxIN14,
          muxIN15 => muxIN15,
          muxIN16 => muxIN16,
          muxIN17 => muxIN17,
          muxIN18 => muxIN18,
          muxIN19 => muxIN19,
          muxIN20 => muxIN20,
          muxIN21 => muxIN21,
          muxIN22 => muxIN22,
          muxIN23 => muxIN23,
          muxIN24 => muxIN24,
          muxIN25 => muxIN25,
          muxIN26 => muxIN26,
          muxIN27 => muxIN27,
          muxIN28 => muxIN28,
          muxIN29 => muxIN29,
          muxIN30 => muxIN30,
          muxIN31 => muxIN31,
          muxSELECT => muxSELECT,
          muxOUT => muxOUT
        );
 

   -- Stimulus process
   stim_proc: process
   begin		

	--we hold the reset state of every different inputs for 100 ns, so we can see the changes
		wait for 50 ns;-- se there is no problem with the timing diagram
		--we initialize the multiplexers inputs once and then we leave 
		--them as such and we test all the different select signals
		muxIN0<=X"12345678";
		muxIN1<=X"23456789";
		muxIN2<=X"34567891";
		muxIN3<=X"45678912";  
		muxIN4<=X"56789123";  
		muxIN5<=X"67891234";  
		muxIN6<=X"78912345";  
		muxIN7<=X"89123456";  
		muxIN8<=X"91234567";  
		muxIN9<=X"12345678";  
		muxIN10<=X"A1345678"; 
		muxIN11<=X"A2345678"; 
		muxIN12<=X"A3345678";
		muxIN13<=X"A4345678"; 
		muxIN14<=X"A5345678"; 
		muxIN15<=X"A6345678"; 
		muxIN16<=X"A7345678"; 
		muxIN17<=X"A8345678"; 
		muxIN18<=X"A9345678"; 
		muxIN19<=X"AA345678"; 
		muxIN20<=X"BB145678"; 
		muxIN21<=X"BB245678"; 
		muxIN22<=X"BB345678"; 
		muxIN23<=X"BB445678"; 
		muxIN24<=X"BB545678"; 
		muxIN25<=X"BB645678"; 
		muxIN26<=X"BB745678";
		muxIN27<=X"BB845678";
		muxIN28<=X"123451FF"; 
		muxIN29<=X"123452FF"; 
		muxIN30<=X"123453FF"; 
		muxIN31<=X"123454FF";
		muxSELECT<="00000";
		wait for 100 ns;
		--every 100 ns we give the multiplexer a different select number so it can change
		--the output into one of the different inputs(depending on the select number)
		muxSELECT<="00001";
		wait for 100 ns;
		muxSELECT<="00010";
		wait for 100 ns;
		muxSELECT<="00011";
		wait for 100 ns;
		muxSELECT<="00100";
		wait for 100 ns;
		muxSELECT<="00101";
		wait for 100 ns;
		muxSELECT<="00110";
		wait for 100 ns;
		muxSELECT<="00111";
		wait for 100 ns;
		muxSELECT<="01000";
		wait for 100 ns;
		muxSELECT<="01001";
		wait for 100 ns;
		muxSELECT<="01010";
		wait for 100 ns;
		muxSELECT<="01011";
		wait for 100 ns;
		muxSELECT<="01100";
		wait for 100 ns;
		muxSELECT<="01101";
		wait for 100 ns;
		muxSELECT<="01110";
		wait for 100 ns;
		muxSELECT<="01111";
		wait for 100 ns;
		muxSELECT<="10000";
		wait for 100 ns;
		muxSELECT<="10001";
		wait for 100 ns;
		muxSELECT<="10010";
		wait for 100 ns;
		muxSELECT<="10011";
		wait for 100 ns;
		muxSELECT<="10100";
		wait for 100 ns;
		muxSELECT<="10101";
		wait for 100 ns;
		muxSELECT<="10110";
		wait for 100 ns;
		muxSELECT<="10111";
		wait for 100 ns;
		muxSELECT<="11000";
		wait for 100 ns;
		muxSELECT<="11001";
		wait for 100 ns;
		muxSELECT<="11010";
		wait for 100 ns;
		muxSELECT<="11011";
		wait for 100 ns;
		muxSELECT<="11100";
		wait for 100 ns;
		muxSELECT<="11101";
		wait for 100 ns;
		muxSELECT<="11110";
		wait for 100 ns;
		muxSELECT<="11111";
		wait for 100 ns;	

      -- insert stimulus here 

      wait;
   end process;

END;
