----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    21:47:03 04/13/2021 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
-- Project Name: Organosi Ypologiston project1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the control of the single cycle Control Process Unit:
--Control is the hardware that tells the datapath what to do, in terms of switching, operation selection, data movement between the components of the 4 stages of datapath
--control, creates and sends signals to the datapath, so it will operate as told from the control
entity CONTROL is
    Port ( 
			  --PC_selector: selector that updates the value of the Program Counter
			  --	0->PC+4
			  --	1->(PC+4)+ConvertedImmed*4
           PC_sel_control : out  STD_LOGIC;
			  --PC Load Enable(registartion activation of PC)
           PC_LdEn_control : out  STD_LOGIC;
			  
			  --Immediate extender:selector of the extension of the immediate
			  --	00->zero-fill(Immediate)
			  --	01->SignExtend(Immediate)
			  --	10->Immediate shift logical left 16 & zero-fill
			  --	11->SignExtend(Immediate) & shift logical left 2
			  ImmExt_control : out  STD_LOGIC_VECTOR (1 downto 0);
			  --Register File_write data_selector:selector of the datasource for registration
			  -- 0->ALU
			  -- 1->MEM
           RF_WrData_sel_control : out  STD_LOGIC;
			  --RF B_selector:selector of the second read register
			  -- 0->Instr(15-11) rt
 			  -- 1->Instr(20-16) rd
           RF_B_sel_control : out  STD_LOGIC;
			  --RF_write enable: registartion activation of RF
           RF_WrEn_control : out  STD_LOGIC;
			  
			  --ALU_B input_selector:selector of the second operand of the ALU
			  -- 0->RF_B
			  -- 1->Immed
           ALU_Bin_sel_control : out  STD_LOGIC;
			  --ALU _function:ALU operation
           ALU_func_control : out  STD_LOGIC_VECTOR (3 downto 0);
			  --ALU zero output:zero flag of ALU output
			  ALU_zero_control: in STD_LOGIC;
			  
			  --Byte operation:selector if the load/store is on byte or word
			  -- 0->lw/sw
			  -- 1->lb/sb
			  ByteOp_control : out  STD_LOGIC;
			  --MEM_write enable:registartion activation of MEM
           MEM_WrEn_control : out  STD_LOGIC;
			  
			  --Instruction input: 32 bit instruction, that contains all the infromation
           Instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  --Reset: reset every output to 0, active high
			  Reset : in  STD_LOGIC);
			  
end CONTROL;

architecture Behavioral of CONTROL is

--integral signals to help calculate the outputs
signal OPCODE,func:std_logic_vector(5 downto 0);

begin

--initialization of:
--Opcode->first 6 bits of the instruction
OPCODE<=Instr_in(31 downto 26);
--Function->last 6 bits of the instruction
func<=Instr_in(5 downto 0);

--process that changes the inputs if at least one of those 4 arguments change
--OPCODE, func, reset or ALU_zero
control_process:process(OPCODE,func,Reset,ALU_zero_control)
--**PC_LdEn output,idealy it must be always activated to 1,because in every cycle we run a different instruction(without skeeping any cycles)**
begin
--if reset=0(inactive, then continue with the operations)
if(Reset='0') then
	--when case, for all the different values the opcode can take
	case OPCODE is
		--operation between two registers
		when "100000" =>
			--PC+4
			--ALU data source
			--RF_B second ALU operand
			--rt second read register
			--RF write is enabled
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="00";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='0'; 
  		   RF_WrEn_control<='1'; 
			
			--NESTED when case, for all the different operations between 2 registers(or 1 by itself), that can be supported by the ALU
			ALU_Bin_sel_control<='0';
			case func is
				--ADDITION: RF[rd]<-RF[rs]+RF[rt]
				when "110000" =>
				  ALU_func_control<="0000";  
				--SUBSTRACTION: RF[rd]<-RF[rs]-RF[rt] 
				when "110001" =>
				  ALU_func_control<="0001";
				--AND: RF[rd]<-RF[rs] AND RF[rt]
				when "110010" =>
				  ALU_func_control<="0010";
			   --OR: RF[rd]<-RF[rs] | RF[rt]
				when "110011" =>
				  ALU_func_control<="0011";	
				--NOT: RF[rd]<-!RF[rs]
				when "110100" =>
				  ALU_func_control<="0100";				
				--NAND: RF[rd]<-RF[rs] NAND RF[rt]
				when "110101" =>
				  ALU_func_control<="0101";
				--NOR: RF[rd]<-RF[rs] NOR RF[rt]
				when "110110" =>
				  ALU_func_control<="0110";
				--SHIFT RIGHT ARITHMETIC: RF[rd]<-RF[rs] >>1
				when "111000" =>				
				  ALU_func_control<="1000";
				--SHIFT RIGHT LOGICAL: RF[rd]<-RF[rs] >>1 (Logical, zero fill MSB)
				when "111001" =>			
				  ALU_func_control<="1001";
				--SHIFT LEFT LOGICAL: RF[rd]<-RF[rs] <<1 (Logical, zero fill LSB)
				when "111010" =>				
				  ALU_func_control<="1010";
				--ROTATE LEFT: RF[rd]<-Rotate left(RF[rs])
				when "111100" =>					
				  ALU_func_control<="1100";
				--ROTATE RIGHT: RF[rd]<-Rotate right(RF[rs])
				when "111101" =>					
				  ALU_func_control<="1101";
				--in case the given function does not match to any of the above ALU's operation,set the operation to zero  
				when others =>			
				  ALU_func_control<="0000";	  
			end case;
		   
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--LOAD IMMEDIATE(loads the last 16 bits)
		--Its actually addition immediate with the zero register: RF[rd]<-RF[r0]+SignExtend(Imm)
		--the convention applies that the register zero must be always at the value zero ,and cant be changed
		--=============================================================================================================================================
		--###so when this instruction is going to run we must set the value of rs equal to the value of r0,so zero.Must be set with RF[rs]=RF[r0]=0 ###
		--=============================================================================================================================================
		when "111000" =>
			--PC+4
			--ALU data source
			--Immed second ALU operand
			--RF write is enabled
			--ImmExt<-signExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--LOAD UPPER IMMEDIATE(loads the first 16 bits)
		--Its the same thing with the li, with the only difference at the Immediate Extender
		--RF[rd]<-RF[r0]+(Imm<<16(zero-fill))
		when "111001" =>	
			--PC+4
			--ALU data source
			--Immed second ALU operand
			--RF write is enabled
			--ImmExt->ImmExt<-Imm<<16(zero-fill)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="10";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--ADDITION IMMEDIATE
		--RF[rd]<-RF[rs]+SignExtend(Imm)
		when "110000" =>
			--PC+4
			--ALU data source
			--Immed second ALU operand
			--RF write is enabled
			--ImmExt<-signExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--NAND IMMEDIATE
		--RF[rd]<-RF[rs] NAND ZeroFill(Imm)
		when "110010" =>
			--PC+4
			--ALU data source
			--Immed second ALU operand
			--RF write is enabled
			--ImmExt<-zeroFill(Imm)
			--ALU operation<-NAND
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="00";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0101";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
	
		--OR IMMEDIATE
		--RF[rd]<-RF[rs] | ZeroFill(Imm)
		when "110011" =>
			--PC+4
			--ALU data source
			--Immed second ALU operand
			--RF write is enabled
			--ImmExt<-zeroFill(Imm)
			--ALU operation<-OR
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="00";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0011";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--BRUNCH
		when "111111" =>
			--PC<-PC + 4 + (SignExtend(Imm) << 2
			--ImmExt<-(SignExtend(Imm) << 2
			--rd second read register
			--RF write is unenabled
			--every other output not associated set to 0
			PC_sel_control<='1';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="11";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1';
  		   RF_WrEn_control<='0';
			
			ALU_Bin_sel_control<='0';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--BRUNCH IF EQUAL
		--Its actually subbstraction RF[rs]-RF[rd] and if the reuslt its zero we brunch else not
		when "000000" =>
			-- if (RF[rs] == RF[rd])
			--	  PC<-PC + 4 + (SignExtend(Imm) << 2)
			-- else
			--	  PC<-PC + 4
			--RF write is unenabled
			--rd second read register
			--ALU operation<-SUBSTRACTION
			--RF_B second ALU operand
			--every other output not associated set to 0
			ImmExt_control<="11";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='0';

			ALU_Bin_sel_control<='0';
			ALU_func_control<="0001";
			
			--if the result of the substraction is 0 then the alu_zero will be 1
			if(ALU_zero_control='1') then
			PC_sel_control<='1';
			--else if the result of the substarction is not 0,alu_zero will be 0
			else
			PC_sel_control<='0';
			end if;
			PC_LdEn_control<='1';
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--BRUNCH IF NOT EQUAL
		--Its actually subbstraction RF[rs]-RF[rd] and if the reuslt its NOT zero we brunch else not
		when "000001" =>
			-- if (RF[rs] != RF[rd])
			--	  PC<-PC + 4 + (SignExtend(Imm) << 2)
			-- else
			--	  PC<-PC + 4
			--RF write is unenabled
			--rd second read register
			--ALU operation<-SUBSTRACTION
			--RF_B second ALU operand
			--every other output not associated set to 0
			ImmExt_control<="11";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='0';

			ALU_Bin_sel_control<='0';
			ALU_func_control<="0001";
			
			--if the result of the substraction is NOT 0 then the alu_zero will be 1
			if(ALU_zero_control='0') then
			PC_sel_control<='1';
			else
			--else if the result of the substarction is 0,alu_zero will be 0
			PC_sel_control<='0';
			end if;
			PC_LdEn_control<='1';
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
		--LOAD BYTE: load a byte from memeory to the rf
		--RF[rd]<-ZeroFill(31 downto 8) & MEM[RF[rs] +SignExtend(Imm)](7 downto 0)
		when "000011" =>
			--PC+4
			--RF write is enabled
			--Immed second ALU operand
			--Byte operation->byte
			--MEM write enable is unenabled
			--ImmExt<-SignExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='1'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='1';
			MEM_WrEn_control<='0';
		
		--STORE BYTE : store a byte to the memory from the rf
      --MEM[RF[rs] + SignExtend(Imm)]<-ZeroFill(31 downto 8) & RF[rd](7 downto 0)		
		when "000111" =>
			--PC+4
			--RF write is unenabled
			--Byte operation->byte
			--Immed second ALU operand
			--MEM write enable is enabled
			--ImmExt<-SignExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='1'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='0';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='1';
			MEM_WrEn_control<='1';
		
		--LOAD WORD :  load a word (4 bytes) from memeory to the rf
		--RF[rd]<-MEM[RF[rs] + SignExtend(Imm)]
		when "001111" =>
			--PC+4
			--RF write is enabled
			--Byte operation->word
			--Immed second ALU operand
			--MEM write enable is unenabled
			--ImmExt<-SignExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='1'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='1';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
		
      --STORE WORD : store a word(4 bytes) to the memory from the rf
		--MEM[RF[rs] + SignExtend(Imm)]<-RF[rd]
		when "011111" =>
			--PC+4
			--RF write is unenabled
			--Immed second ALU operand
			--Byte operation->word
			--MEM write enable is enabled
			--ImmExt<-SignExtend(Imm)
			--ALU operation<-ADDITION
			--every other output not associated set to 0
			PC_sel_control<='0';
			PC_LdEn_control<='1'; 
			
			ImmExt_control<="01";
		   RF_WrData_sel_control<='1'; 
		   RF_B_sel_control<='1'; 
  		   RF_WrEn_control<='0';
			
			ALU_Bin_sel_control<='1';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='1';
			
		--in case the given opcode does not match any of the above opcode operations,set all the outputs to zero
		when others =>
			PC_sel_control<='0';
			PC_LdEn_control<='0'; 
			
			ImmExt_control<="00";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='0'; 
  		   RF_WrEn_control<='0';
			
			ALU_Bin_sel_control<='0';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
	end case;	
else
--if reset=1(active , then set every output to zero)
			PC_sel_control<='0';
			PC_LdEn_control<='0'; 
			
			ImmExt_control<="00";
		   RF_WrData_sel_control<='0'; 
		   RF_B_sel_control<='0'; 
  		   RF_WrEn_control<='0';
			
			ALU_Bin_sel_control<='0';
			ALU_func_control<="0000";
			
			ByteOp_control<='0';
			MEM_WrEn_control<='0';
end if;
end process control_process;
end Behavioral;

