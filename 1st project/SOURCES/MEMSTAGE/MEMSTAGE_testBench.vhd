--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:08:08 04/08/2021
-- Design Name:   
-- Module Name:   C:/Users/User/Desktop/projects/logikh/logikhERG/FASH2/MEMSTAGE_testBench.vhd
-- Project Name:  FASH2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMSTAGE
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

ENTITY MEMSTAGE_testBench IS
END MEMSTAGE_testBench;
 
ARCHITECTURE behavior OF MEMSTAGE_testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMSTAGE
    PORT(
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic;
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ByteOp : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');
   signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);
   signal MM_Addr : std_logic_vector(31 downto 0);
   signal MM_WrEn : std_logic;
   signal MM_WrData : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE PORT MAP (
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          MEM_DataOut => MEM_DataOut,
          MM_Addr => MM_Addr,
          MM_WrEn => MM_WrEn,
          MM_WrData => MM_WrData,
          MM_RdData => MM_RdData
        );

   -- Stimulus process
   stim_proc: process
   begin
		--This is how the outputs occure
		--MM_Addr=ALU_MEM_Addr + 1024 because the data segment is in ram between 1024 to 2047
		--Byte operation defines if MM_WrData=MEM_datain (word) AND MM_RdData=MEM_dataout
		--if ByteOp=1 OR if MM_WrData=MEM_datain(7 downto 0)+zero-fill (last byte) AND MM_RdData=MEM_dataout(7 downto 0)+zero-fill (last byte)
		--MM_WrEn=Mem_WrEn
		
      -- hold reset state for 50 ns.
      wait for 50 ns;
		--initialization of all outputs to zero
		
		--MM_Addr=0+1024=1024
		ByteOp<='0';
		Mem_WrEn<='0';
		ALU_MEM_Addr<=x"00000000";
		MEM_DataIn<=x"00000000";
		MM_RdData<=x"00000000";
		wait for 200ns;
		--memory write is enabled so we can write to memory
		--word
		--MM_WrData=0xaaaaaaff
		--MEM_DataOut=0x01000010
		--MM_Addr=1024+1=1025
		ByteOp<='0';
		Mem_WrEn<='1';
		ALU_MEM_Addr<=x"00000001";
		MEM_DataIn<=x"aaaaaaff";
		MM_RdData<=x"01000010";
		wait for 200ns;
		--memory write is enabled so we can write to memory
		--byte
		--MM_WrData=0x000000ff
		--MEM_DataOut=0x00000011
		--MM_Addr=1024+10=1034
		ByteOp<='1';
		Mem_WrEn<='1';
		ALU_MEM_Addr<=x"0000000A";
		MEM_DataIn<=x"aaaaaaff";
		MM_RdData<=x"11100111";
		wait for 200ns;
		--memory write is unenabled so we can NOT write to memory
		--word
		--MM_WrData=0xf000000f
		--MEM_DataOut=0x11001111
		--MM_Addr=1024+1000=2024
		ByteOp<='0';
		Mem_WrEn<='0';
		ALU_MEM_Addr<=x"000003E8";
		MEM_DataIn<=x"F000000F";
		MM_RdData<=x"11001111";
		wait for 200ns;
		--memory write is enabled so we can write to memory
		--byte
		--MM_WrData=0x00000000
		--MEM_DataOut=0x000000F2
		--MM_Addr=1024+500=1524
		ByteOp<='1';
		Mem_WrEn<='1';
		ALU_MEM_Addr<=x"000001F4";
		MEM_DataIn<=x"11ffbb00";
		MM_RdData<=x"0000AAF2";
		wait for 200ns;
		--memory write is unenabled so we can NOT write to memory
		--word
		--MM_WrData=0xac123405
		--MEM_DataOut=0x00001111
		--MM_Addr=1024+2=1026
		ByteOp<='0';
		Mem_WrEn<='0';
		ALU_MEM_Addr<=x"00000002";
		MEM_DataIn<=x"ac123405";
		MM_RdData<=x"00001111";
		wait for 200ns;
      -- insert stimulus here 

      wait;
   end process;

END;
