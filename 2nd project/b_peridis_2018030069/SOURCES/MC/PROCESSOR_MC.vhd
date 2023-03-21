----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:20:20 05/15/2021 
-- Design Name: 
-- Module Name:    PROCESSOR_MC - Behavioral 
-- Project Name: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the PROCESSOR MULTI CYCLE unit:
--its same as the single cycle processo runit but now we merge the multi cycle parts 
--the CONTROL_MC unit, DATAPATH_MC unit and the RAM unit{INSTRUCTION and DATA segment in one module} 
--By running the processor mc unit we are going to verify the total operation our completed multi cycle CPU circuit 
--to test it we are going to run some MIPS like instructions to progress them,by loading to the RAM module te file needed for each test 
entity PROCESSOR_MC is
    Port ( --INPUTS are only clock and reset and there are no outputs 			  
	 CLK : in  STD_LOGIC;            
	 Reset : in  STD_LOGIC);
end PROCESSOR_MC;

architecture Behavioral of PROCESSOR_MC is

--CONTROL component declaration 
component CONTROL_MC 
Port (     CLK : in  STD_LOGIC;            
PC_sel_control_mc : out  STD_LOGIC;            
PC_LdEn_control_mc : out  STD_LOGIC; 			  
ImmExt_control_mc : out  STD_LOGIC_VECTOR (1 downto 0);            
RF_WrData_sel_control_mc : out  STD_LOGIC;            
RF_B_sel_control_mc : out  STD_LOGIC;           
 RF_WrEn_control_mc : out  STD_LOGIC;            
 ALU_Bin_sel_control_mc : out  STD_LOGIC;            
 ALU_func_control_mc : out  STD_LOGIC_VECTOR (3 downto 0); 			  
 ALU_zero_control_mc: in STD_LOGIC; 			  
 ByteOp_control_mc : out  STD_LOGIC;            
 MEM_WrEn_control_mc : out  STD_LOGIC;            
 Instr_in : in  STD_LOGIC_VECTOR (31 downto 0); 			  
 Reset : in  STD_LOGIC; 			  
 IR_WrEn_control_mc: out  STD_LOGIC; 			 
 ALUR_WrEn_control_mc: out  STD_LOGIC; 			  
 MDR_WrEn_control_mc: out  STD_LOGIC; 			  
 RF_AR_WrEn_control_mc: out  STD_LOGIC; 			  
 RF_BR_WrEn_control_mc: out  STD_LOGIC; 			  
 ImmedR_WrEn_control_mc: out  STD_LOGIC); 
 end component;
 
 --DATAPATH component declaration 
 component DATAPATH_MC 
 Port ( --Inputs 			  
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
 MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); 			   			  
 --Registers 			  
 IR_WrEn: in  STD_LOGIC; 			   
 MDR_WrEn: in  STD_LOGIC; 			  
 ALUR_WrEn: in  STD_LOGIC; 			  
 RF_AR_WrEn: in  STD_LOGIC; 			  
 RF_BR_WrEn: in  STD_LOGIC; 			   
 ImmedR_WrEn: in  STD_LOGIC); 
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
--write enables from registers
signal IR_WrEn_top,MDR_WrEn_top,ALUR_WrEn_top,RF_BR_WrEn_top,RF_AR_WrEn_top, ImmedR_WrEn_top: std_logic;  
--going to datapath ifstage 
signal PC_sel_top,PC_LdEn_top :std_logic;  
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
control_module:CONTROL_MC 
port map(  CLK=>CLK,            
PC_sel_control_mc=>PC_sel_top,            
PC_LdEn_control_mc=>PC_LdEn_top, 			  
ImmExt_control_mc=>ImmExt_top,            
RF_WrData_sel_control_mc=>RF_WrData_sel_top,            
RF_B_sel_control_mc=>RF_B_sel_top,            
RF_WrEn_control_mc=>RF_WrEn_top,            
ALU_Bin_sel_control_mc=>ALU_Bin_sel_top,            
ALU_func_control_mc=>ALU_func_top, 			  
ALU_zero_control_mc=>ALU_zero_top, 			  
ByteOp_control_mc=>ByteOp_top,            
MEM_WrEn_control_mc=>MEM_WrEn_top,            
Instr_in=>Instr_top, 			  
Reset=>Reset, 			  
IR_WrEn_control_mc=>IR_WrEn_top, 			  
ALUR_WrEn_control_mc=>ALUR_WrEn_top, 			  
MDR_WrEn_control_mc=>MDR_WrEn_top, 			  
RF_AR_WrEn_control_mc=>RF_AR_WrEn_top, 			 
RF_BR_WrEn_control_mc=>RF_BR_WrEn_top, 			  
ImmedR_WrEn_control_mc=>ImmedR_WrEn_top);  

--datapath unit port mapping 
datapath_module:DATAPATH_MC 
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
 MM_WrData=>MM_WrData_top, 			
 --Registers 			 
 IR_WrEn=>IR_WrEn_top, 			 
 ALUR_WrEn=>ALUR_WrEn_top, 			 
 MDR_WrEn=>MDR_WrEn_top, 			 
 RF_AR_WrEn=>RF_AR_WrEn_top, 			 
 RF_BR_WrEn=>RF_BR_WrEn_top, 			 
 ImmedR_WrEn=>ImmedR_WrEn_top); 			 
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

