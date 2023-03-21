----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    14:49:28 04/16/2021 
-- Design Name: 
-- Module Name:    PROC_SC - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--This is the PROCESS SCHEDULER of the single cycle CPU,its the TOP MODULE that connects :
--the CONTROL unit, DATAPATH unit and the RAM unit{INSTRUCTION and DATA segment in one module}
--By running the process scheduler unit we are going to verify the total operation our completed single cycle CPU circuit
--to test it we are going to run some MIPS like instructions to progress them,by loading to the RAM module te file needed for each test
entity PROC_SC is
    Port ( --INPUTS are only clock and reset and there are no outputs
			  CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end PROC_SC;

architecture Behavioral of PROC_SC is

--CONTROL component declaration
component CONTROL
Port(PC_sel_control : out  STD_LOGIC;
	  PC_LdEn_control : out  STD_LOGIC;
	  
	  ImmExt_control : out  STD_LOGIC_VECTOR (1 downto 0);
	  RF_WrData_sel_control : out  STD_LOGIC;
	  RF_B_sel_control : out  STD_LOGIC;
	  RF_WrEn_control : out  STD_LOGIC;
	  
	  ALU_Bin_sel_control : out  STD_LOGIC;
	  ALU_func_control : out  STD_LOGIC_VECTOR (3 downto 0);
	  ALU_zero_control : in STD_LOGIC;
	  
	  ByteOp_control : out  STD_LOGIC;
	  MEM_WrEn_control : out  STD_LOGIC;
	  
	  Instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
	  Reset : in  STD_LOGIC);
end component;

--DATAPATH component declaration
component DATAPATH
Port(--Inputs
	  Reset : in  STD_LOGIC;
	  CLK : in  STD_LOGIC;
	  
	  --Inputs of IFSTAGE
	  PC_sel : in  STD_LOGIC;
	  PC_LdEn : in  STD_LOGIC;
	  --Output of IFSTAGE
	  PC : out  STD_LOGIC_VECTOR (31 downto 0);
	  
	  --Inputs of DECSTAGE
	  ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
	  RF_WrEn : in  STD_LOGIC;
	  RF_B_sel : in  STD_LOGIC;
	  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
	  RF_WrData_sel : in  STD_LOGIC;
	  
	  --Inputs of EXSTAGE
	  ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
	  ALU_Bin_sel : in  STD_LOGIC;
	  --Outputs of EXSTAGE
	  ALU_zero : out  STD_LOGIC;
	  ALU_cout : out  STD_LOGIC;
	  ALU_ovf : out  STD_LOGIC;
	  
	  --Inputs of MEMSTAGE
	  ByteOp : in  STD_LOGIC;
	  MEM_WrEn : in  STD_LOGIC;
	  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
	  --Outputs of MEMSTAGE
	  MM_WrEn : out  STD_LOGIC;
	  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
	  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--RAM component declaration
component RAM
Port(clk : in std_logic;

	  inst_addr : in std_logic_vector(10 downto 0);
	  inst_dout : out std_logic_vector(31 downto 0);
	  
	  data_we : in std_logic;
	  data_addr : in std_logic_vector(10 downto 0);
	  data_din : in std_logic_vector(31 downto 0);
	  data_dout : out std_logic_vector(31 downto 0));
end component;

--INTEGRAL SIGNALS that help us connect the submodules control-datapath-ram
--=========================================================================
--SIGNALS THAT ARE OUTPUTS FROM CONTROL
--going to datapath ifstage
signal PC_sel_top,PC_LdEn_top : std_logic; 
--going to datapath decstage 
signal RF_WrData_sel_top,RF_B_sel_top,RF_WrEn_top : std_logic;
signal ImmExt_top : std_logic_vector(1 downto 0);
--going to datapath exstage
signal ALU_Bin_sel_top : std_logic;
signal ALU_func_top : std_logic_vector(3 downto 0);
--going to datapath memstage 
signal ByteOp_top,MEM_WrEn_top : std_logic;

--SIGNALS THAT ARE OUTPUTS FROM DATAPATH
--going to ram
signal MM_WrData_top,MM_Addr_top : std_logic_vector(31 downto 0);
signal MM_WrEn_top : std_logic;
signal PC_top : std_logic_vector(31 downto 0);
--going to control
signal ALU_zero_top : std_logic;

--SIGNALS THAT ARE OUTPUTS FROM RAM
--going to control and datapath
signal Instr_top : std_logic_vector(31 downto 0);
--going to datapath
signal MM_RdData_top : std_logic_vector(31 downto 0);

begin

--control unit port mapping
CONTROL_module:CONTROL
port map(--every output is going to the datapath
			PC_sel_control=>PC_sel_top,
			PC_LdEn_control=>PC_LdEn_top,
	  
			ImmExt_control=>ImmExt_top,
			RF_WrData_sel_control=>RF_WrData_sel_top,
			RF_B_sel_control=>RF_B_sel_top,
			RF_WrEn_control=>RF_WrEn_top,
	  
			ALU_Bin_sel_control=>ALU_Bin_sel_top,
			ALU_func_control=>ALU_func_top,
			--input*its coming from the datapath
			ALU_zero_control=>ALU_zero_top,
	  
			ByteOp_control=>ByteOp_top,
			MEM_WrEn_control=>MEM_WrEn_top,
			--input*its coming from ram instruction segment
			Instr_in=>Instr_top,
			Reset=>Reset);

--datapath unit port mapping
DATAPATH_module:DATAPATH
port map(--inputs instr and MM_RdData coming from RAM instruction and data segments
			--all other inputs are coming from the control
			
			Reset=>Reset,
			CLK=>CLK,
	  
			--Inputs of IFSTAGE
			PC_sel=>PC_sel_top,
			PC_LdEn=>PC_LdEn_top,
			--Output of IFSTAGE
			--going to instruction segment of RAM
			PC=>PC_top,
	  
			--Inputs of DECSTAGE
			ImmExt=>ImmExt_top,
			RF_WrEn=>RF_WrEn_top,
			RF_B_sel=>RF_B_sel_top,
			Instr=>Instr_top,
			RF_WrData_sel=>RF_WrData_sel_top,
	  
			--Inputs of EXSTAGE
			ALU_func=>ALU_func_top,
			ALU_Bin_sel=>ALU_Bin_sel_top,
		   --Outputs of EXSTAGE
			--going to control
		   ALU_zero=>ALU_zero_top,
			--we dont connect them somewhere,there are just flags if we need to see if there is overflow or carry out
		   ALU_cout=>open,
		   ALU_ovf=>open,
	  
		   --Inputs of MEMSTAGE
		   ByteOp=>ByteOp_top,
		   MEM_WrEn=>MEM_WrEn_top,
		   MM_RdData=>MM_RdData_top,
		   --Outputs of MEMSTAGE
			--going to data segment of RAM
		   MM_WrEn=>MM_WrEn_top,
		   MM_Addr=>MM_Addr_top,
		   MM_WrData=>MM_WrData_top);
			
--RAM module port mapping 
RAM_module:RAM
port map(clk=>CLK,
			--we take 12 down to 2 bits from the PC that comes from datapath IFSTAGE
		   inst_addr=>PC_top(12 downto 2),
			--output to control and to datapath decstage
		   inst_dout=>Instr_top,
		  
		   data_we=>MM_WrEn_top,
			----we take 12 down to 2 bits from the Memory Address that comes from datapath MEMSTAGE
		   data_addr=>MM_Addr_top(12 downto 2),
		   data_din=>MM_WrData_top,
			--output to datapath memstage
		   data_dout=>MM_RdData_top);


end Behavioral;

