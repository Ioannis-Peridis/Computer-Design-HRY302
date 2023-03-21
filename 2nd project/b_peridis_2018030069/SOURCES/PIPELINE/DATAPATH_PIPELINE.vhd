----------------------------------------------------------------------------------
-- Company: Techincal University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    21:58:58 05/20/2021 
-- Design Name: 
-- Module Name:    DATAPATH_PIPELINE - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--This is the Datapath of the pipeline processor 
entity DATAPATH_PIPELINE is
    Port (--Inputs
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  
			  --Inputs of IFSTAGE
			  PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           --Output of IFSTAGE
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
           
			  --Inputs of DECSTAGE
			  Branch_sig : in STD_LOGIC_VECTOR (2 downto 0);
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
end DATAPATH_PIPELINE;

architecture Behavioral of DATAPATH_PIPELINE is
--calculates pc selection
component PC_Branch_selection
Port ( b_sig : in  STD_LOGIC;
       beq_sig : in  STD_LOGIC;
       bne_sig : in  STD_LOGIC;
	    alu_zero_sig : in  STD_LOGIC;
       branch_selection : out  STD_LOGIC);
end component;
--between the decode and execution stages
component DEC_EX_control_regs
Port( DEC_EX_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		DEC_EX_MEM_in: in STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_EX_in: in STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		DEC_EX_MEM_out: out STD_LOGIC_VECTOR(4 downto 0);
		DEC_EX_EX_out: out STD_LOGIC_VECTOR(4 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end component;
--between the execution and memory stages
component EX_MEM_control_regs
Port( EX_MEM_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		EX_MEM_MEM_in: in STD_LOGIC_VECTOR(4 downto 0);
		EX_MEM_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		EX_MEM_MEM_out: out STD_LOGIC_VECTOR(4 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end component;
--between memory and write back stages
component MEM_WB_control_regs
Port( MEM_WB_WB_in: in STD_LOGIC_VECTOR(1 downto 0);
		MEM_WB_WB_out: out STD_LOGIC_VECTOR(1 downto 0);
		CLK : in  STD_LOGIC;
      Reset : in  STD_LOGIC);
end component;

--component declaration of the 4 stages
--IFSTAGE component declaration
component IFSTAGE_PIPELINE
Port(PC_Immed : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
     PC_sel : in  STD_LOGIC;							 
     PC_LdEn : in  STD_LOGIC;							  
     Reset : in  STD_LOGIC;							 
     Clk : in  STD_LOGIC;								 
     PC : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
	  instrAddr: out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--DECSTAGE component declaration
component DECSTAGE_PIPELINE
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
	  RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
	  WriteBack : in  STD_LOGIC_VECTOR (4 downto 0));
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
--calculates branch address
component adder32bit_secondDigitMulx4
Port ( --Inputs
		IN0 : in  STD_LOGIC_VECTOR (31 downto 0);
      IN1 : in  STD_LOGIC_VECTOR (31 downto 0);
		--Outputs
      Result : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
--between instruction fetch and decode stages
component IF_DEC_registers 
    Port ( Instr_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Instr_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           Instr_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  CLK : in  STD_LOGIC;
			  Reset : in  STD_LOGIC);
end component;
--between decode and execution stages
component DEC_EX_registers 
    Port ( RF_A_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           Instr_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_A_out : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_out : out  STD_LOGIC_VECTOR (31 downto 0);
           Immed_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
           Instr_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end component;
--between execution and memory stages
component EX_MEM_registers 
    Port ( Branch_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero_in : in  STD_LOGIC;
           ALU_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           Branch_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero_out : out  STD_LOGIC;
           ALU_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
			  CLK : in STD_LOGIC;
			  Reset : in STD_LOGIC);
end component;
--between memory and write back stages
component MEM_WB_registers 
    Port ( ALU_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out_in : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out_out : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteAddr_out : out  STD_LOGIC_VECTOR (4 downto 0);
           CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end component;

--integral signals that help us to connect the 4 modules(components) to 1 top module

--signals coming in and out from datapth if_dec registers
signal if_dec_instrAddr_in,if_dec_instrAddr_out,if_dec_instr_out:STD_LOGIC_VECTOR (31 downto 0);
--signals coming in and out from datapth mdec_ex registers
signal dec_ex_instrAddr_out,dec_ex_rfa_in,dec_ex_rfa_out,dec_ex_rfb_in,dec_ex_rfb_out,dec_ex_immed_in,dec_ex_immed_out:STD_LOGIC_VECTOR (31 downto 0);
signal dec_ex_writeAddr_in,dec_ex_writeAddr_out:STD_LOGIC_VECTOR (4 downto 0);
--signals coming in and out from datapth ex_mem registers
signal ex_mem_branch_in,ex_mem_branch_out,ex_mem_alu_out_in,ex_mem_alu_out_out,ex_mem_rfb_out:STD_LOGIC_VECTOR (31 downto 0);
signal ex_mem_alu_zero_in,ex_mem_alu_zero_out:STD_LOGIC;
signal ex_mem_writeAddr_out:STD_LOGIC_VECTOR (4 downto 0);
--signals coming in and out from datapth mem_wb registers
signal mem_wb_alu_out_out,mem_wb_mem_out_in,mem_wb_mem_out_out:STD_LOGIC_VECTOR (31 downto 0);
signal mem_wb_writeAddr_out:STD_LOGIC_VECTOR (4 downto 0);
--singals coming in and out from cobntrol registers
signal dec_ex_ctrl_wb,mem_wb_ctrl_wb,ex_mem_ctrl_wb:STD_LOGIC_VECTOR (1 downto 0);
signal dec_ex_ctrl_mem,ex_mem_ctrl_mem,dec_ex_ctrl_ex:STD_LOGIC_VECTOR (4 downto 0);
--pc selection
signal branch_out_top:STD_LOGIC;

begin
--we insert the write back register here to go to pass all the stages
dec_ex_writeAddr_in<=if_dec_instr_out(20 downto 16);

--port mapping of ifstage
IstructionFetchStage:IFSTAGE_PIPELINE
port map(--PC_Immed comes from the decstage's ,immediate converter output
			PC_Immed =>ex_mem_branch_out,
			PC_sel =>branch_out_top,						 
			PC_LdEn =>PC_LdEn,							  
			Reset =>Reset,						 
			Clk =>CLK,							 
			PC =>PC,
			instrAddr=>if_dec_instrAddr_in);
		   --All the other inputs are going to come from controlpath


--port mapping of decstage
InstructionDecodingStage:DECSTAGE_PIPELINE
port map(Instr =>if_dec_instr_out, 
			RF_WrEn =>mem_wb_ctrl_wb(1),							 
			Reset =>Reset,	
			--ALU_out is coming from the exstage's, ALU output(its the result of the operation)
			ALU_out =>mem_wb_alu_out_out,
			--MEM_out is coming from memstage's output
			MEM_out =>mem_wb_mem_out_out,
			RF_WrData_sel =>mem_wb_ctrl_wb(0),--RF				  
			RF_B_sel =>RF_B_sel,					  
			ImmExt =>ImmExt,  
			Clk =>CLK,	
			--Immed output is going to the exstage's mux also, and to the ifstage's adder
			Immed =>dec_ex_immed_in,
			--RF_A output, is going to go to the exstage's first input operand of the ALU
			RF_A =>dec_ex_rfa_in,
			--RF_B output, is going to go to the exstage's mux that selects the second input operand of the ALU,also to the memstage's datain
			RF_B =>dec_ex_rfb_in,
			WriteBack=>mem_wb_writeAddr_out);
			--All the other inputs are going to come from controlpath

--port mapping of exstage
ExecutionStage:EXSTAGE
port map(--first operand of the ALU is coming from the decsatge's read Data of the first register 
			RF_A =>dec_ex_rfa_out,
			--input of the mux that selects the second operand of the ALU ,is coming from the decsatge's read Data of the second register 
			RF_B=> dec_ex_rfb_out,	
			--second input of the mux,immediate value is coming from the decstage's immediate converter
			Immed =>dec_ex_immed_out,
			ALU_Bin_sel =>dec_ex_ctrl_ex(0),--ALU Bin sel					
			ALU_func =>dec_ex_ctrl_ex(4 downto 1),--alu FUNC
			--ALU's result is going to memstage's ALU_address and to the decstage's mux that selects the data input
			ALU_out =>ex_mem_alu_out_in,
			ALU_zero =>ex_mem_alu_zero_in,					
			ALU_Cout =>ALU_Cout,						
			ALU_Ovf =>ALU_Ovf);
		   --All the other inputs are going to come from controlpath

--port mapping of memstage
MemoryAccessStage:MEMSTAGE
port map(ByteOp =>ex_mem_ctrl_wb(1),-- Byte op							
			Mem_WrEn =>ex_mem_ctrl_wb(0),-- MEM WR EN
			--ALU memory addres is coming from the exstage's ALU result			
			ALU_MEM_Addr =>ex_mem_alu_out_out,
			--Memory data input is coming from the decsatge's read Data of the second register 
			MEM_DataIn =>ex_mem_rfb_out,	
			MM_RdData =>MM_RdData,
			--memory data output is going to the decstage's mux that select the data input
			MEM_DataOut =>mem_wb_mem_out_in,
			MM_Addr =>MM_Addr,	 
			MM_WrEn =>MM_WrEn,								
			MM_WrData =>MM_WrData);
			--All the other inputs are going to come from controlpath

--calculation of branch address
branch_calculation_adder:adder32bit_secondDigitMulx4
port map(IN0=>dec_ex_instrAddr_out,
			IN1=>dec_ex_immed_out,
			Result=>ex_mem_branch_in);
			
--datapath if_dec registers
InstructionFetch_Decode_registers:IF_DEC_registers
port map(Instr_addr_in=>if_dec_instrAddr_in,
			--instruction comes here
         Instr_in=>Instr,
         Instr_addr_out=>if_dec_instrAddr_out,
         Instr_out=>if_dec_instr_out,
	      CLK=>CLK,
		   Reset=>Reset);

--datapth dec_ex registers
Decode_Execute_registers:DEC_EX_registers
port map(RF_A_in=>dec_ex_rfa_in,
         RF_B_in=>dec_ex_rfb_in,
         Immed_in=>dec_ex_immed_in,
			--write back address
         WriteAddr_in=>dec_ex_writeAddr_in,
         Instr_addr_in=>if_dec_instrAddr_out,
         RF_A_out=>dec_ex_rfa_out,
         RF_B_out=>dec_ex_rfb_out,
         Immed_out=>dec_ex_immed_out,
         WriteAddr_out=>dec_ex_writeAddr_out,
         Instr_addr_out=>dec_ex_instrAddr_out,
         CLK=>CLK,
         Reset=>Reset);

--datapath ex_mem registers
Execute_Memory_registers:EX_MEM_registers
port map(Branch_addr_in=>ex_mem_branch_in,
         ALU_zero_in=>ex_mem_alu_zero_in,
         ALU_out_in=>ex_mem_alu_out_in,
         RF_B_in=>dec_ex_rfb_out,
         WriteAddr_in=>dec_ex_writeAddr_out,
         Branch_addr_out=>ex_mem_branch_out,
         ALU_zero_out=>ex_mem_alu_zero_out,
         ALU_out_out=>ex_mem_alu_out_out,
         RF_B_out=>ex_mem_rfb_out,
         WriteAddr_out=>ex_mem_writeAddr_out,
    	   CLK=>CLK,
		   Reset=>Reset);
			
--mem_wb registers
Memory_WriteBack_registers:MEM_WB_registers
port map(ALU_out_in=>ex_mem_alu_out_out,
         MEM_out_in=>mem_wb_mem_out_in,
         WriteAddr_in=>ex_mem_writeAddr_out,
         ALU_out_out=>mem_wb_alu_out_out,
         MEM_out_out=>mem_wb_mem_out_out,
         WriteAddr_out=>mem_wb_writeAddr_out,
			CLK=>CLK,
         Reset=>Reset);
			
--dec_ex control registers
decode_execution_control_registers:DEC_EX_control_regs
port map(--we concrete the signals needed to pass to the next stages in vectors:
			--2 bit vector going to control WRITE BACK registers from stage ot stage
			--RF_WrData_sel(1) & RF_WrEn(0) 
			DEC_EX_WB_in=>RF_WrData_sel & RF_WrEn,
			--5 bit vector going to control MEMORY registers from stage to stage
			--Branch_sig(4..2) & MEM_WrEn(1) & ByteOp(0)
			DEC_EX_MEM_in=>(Branch_sig & MEM_WrEn & ByteOp),
			--5 bit vector going to control EXECUTION registers from stage to stage
			--ALU_func(4..1) & ALU_Bin_sel(0)
			DEC_EX_EX_in=>ALU_func & ALU_Bin_sel,				
			DEC_EX_WB_out=>dec_ex_ctrl_wb,
			DEC_EX_MEM_out=>dec_ex_ctrl_mem,
			DEC_EX_EX_out=>dec_ex_ctrl_ex,
			CLK=>CLK,
			Reset=>Reset);
			
--ex_mem control registers
execution_memory_control_registers:EX_MEM_control_regs
port map(EX_MEM_WB_in=>dec_ex_ctrl_wb,
			EX_MEM_MEM_in=>dec_ex_ctrl_mem,
			EX_MEM_WB_out=>ex_mem_ctrl_wb,
			EX_MEM_MEM_out=>ex_mem_ctrl_mem,
			CLK=>CLK,
			Reset=>Reset);

--mem_wb control registers
memory_writeBack_control_registers:MEM_WB_control_regs
port map(MEM_WB_WB_in=>ex_mem_ctrl_wb,
			MEM_WB_WB_out=>mem_wb_ctrl_wb,
			CLK=>CLK,
			Reset=>Reset);

--pc branch selection , calculates the pc selection			
pc_branch_sel:PC_Branch_selection
port map(b_sig=>ex_mem_ctrl_mem(4),--b
         beq_sig=>ex_mem_ctrl_mem(3),--beq
         bne_sig=>ex_mem_ctrl_mem(2),--bne
			alu_zero_sig=>ex_mem_alu_zero_out,
         branch_selection=>branch_out_top);
			
end Behavioral;

