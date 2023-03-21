----------------------------------------------------------------------------------
-- Company: Technical Univerisity Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    12:55:52 04/11/2021 
-- Design Name: 
-- Module Name:    DATAPATH - Behavioral 
-- Project Name: Organosi Ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the datapath of the single cycle Control Process Unit:
--Its a set of functional units that carry out data processing operations
--Datapath is a top module that merges with the needed hardware all the stages that are going to happen in a single CPU cycle and performs all the required operations,depending on the instruction given eatch time 
--Instruction Fetch Stage,Instruction Decoding Stage, Execution Stage and Memory Access Stage
entity DATAPATH is
--All of the inputs below are going to come from the control process unit, when the conection is established
--The detailed description of the inputs and outputs is explained at each module separately,also their functionality is going to be analized at the controlpath module
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
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0));
end DATAPATH;


architecture Behavioral of DATAPATH is

--component declaration of the 4 stages

--IFSTAGE component declaration
component IFSTAGE
Port(PC_Immed : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
     PC_sel : in  STD_LOGIC;							 
     PC_LdEn : in  STD_LOGIC;							  
     Reset : in  STD_LOGIC;							 
     Clk : in  STD_LOGIC;								 
     PC : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--DECSTAGE component declaration
component DECSTAGE
Port(Instr : in  STD_LOGIC_VECTOR (31 downto 0);  
	  RF_WrEn : in  STD_LOGIC;							 
	  Reset: in  STD_LOGIC;								 
	  ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
	  MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
	  RF_WrData_sel : in  STD_LOGIC;					  
	  RF_B_sel : in  STD_LOGIC;						  
	  ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);  
	  Clk : in  STD_LOGIC;								  
	  Immed : out  STD_LOGIC_VECTOR (31 downto 0); 
	  RF_A : out  STD_LOGIC_VECTOR (31 downto 0);  
	  RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--EXSTAGE component declaration
component EXSTAGE
Port(RF_A : in  STD_LOGIC_VECTOR (31 downto 0);		
	  RF_B : in  STD_LOGIC_VECTOR (31 downto 0);	  
	  Immed : in  STD_LOGIC_VECTOR (31 downto 0);	
	  ALU_Bin_sel : in  STD_LOGIC;						
	  ALU_func : in  STD_LOGIC_VECTOR (3 downto 0); 
	  ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
	  ALU_zero : out  STD_LOGIC;						
	  ALU_Cout: out  STD_LOGIC;							
	  ALU_Ovf: out  STD_LOGIC);
end component;

--MEMSTAGE component declaration
component MEMSTAGE
Port(ByteOp : in  STD_LOGIC;									
	  Mem_WrEn : in  STD_LOGIC;								 
	  ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
	  MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);	
	  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);	 
	  MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
	  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);	 
	  MM_WrEn : out  STD_LOGIC;								
	  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--integral signals that help us to connect the 4 modules(components) to 1 top module
signal Immed_top,RF_A_top,RF_B_top,ALU_out_top,MEM_Data_out_top : STD_LOGIC_VECTOR (31 downto 0);

begin

--port mapping of ifstage
IstructionFetchStage:IFSTAGE
port map(--PC_Immed comes from the decstage's ,immediate converter output
			PC_Immed =>Immed_top,
			PC_sel =>PC_sel,						 
			PC_LdEn =>PC_LdEn,							  
			Reset =>Reset,						 
			Clk =>CLK,							 
			PC =>PC);
		   --All the other inputs are going to come from controlpath


--port mapping of decstage
InstructionDecodingStage:DECSTAGE
port map(Instr =>Instr, 
			RF_WrEn =>RF_WrEn,							 
			Reset =>Reset,	
			--ALU_out is coming from the exstage's, ALU output(its the result of the operation)
			ALU_out =>ALU_out_top,
			--MEM_out is coming from memstage's output
			MEM_out =>MEM_Data_out_top,
			RF_WrData_sel =>RF_WrData_sel,				  
			RF_B_sel =>RF_B_sel,					  
			ImmExt =>ImmExt,  
			Clk =>CLK,	
			--Immed output is going to the exstage's mux also, and to the ifstage's adder
			Immed =>Immed_top,
			--RF_A output, is going to go to the exstage's first input operand of the ALU
			RF_A =>RF_A_top,
			--RF_B output, is going to go to the exstage's mux that selects the second input operand of the ALU,also to the memstage's datain
			RF_B =>RF_B_top);
			--All the other inputs are going to come from controlpath

--port mapping of exstage
ExecutionStage:EXSTAGE
port map(--first operand of the ALU is coming from the decsatge's read Data of the first register 
			RF_A =>RF_A_top,
			--input of the mux that selects the second operand of the ALU ,is coming from the decsatge's read Data of the second register 
			RF_B =>RF_B_top,	
			--second input of the mux,immediate value is coming from the decstage's immediate converter
			Immed =>Immed_top,
			ALU_Bin_sel =>ALU_Bin_sel,					
			ALU_func =>ALU_func,
			--ALU's result is going to memstage's ALU_address and to the decstage's mux that selects the data input
			ALU_out =>ALU_out_top,
			ALU_zero =>ALU_zero,					
			ALU_Cout =>ALU_Cout,						
			ALU_Ovf =>ALU_Ovf);
		   --All the other inputs are going to come from controlpath

--port mapping of memstage
MemoryAccessStage:MEMSTAGE
port map(ByteOp =>ByteOp,								
			Mem_WrEn =>Mem_WrEn,
			--ALU memory addres is coming from the exstage's ALU result			
			ALU_MEM_Addr =>ALU_out_top,
			--Memory data input is coming from the decsatge's read Data of the second register 
			MEM_DataIn =>RF_B_top,	
			MM_RdData =>MM_RdData,
			--memory data output is going to the decstage's mux that select the data input
			MEM_DataOut =>MEM_Data_out_top,
			MM_Addr =>MM_Addr,	 
			MM_WrEn =>MM_WrEn,								
			MM_WrData =>MM_WrData);
			--All the other inputs are going to come from controlpath

end Behavioral;

