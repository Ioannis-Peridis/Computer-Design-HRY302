----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:50:29 05/15/2021 
-- Design Name: 
-- Module Name:    DATAPATH_MC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the Datapath of the Multicycle Control Prosses Unit:
--Its the same thing as the datapath of the singlecycle but this time we run multiple cycles per instruction, 
--depending on the instruction's format its between 3 and 5 cycles.
--That means that the clock period now its going to be very smaller than the single cycle CPU, because it won't need to be as long as the biggest in time instruction
--To acomplish that we add registers betweenthe 4 stages so we can hold the values needed  
entity DATAPATH_MC is
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
			 MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); 			   			  
			 --Registers Write Enables  			  
			 IR_WrEn: in  STD_LOGIC; 			  
			 MDR_WrEn: in  STD_LOGIC; 			  
			 ALUR_WrEn: in  STD_LOGIC;
			 RF_AR_WrEn: in  STD_LOGIC;
			 RF_BR_WrEn: in  STD_LOGIC;
			 ImmedR_WrEn: in  STD_LOGIC);

end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is

--REGISTER component declaration 
component REG
Port (CLK : in  STD_LOGIC;									       
		RST : in  STD_LOGIC;									       
		Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);	      
		WE : in  STD_LOGIC;									       
		Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;  
	
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
Port( ByteOp : in  STD_LOGIC;									 	  
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
--REGISTER INPUTS
signal Immed_top, RF_A_top, RF_B_top ,ALU_out_top, MEM_Data_out_top : STD_LOGIC_VECTOR (31 downto 0);
--REGISTER OUTPUTS 
signal RF_A_REG, RF_B_REG, ALU_out_REG ,MEM_Data_out_REG, Instr_REG, Immed_REG: STD_LOGIC_VECTOR (31 downto 0);

begin

--port mapping of ifstage 
IstructionFetchStage:IFSTAGE 
port map(--PC_Immed comes from the decstage's ,immediate converter output(OUTPUT OF THE REGISTER ImmedR) 			
			PC_Immed =>Immed_REG, 			
			PC_sel =>PC_sel,						  			
			PC_LdEn =>PC_LdEn,							   			
			Reset =>Reset,						  			
			Clk =>CLK,							  			
			PC =>PC); 		   
--All the other inputs are going to come from controlpath
   
--port mapping of decstage
InstructionDecodingStage:DECSTAGE
port map(--Instr input comes from OUTPUT OF THE REGISTER IR
			Instr =>Instr_REG,  			
			RF_WrEn =>RF_WrEn,							  			
			Reset =>Reset,	 			
			--ALU_out is coming from the exstage's, ALU output(its the result of the operation)(OUTPUT OF THE REGISTER ALUR) 			
			ALU_out =>ALU_out_REG, 			
			--MEM_out is coming from memstage's output (OUTPUT OF THE REGISTER MDR) 			
			MEM_out =>MEM_Data_out_REG, 			
			RF_WrData_sel =>RF_WrData_sel,				   			
			RF_B_sel =>RF_B_sel,					   			
			ImmExt =>ImmExt,   			
			Clk =>CLK,	 			
			--Immed output is going to the exstage's mux also, and to the ifstage's adder (INPUT TO THE REGISTER ImmedR) 			
			Immed =>Immed_top, 			
			--RF_A output, is going to go to the exstage's first input operand of the ALU (INPUT TO THE REGISTER RF_AR) 			
			RF_A =>RF_A_top, 			
			--RF_B output, is going to go to the exstage's mux that selects the second input operand of the ALU,also to the memstage's datain (INPUT TO THE REGISTER RF_BR) 			
			RF_B =>RF_B_top); 			
			--All the other inputs are going to come from controlpath  
			
			--port mapping of exstage 
ExecutionStage:EXSTAGE 
port map(--first operand of the ALU is coming from the decsatge's read Data of the first register (OUTPUT OF THE REGISTER RF_AR) 			
			RF_A =>RF_A_REG, 			
			--input of the mux that selects the second operand of the ALU ,is coming from the decsatge's read Data of the second register(OUTPUT OF THE REGISTER RF_BR)  			
			RF_B =>RF_B_REG,	 			
			--second input of the mux,immediate value is coming from the decstage's immediate converter(OUTPUT OF THE REGISTER ImmedR) 			
			Immed =>Immed_REG, 			
			ALU_Bin_sel =>ALU_Bin_sel,					 			
			ALU_func =>ALU_func, 			
			--ALU's result is going to memstage's ALU_address and to the decstage's mux that selects the data input(INPUT TO THE REGISTER ALUR) 			
			ALU_out =>ALU_out_top, 			
			ALU_zero =>ALU_zero,					 			
			ALU_Cout =>ALU_Cout,						 			
			ALU_Ovf =>ALU_Ovf); 		   
			--All the other inputs are going to come from controlpath  
			
			--port mapping of memstage 
MemoryAccessStage:MEMSTAGE 
port map(ByteOp =>ByteOp,								 			
			Mem_WrEn =>Mem_WrEn, 			
			--ALU memory addres is coming from the exstage's ALU result(OUTPUT OF THE REGISTER ALUR)		 			
			ALU_MEM_Addr =>ALU_out_REG, 			
			--Memory data input is coming from the decsatge's read Data of the second register(OUTPUT OF THE REGISTER RF_BR)  			
			MEM_DataIn =>RF_B_REG,	 			
			MM_RdData =>MM_RdData, 			
			--memory data output is going to the decstage's mux that select the data input(INPUT TO THE REGISTER MDR)
			MEM_DataOut =>MEM_Data_out_top,
			MM_Addr =>MM_Addr,	 
			MM_WrEn =>MM_WrEn,								
			MM_WrData =>MM_WrData);
			--All the other inputs are going to come from controlpath
			
--port mapping of the registers that hold the values

--holds the value of RF[A]
RF_A_register:REG
port map(CLK=>CLK,
         RST=>Reset,
         Datain=>RF_A_top,  
         WE=>RF_BR_WrEn,  		
         Dataout=>RF_A_REG);

--holds the value of RF[B]
RF_B_register:REG
port map(CLK=>CLK,
         RST=>Reset,
         Datain=>RF_B_top,  
         WE=>RF_AR_WrEn, 		
         Dataout=>RF_B_REG);
			
--holds the value of the ALU result		
ALU_reg:REG
port map(CLK=>CLK, 
         RST=>Reset, 
         Datain=>ALU_out_top, 
         WE=>AlUR_WrEn,  		
         Dataout=>ALU_out_REG);

--holds the instruction
Instruction_reg:REG
port map(CLK=>CLK, 
         RST=>Reset, 
         Datain=>Instr, 
         WE=>IR_WrEn, 		
         Dataout=>Instr_REG);

--holds the memory data
MEM_DataOut_reg:REG
port map(CLK=>CLK,
         RST=>Reset, 
         Datain=>MEM_Data_out_top, 
         WE=>MDR_WrEn, 		
         Dataout=>MEM_Data_out_REG);

--holds the converted immediate			 
Immed_register:REG 
port map(CLK=>CLK,          
			RST=>Reset,           
			Datain=>Immed_top,           
			WE=>ImmedR_WrEn, 		          
			Dataout=>Immed_REG);  

end Behavioral;

