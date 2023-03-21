--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:45:30 03/31/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH1/ALU_testBench.vhd
-- Project Name:  FASH1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_testBench IS
END ALU_testBench;
 
ARCHITECTURE behavior OF ALU_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Op => Op,
          Output => Output,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      --we hold the reset state of every different inputs for 200 ns, so we can see the changes
		
		--ADDITION of two positive numbers with A+B<2^31-1: 895412365 + 958685136 =1854097501
      --overflow=0,cout=0
      wait for 50 ns;-- se there is no problem with the timing diagram 
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0000";
		--ADDITION of one positive and one negative number with A+B<0: 895412365 + (-958685136) =-63272771
		--overflow=0,cout=0
      wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"1100_0110_1101_1011_1010_0000_0011_0000";
		Op<="0000";
		--ADDITION of one positive and one negative number with A+B>0: (-895412365) + 958685136 =+63272771
		--overflow=0,cout=1
      wait for 200 ns;
		A<=B"1100_1010_1010_0001_0001_0111_0111_0011";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0000";
		--ADDITION so we can see the CARRY OUT=1
		--cout=1
		wait for 200 ns;
		A<=B"0000_0000_0000_0000_0000_0000_0000_0001";
		B<=B"1111_1111_1111_1111_1111_1111_1111_1111";
		Op<="0000";
		--SUBTRACTION of two positive numbers with A-B<0: 895412365 - 958685136 =-63272771
		--overflow=0,cout=1
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0001";
		--SUBTRACTION of two positive numbers with A-B>0: 958685136-895412365 =63272771
		--overflow=0,cout=0
		wait for 200 ns;
		A<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		B<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		Op<="0001";
		--SUBTRACTION of one positive and one negative number with  A-B<0: (-895412365) - 958685136 =-1854097501
		--overflow=0,cout=0
		wait for 200 ns;
		A<=B"1100_1010_1010_0001_0001_0111_0111_0011";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0001";
		--SUBTRACTION of tone positive and one negative number with A-B>0: 895412365 -(-958685136)=1854097501
		--overflow=0,cout=1
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"1100_0110_1101_1011_1010_0000_0011_0000";
		Op<="0001";
		--SUBSTRACTION of the same number A-B=0: 1-1=0
		--ZERO=1
		wait for 200 ns;
		A<=B"0000_0000_0000_0000_0000_0000_0000_0001";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0001";
		Op<="0001";
		--AND GATE of two random numbers: A AND B
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0010";
		--OR GATE of two random numbers: A OR B
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0011";
		--NOT GATE of a random number:NOT A (ignore input B)
		wait for 200 ns;
		A<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="0100";
		--NAND GATE of two random numbers: A NAND B
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0101";
		--NOR GATE of two random numbers: A NOR B
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0011_1001_0010_0100_0101_1111_1101_0000";
		Op<="0110";
		--ARITHMETIC SHIFT RIGHT of a random number:{A[31],A[31],...A[1]}(ignore input B)
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="1000";
		--LOGICAL SHIFT RIGHT of a random random number: {0,A[31],...A[1]}(ignore input B)
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="1001";
		--LOGICAL SHIFT LEFT of a random random number: {A[30],...A[0],0}(ignore input B)
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="1010";
		--CYCLE ROTATION LEFT of a random number :{A[30],A[29],...A[31]}(ignore input B)
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="1100";
		--CYCLE ROTATION RIGHT of a random number :{A[0],A[31],...A[1]}(ignore input B)
		wait for 200 ns;
		A<=B"0011_0101_0101_1110_1110_1000_1000_1101";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		Op<="1101";
		wait for 200 ns;
		
		--ALL OVERFLOW CASES BELOW:
		
		--ADDITION of two positive numbers with A+B>2^31-1 ,so it is a negative result: 789658965 + 1989523652 =-1515784679
		--overflow=1
		A<=B"0010_1111_0001_0001_0011_1101_0101_0101";
		B<=B"0111_0110_1001_0101_1011_1000_1100_0100";
		Op<="0000";
		wait for 200 ns;
		--ADDITION of two negative numbers with A+B<-2^31 ,so it is a positive result: (-789658965) + (-1989523652)=+1515784679
		--overflow=1
		A<=B"1101_0000_1110_1110_1100_0010_1010_1011";
		B<=B"1000_1001_0110_1010_0100_0111_0011_1100";
		Op<="0000";
		wait for 200 ns;
		--A>0,B<0 A-B<0
		--SUBSTRACTION of a negative and a positive numbers with A-B>2^31-1, so it is a negative result:789658965 - (-1989523652)=-1515784679
		--overflow=1
		A<=B"0010_1111_0001_0001_0011_1101_0101_0101";
		B<=B"1000_1001_0110_1010_0100_0111_0011_1100";
		Op<="0001";
		wait for 200 ns;
		--A<0,B>0 A-B>0
		--SUBSTRACTION of a negative and a positive numbers with A-B<-2^31, so it is a positive result:(-789658965) - 1989523652=+1515784679
		--overflow=1
		A<=B"1101_0000_1110_1110_1100_0010_1010_1011";
		B<=B"0111_0110_1001_0101_1011_1000_1100_0100";
		Op<="0001";
		wait for 200 ns;
		
		--RESET TO ZERO
		A<=B"0000_0000_0000_0000_0000_0000_0000_0000";
		B<=B"0000_0000_0000_0000_0000_0000_0000_0000";


      -- insert stimulus here 

      wait;
   end process;

END;
