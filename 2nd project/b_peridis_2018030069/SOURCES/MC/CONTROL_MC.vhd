----------------------------------------------------------------------------------
-- Company: Technical University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    19:07:02 05/15/2021 
-- Design Name: 
-- Module Name:    CONTROL_MC - Behavioral 
-- Project Name: Organosi Ypologiston project2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the control of the multy cycle Control Process Unit:
--It is same as the control unit of the single cycle, but now we use an FSM to calculate the output signals of write enables 
--the FSM has 6 stages, according the instruciton, each state takes 1 clock cycle:
-- Rtype->:Instruction Fetch->Decode->Execution->Write Back->Instruction Fetch (4 clock cycles)
-- Branch->:Instruction Fetch->Decode->Execution->Instruction Fetch (3 clock cycles)
-- Load->:Instruction Fetch->Decode->Execution->Memory Read->Write Back->Instruction Fetch (5 clock cycles)
-- Store->:Instruction Fetch->Decode->Execution->Memory Write->Instruction Fetch (4 clock cycles)
entity CONTROL_MC is
Port ( 	  CLK : in  STD_LOGIC;
			  --Reset: reset every output to 0, active high
	 		  Reset : in  STD_LOGIC;
			  --PC_selector: selector that updates the value of the Program Counter
			  --	0->PC+4
			  --	1->(PC+4)+ConvertedImmed*4
			  PC_sel_control_mc : out  STD_LOGIC;
			  --PC Load Enable(registartion activation of PC)
			  PC_LdEn_control_mc : out  STD_LOGIC;
			   --Immediate extender:selector of the extension of the immediate
			  --	00->zero-fill(Immediate)
			  --	01->SignExtend(Immediate)
			  --	10->Immediate shift logical left 16 & zero-fill
			  --	11->SignExtend(Immediate) & shift logical left 2
			  ImmExt_control_mc : out  STD_LOGIC_VECTOR (1 downto 0);
			  --Register File_write data_selector:selector of the datasource for registration
			  -- 0->ALU
			  -- 1->MEM
			  RF_WrData_sel_control_mc : out  STD_LOGIC;
			  --RF B_selector:selector of the second read register
			  -- 0->Instr(15-11) rt
 			  -- 1->Instr(20-16) rd
			  RF_B_sel_control_mc : out  STD_LOGIC;
			  --RF_write enable: registartion activation of RF
			  RF_WrEn_control_mc : out  STD_LOGIC;
			  --ALU_B input_selector:selector of the second operand of the ALU
			  -- 0->RF_B
			  -- 1->Immed
			  ALU_Bin_sel_control_mc : out  STD_LOGIC;
			  --ALU _function:ALU operation
			  ALU_func_control_mc : out  STD_LOGIC_VECTOR (3 downto 0);
			  --Byte operation:selector if the load/store is on byte or word
			  -- 0->lw/sw
			  -- 1->lb/sb
			  ByteOp_control_mc : out  STD_LOGIC;
			  --MEM_write enable:registartion activation of MEM
			  MEM_WrEn_control_mc : out  STD_LOGIC;
			  --instruction
           Instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
			   --ALU zero output:zero flag of ALU output
			  ALU_zero_control_mc: in STD_LOGIC;
			  --registers write enables 			  
			  IR_WrEn_control_mc: out  STD_LOGIC; 			  
			  ALUR_WrEn_control_mc: out  STD_LOGIC; 			  
			  MDR_WrEn_control_mc: out  STD_LOGIC; 			  
			  RF_AR_WrEn_control_mc: out  STD_LOGIC; 			  
			  RF_BR_WrEn_control_mc: out  STD_LOGIC; 			  
			  ImmedR_WrEn_control_mc: out  STD_LOGIC);

end CONTROL_MC;

architecture Behavioral of CONTROL_MC is

--Creation of a new state type
--These are the 6 states of the Finite State Machine
TYPE  state_type IS (InstructionFetch,Decode,Execute,MemoryRead,MemoryWrite,WriteBack);
SIGNAL state:state_type;
--signals opcode and function
signal OPCODE,func:std_logic_vector(5 downto 0);

begin
--synchronous process , input is clock
process(CLK) is
begin
--when case, for all the different values the opcode can take
	case OPCODE is
		when "100000" =>
			--rt second read register
			--RF_B second ALU operand
			--ALU data source 			
			ImmExt_control_mc<="00"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='0'; 			
			ALU_Bin_sel_control_mc<='0'; 			
			--NESTED when case, for all the different operations between 2 registers(or 1 by itself), that can be supported by the ALU 			
			case func is 				
			--ADDITION: RF[rd]<-RF[rs]+RF[rt] 				
			when "110000" => 				  
			ALU_func_control_mc<="0000";   				
			--SUBSTRACTION: RF[rd]<-RF[rs]-RF[rt]  				
			when "110001" => 				  
			ALU_func_control_mc<="0001"; 				
			--AND: RF[rd]<-RF[rs] AND RF[rt] 				
			when "110010" => 				  
			ALU_func_control_mc<="0010"; 			  
			--OR: RF[rd]<-RF[rs] | RF[rt] 				
			when "110011" => 				  
			ALU_func_control_mc<="0011";	 				
			--NOT: RF[rd]<-!RF[rs] 				
			when "110100" => 				  
			ALU_func_control_mc<="0100";				 				
			--NAND: RF[rd]<-RF[rs] NAND RF[rt] 				
			when "110101" => 				  
			ALU_func_control_mc<="0101"; 				
			--NOR: RF[rd]<-RF[rs] NOR RF[rt] 				
			when "110110" => 				  
			ALU_func_control_mc<="0110"; 				
			--SHIFT RIGHT ARITHMETIC: RF[rd]<-RF[rs] >>1 				
			when "111000" =>				 				  
			ALU_func_control_mc<="1000"; 				
			--SHIFT RIGHT LOGICAL: RF[rd]<-RF[rs] >>1 (Logical, zero fill MSB) 				
			when "111001" =>			 				  
			ALU_func_control_mc<="1001"; 				
			--SHIFT LEFT LOGICAL: RF[rd]<-RF[rs] <<1 (Logical, zero fill LSB) 				
			when "111010" =>				 				  
			ALU_func_control_mc<="1010"; 				
			--ROTATE LEFT: RF[rd]<-Rotate left(RF[rs]) 				
			when "111100" =>					 				  
			ALU_func_control_mc<="1100"; 				
			--ROTATE RIGHT: RF[rd]<-Rotate right(RF[rs]) 				
			when "111101" =>					 				  
			ALU_func_control_mc<="1101"; 				
			--in case the given function does not match to any of the above ALU's operation,set the operation to zero  
			when others =>			
			ALU_func_control_mc<="0000";	  
		end case;
			ByteOp_control_mc<='0';
		
		--LOAD IMMEDIATE(loads the last 16 bits)
		--Its actually addition immediate with the zero register: RF[rd]<-RF[r0]+SignExtend(Imm)
		when "111000" =>
			--ALU data source 			
			--Immed second ALU operand 			
			--ImmExt<-signExtend(Imm) 			
			--ALU operation<-ADDITION 			
			ImmExt_control_mc<="01"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='0';
			--LOAD UPPER IMMEDIATE(loads the first 16 bits) 		
			--Its the same thing with the li, with the only difference at the Immediate Extender 		
			--RF[rd]<-RF[r0]+(Imm<<16(zero-fill)) 		
		when "111001" =>	 			
			ImmExt_control_mc<="10"; 		   
			RF_WrData_sel_control_mc<='0'; 
		   RF_B_sel_control_mc<='1'; 
			ALU_Bin_sel_control_mc<='1';
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='0';
		
		--ADDITION IMMEDIATE
		--RF[rd]<-RF[rs]+SignExtend(Imm)
		when "110000" =>
			--ALU data source 			
			--Immed second ALU operand 			
			--ImmExt<-signExtend(Imm) 			
			--ALU operation<-ADDITION 			
			ImmExt_control_mc<="01"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='0';
		
		--NAND IMMEDIATE
		--RF[rd]<-RF[rs] NAND ZeroFill(Imm)
		when "110010" =>
			--ALU data source 			
			--Immed second ALU operand 			
			--ImmExt<-zeroFill(Imm) 			
			--ALU operation<-NAND 			
			ImmExt_control_mc<="00"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0101";
			ByteOp_control_mc<='0';
	
		--OR IMMEDIATE
		--RF[rd]<-RF[rs] | ZeroFill(Imm)
		when "110011" =>
			--ALU data source
			--Immed second ALU operand
			--ImmExt<-zeroFill(Imm)
			--ALU operation<-OR
    		ImmExt_control_mc<="00";
		   RF_WrData_sel_control_mc<='0'; 
		   RF_B_sel_control_mc<='1'; 
			ALU_Bin_sel_control_mc<='1';
			ALU_func_control_mc<="0011";
			ByteOp_control_mc<='0';

		--BRANCH
		when "111111" =>
			--ImmExt<-(SignExtend(Imm) << 2
			--rd second read registe
			ImmExt_control_mc<="11";
		   RF_WrData_sel_control_mc<='0'; 
		   RF_B_sel_control_mc<='1';
			ALU_Bin_sel_control_mc<='0';
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='0';
		
		--BRANCH IF EQUAL	
		--Its actually subbstraction RF[rs]-RF[rd] and if the reuslt its zero we brunch else not
		when "000000" =>
			--rd second read register 			
			--ALU operation<-SUBSTRACTION 			
			--RF_B second ALU operand 			
			ImmExt_control_mc<="11"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='0'; 			
			ALU_func_control_mc<="0001"; 			
			ByteOp_control_mc<='0';
		
		--BRANCH IF NOT EQUAL
		--Its actually subbstraction RF[rs]-RF[rd] and if the reuslt its NOT zero we brunch else not
		when "000001" =>
			--rd second read register 			
			--ALU operation<-SUBSTRACTION 			
			--RF_B second ALU operand 			
			ImmExt_control_mc<="11"; 		   
			RF_WrData_sel_control_mc<='0';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='0'; 			
			ALU_func_control_mc<="0001"; 			
			ByteOp_control_mc<='0';

		--LOAD BYTE: load a byte from memeory to the rf
		--RF[rd]<-ZeroFill(31 downto 8) & MEM[RF[rs] +SignExtend(Imm)](7 downto 0)
		when "000011" =>
			--Immed second ALU operand 			
			--Byte operation->byte 			
			--ImmExt<-SignExtend(Imm) 			
			--ALU operation<-ADDITION 			
			ImmExt_control_mc<="01"; 		   
			RF_WrData_sel_control_mc<='1';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='1';
		
		--STORE BYTE : store a byte to the memory from the rf
      --MEM[RF[rs] + SignExtend(Imm)]<-ZeroFill(31 downto 8) & RF[rd](7 downto 0)	
		when "000111" =>
			--Byte operation->byte 			
			--Immed second ALU operand 			
			--ImmExt<-SignExtend(Imm) 			
			--ALU operation<-ADDITION 			
			ImmExt_control_mc<="01"; 		   
			RF_WrData_sel_control_mc<='1';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0000";
			ByteOp_control_mc<='1';
		
		--LOAD WORD :  load a word (4 bytes) from memeory to the rf
		--RF[rd]<-MEM[RF[rs] + SignExtend(Imm)]
		when "001111" =>
			--Byte operation->word 			
			--Immed second ALU operand 			
			--ImmExt<-SignExtend(Imm) 			
			--ALU operation<-ADDITION 		   
			RF_WrData_sel_control_mc<='1';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_Bin_sel_control_mc<='1'; 			
			ALU_func_control_mc<="0000"; 			
			ByteOp_control_mc<='0';
		
		--STORE WORD : store a word(4 bytes) to the memory from the rf
		--MEM[RF[rs] + SignExtend(Imm)]<-RF[rd]
		when "011111" =>
			--Immed second ALU operand 			
			--Byte operation->word 			
			--ImmExt<-SignExtend(Imm) 			
			--ALU operation<-ADDITION 			
			ImmExt_control_mc<="01"; 		   
			RF_WrData_sel_control_mc<='1';  		   
			RF_B_sel_control_mc<='1';  			
			ALU_func_control_mc<="0000"; 			
			ALU_Bin_sel_control_mc<='1';
			ByteOp_control_mc<='0';
		
		--in case the given opcode does not match any of the above opcode operations,set all the outputs to zero		 		
	   when others => 			
		  ImmExt_control_mc<="00"; 		   
		  RF_WrData_sel_control_mc<='0';  		   
		  RF_B_sel_control_mc<='0';  			
		  ALU_Bin_sel_control_mc<='0'; 			
		  ALU_func_control_mc<="0000"; 			
		  ByteOp_control_mc<='0';	 	
	   end case; 
		
		--if reset is active set every output to zero 
if Reset='1' then       
		ImmExt_control_mc<="00"; 		
		ALU_func_control_mc<="0000"; 		
		RF_WrData_sel_control_mc<='0';  		
		RF_B_sel_control_mc<='0'; 	 		
		ByteOp_control_mc<='0'; 		
		PC_LdEn_control_mc<='1'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 	   
		IR_WrEn_control_mc<='1'; 		
		ALU_Bin_sel_control_mc<='0'; 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0';
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
	   state<=InstructionFetch;
else
--if reset is not active
--if the rising edge of the clock comes	   		
if rising_edge(CLK) then
	--THIS IS THE FSM FOR THE STATES OF 
	CASE state IS
		--INSTRUCTION FETCH state
		--PC load enable is active, PC+4 or PC+4*immediate
		--Instruciton register is active
		--next state decode 		
		WHEN InstructionFetch=> 
		
		OPCODE<=Instr_in(31 downto 26); 		
		func<=Instr_in(5 downto 0);
		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='0';	 		
		MEM_WrEn_control_mc<='0';
		ALUR_WrEn_control_mc<='0';
		MDR_WrEn_control_mc<='0';
		RF_AR_WrEn_control_mc<='1';
		RF_BR_WrEn_control_mc<='1';
		ImmedR_WrEn_control_mc<='1';
		state<=Decode;
		
		--INSTRUCTION DECODE state
		--RF_A ,RF_B and immediate registers are active
		--next state execute 		
		WHEN Decode=>
  		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='0';	 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='1'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=Execute;
		
		--EXECUTION state
		--It is devided to 4 formats,-> BRANCH or->MEMORY LOAD or->MEMORY STORE or ->WRITE BACK
		WHEN Execute=>
		--BRANCH, BRANCH EQUAL , BRANCH NOT EQUAL instructions
		--next state instruction fetch 		
		if (OPCODE="000000" OR OPCODE="111111" OR  OPCODE="000001") then 		
		RF_WrEn_control_mc<='0'; 
		PC_LdEn_control_mc<='1'; 	
		IR_WrEn_control_mc<='1';	 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=InstructionFetch;
		
		--BRANCH PC+4*Immediate
		if OPCODE="000000" then
			PC_sel_control_mc<='1';
		--BRANCH IF EQUAL 
		--if (RF[rs] == RF[rd])
		--  PC<-PC + 4 + (SignExtend(Imm) << 2)
		--else
		--  PC<-PC + 4
		elsif OPCODE="111111" then 
			if(ALU_zero_control_mc='1') then
			PC_sel_control_mc<='1';
			else
			PC_sel_control_mc<='0';
			end if;
		--BRANCH IF NOT EQUAL
		--if (RF[rs] != RF[rd])
		--  PC<-PC + 4 + (SignExtend(Imm) << 2)
		--else
		--  PC<-PC + 4
		elsif OPCODE="000001" then
			if(ALU_zero_control_mc='0') then
			PC_sel_control_mc<='1';
			else
			PC_sel_control_mc<='0';
			end if;
		end if;
		
		--LOAD BYTE and LOAD WORD instructions
		--next state memory read 		
		elsif(OPCODE="000011" OR OPCODE="001111") then 		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='0';	 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='1';
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=MemoryRead;
		
		--STORE BYTE and STORE WORD instructions
		--next state memory write 		
		elsif (OPCODE="000111" OR OPCODE="011111") then  		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='0'; 		
		MEM_WrEn_control_mc<='1'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0';
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=MemoryWrite;
		
		--Rtype instructions(every alu operations)
		--next state write back 		
		elsif (OPCODE="100000" OR OPCODE="111000" OR  OPCODE="111001" OR OPCODE="110000" OR OPCODE="110010" OR OPCODE="110011") then  		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='1'; 		
		IR_WrEn_control_mc<='0';	
		MEM_WrEn_control_mc<='0';
		ALUR_WrEn_control_mc<='0';
		MDR_WrEn_control_mc<='0';
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='1';
		state<=WriteBack;
		end if;

		--WRITE BACK
		--RF write enable is active
		--next state instruction fetch 		
		WHEN WriteBack=>
		
		PC_LdEn_control_mc<='1'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='1'; 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=InstructionFetch;
		
		--MEMORY READ
		--Memory Data register is active
		--next state write back 		
		WHEN MemoryRead=> 
		
		PC_LdEn_control_mc<='0'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='1'; 		
		IR_WrEn_control_mc<='0'; 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='1';
		state<=WriteBack;
		
		--MEMORY WRITE
		--memory write is enabled
		--next state instruction fetch
		WHEN MemoryWrite=>
		
	   PC_LdEn_control_mc<='1'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='1';	 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0'; 		
		RF_BR_WrEn_control_mc<='0';
		ImmedR_WrEn_control_mc<='0';
		state<=InstructionFetch;
		
		--in every other case go to instruction fetch
		WHEN OTHERS=>
		
		PC_LdEn_control_mc<='1'; 		
		PC_sel_control_mc<='0'; 		
		RF_WrEn_control_mc<='0'; 		
		IR_WrEn_control_mc<='1'; 		
		MEM_WrEn_control_mc<='0'; 		
		ALUR_WrEn_control_mc<='0'; 		
		MDR_WrEn_control_mc<='0'; 		
		RF_AR_WrEn_control_mc<='0'; 		
		ImmedR_WrEn_control_mc<='0';
		RF_BR_WrEn_control_mc<='0';
		state<=InstructionFetch;
	END CASE;
	
	 end if;	 
end if;	 
end process;
end Behavioral;

