--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:21:47 04/15/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH3/CONTROL_testBench.vhd
-- Project Name:  FASH3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL
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
 
ENTITY CONTROL_testBench IS
END CONTROL_testBench;
 
ARCHITECTURE behavior OF CONTROL_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         PC_sel_control : OUT  std_logic;
         PC_LdEn_control : OUT  std_logic;
         ImmExt_control : OUT  std_logic_vector(1 downto 0);
         RF_WrData_sel_control : OUT  std_logic;
         RF_B_sel_control : OUT  std_logic;
         RF_WrEn_control : OUT  std_logic;
         ALU_Bin_sel_control : OUT  std_logic;
         ALU_func_control : OUT  std_logic_vector(3 downto 0);
         ByteOp_control : OUT  std_logic;
         MEM_WrEn_control : OUT  std_logic;
         Instr_in : IN  std_logic_vector(31 downto 0);
         Reset : IN  std_logic;
			ALU_zero_control: IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Instr_in : std_logic_vector(31 downto 0) := (others => '0');
   signal Reset : std_logic := '0';
	signal ALU_zero_control : std_logic := '0';

 	--Outputs
   signal PC_sel_control : std_logic;
   signal PC_LdEn_control : std_logic;
   signal ImmExt_control : std_logic_vector(1 downto 0);
   signal RF_WrData_sel_control : std_logic;
   signal RF_B_sel_control : std_logic;
   signal RF_WrEn_control : std_logic;
   signal ALU_Bin_sel_control : std_logic;
   signal ALU_func_control : std_logic_vector(3 downto 0);
   signal ByteOp_control : std_logic;
   signal MEM_WrEn_control : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
          PC_sel_control => PC_sel_control,
          PC_LdEn_control => PC_LdEn_control,
          ImmExt_control => ImmExt_control,
          RF_WrData_sel_control => RF_WrData_sel_control,
          RF_B_sel_control => RF_B_sel_control,
          RF_WrEn_control => RF_WrEn_control,
          ALU_Bin_sel_control => ALU_Bin_sel_control,
          ALU_func_control => ALU_func_control,
          ByteOp_control => ByteOp_control,
          MEM_WrEn_control => MEM_WrEn_control,
          Instr_in => Instr_in,
          Reset => Reset,
			 ALU_zero_control=>ALU_zero_control
        );
 

   -- Stimulus process
   stim_proc: process
   begin	
		--this is the testbench of every possible instruction that control is going to get ordered like the table given, 
		--so we can see all the different output signals will be created by it
		--every case with the same order is explained with details to the control unit
	
      -- hold reset state for 50 ns.
      wait for 50 ns;
		--activate reset to initialize all outputs to 0
		Reset<='1';
		wait for 200 ns;
		--reset now is deactvated , so we can see the outputs
		Reset<='0';
		
		--=================================================
		--The instructions between the lines below have the same OPCODE, but they are different from each other due to their different functions
		
		--add
		Instr_in<=B"100000_00001_00011_00111_00000_110000";
		wait for 200 ns;
		--sub
		Instr_in<=B"100000_00001_00011_00111_00000_110001";
		wait for 200 ns;
		--and
		Instr_in<=B"100000_00001_00011_00111_00000_110010";
		wait for 200 ns;
		--or
		Instr_in<=B"100000_00001_00011_00111_00000_110011";
		wait for 200 ns;
		--not
		Instr_in<=B"100000_00001_00011_00111_00000_110100";
		wait for 200 ns;
		--nand
		Instr_in<=B"100000_00001_00011_00111_00000_110101";
		wait for 200 ns;
		--nor
		Instr_in<=B"100000_00001_00011_00111_00000_110110";
		wait for 200 ns;
		--sra
		Instr_in<=B"100000_00001_00011_00111_00000_111000";
		wait for 200 ns;
		--srl
		Instr_in<=B"100000_00001_00011_00111_00000_111001";
		wait for 200 ns;
		--sll
		Instr_in<=B"100000_00001_00011_00111_00000_111010";
		wait for 200 ns;
		--rol
		Instr_in<=B"100000_00001_00011_00111_00000_111100";
		wait for 200 ns;
		--ror
		Instr_in<=B"100000_00001_00011_00111_00000_111101";
		wait for 200 ns;
		--=================================================
		--from here to below every instruction has different opcode with each other
		
		--the instructions li and lui, use the r0 register that by convention is always set to 0 and it can not change his value
		--so we have to put when we are going to use it his value equal to zero->  RF[rs]=RF[r0]=0 
		
		--li
		Instr_in<=B"111000_00000_00011_00111_00000_000000";
		wait for 200 ns;
		--lui
		Instr_in<=B"111001_00000_00011_00111_00000_000000";
		wait for 200 ns;
		--addi
		Instr_in<=B"110000_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--nandi
		Instr_in<=B"110010_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--ori
		Instr_in<=B"110011_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--b
		Instr_in<=B"111111_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--beq+alu_zero=1-> it will brunch
		Instr_in<=B"000000_00001_00011_00111_00000_000000";
		ALU_zero_control<='1';
		wait for 200 ns;
		--beq+alu_zero=0-> it will NOT brunch
		Instr_in<=B"000000_00001_00011_00111_00000_000000";
		ALU_zero_control<='0';
		wait for 200 ns;
		--bne+alu_zero=0->it will brunch
		Instr_in<=B"000001_00001_00011_00111_00000_000000";
		ALU_zero_control<='0';
		wait for 200 ns;
		--bne+alu_zero=1-> it will NOT brunch
		Instr_in<=B"000001_00001_00011_00111_00000_000000";
		ALU_zero_control<='1';
		wait for 200 ns;
		--lb
		Instr_in<=B"000011_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--sb
		Instr_in<=B"000111_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--lw
		Instr_in<=B"001111_00001_00011_00111_00000_000000";
		wait for 200 ns;
		--sw
		Instr_in<=B"011111_00001_00011_00111_00000_000000";
		wait for 200 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
