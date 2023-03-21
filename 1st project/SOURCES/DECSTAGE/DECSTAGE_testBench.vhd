-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY DECSTAGE_testBench IS
  END DECSTAGE_testBench;

  ARCHITECTURE behavior OF DECSTAGE_testBench IS 

  -- Component Declaration
          COMPONENT DECSTAGE
          PORT(Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  Reset: in  STD_LOGIC);
          END COMPONENT;

			 SIGNAL RF_WrEn :  std_logic := '0';
			 SIGNAL RF_WrData_sel :  std_logic := '0';
			 SIGNAL RF_B_sel :  std_logic := '0';
			 SIGNAL Clk :  std_logic := '0';
			 SIGNAL Reset :  std_logic := '0';
          SIGNAL Instr :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL ALU_out :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL MEM_out :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL ImmExt :  std_logic_vector(1 downto 0):= (others => '0');
			 SIGNAL Immed :  std_logic_vector(31 downto 0);
			 SIGNAL RF_A :  std_logic_vector(31 downto 0);
			 SIGNAL RF_B :  std_logic_vector(31 downto 0);
			 constant CLK_period : time := 200 ns;		
			
			
			 BEGIN

  -- Component Instantiation
          uut: DECSTAGE PORT MAP(
                  Instr=>Instr,
						RF_WrEn=>RF_WrEn,
						ALU_out=>ALU_out,
						MEM_out=>MEM_out,
						RF_WrData_sel=>RF_WrData_sel,
						RF_B_sel=>RF_B_sel,
						ImmExt=>ImmExt,
						Clk=>Clk,
						Immed=>Immed,
						RF_A=>RF_A,
						RF_B=>RF_B,
						Reset=>Reset);
						
	-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;


  --  Test Bench Statements
     tb : PROCESS
     BEGIN
		wait for 210ns;--wait for 210 ns so there is no problem with the timming diagrams
		--activate reset to intialize all the outputs to 0
		Reset<='1';
		wait for CLK_period;
		--reset is inactive now, so we can see the outputs
		Reset<='0';
		
		--at first we are testing the first type of instructions format ** opcode_rs_rd_rt_NotUsed_func **
		--the instructions below will have RB_sel=0, that means that the second read register is going ot be the rt register
		--for now we dont care about the ImmExt we are going to test it later
		--=======================================================
		--data source is coming from alu output, rf_wrData=0
		--write is enabled=1 so i can write
		
		Instr<=B"000000_00001_00011_00010_00000_000000";
		--read rs=r1 ,its value=0 
		--read rt=r2 ,its value=0 
		--write value=9 to rd=r3
      RF_WrEn<='1';			
		ALU_out<=x"00000009";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';  
		RF_B_sel<='0';			
		wait for CLK_period;
		Instr<=B"000000_00011_00100_00010_00000_000000";
		--read rs=r3 ,its value=9 
		--read rt=r2 ,its value=0 
		--write value=4 to rd=r4
      RF_WrEn<='1';			
		ALU_out<=x"00000004";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';	
		RF_B_sel<='0';			
		wait for CLK_period;
		Instr<=B"000000_00101_00101_00100_00000_000000";
		--read rs=r5 ,its value=15 after rising edge, 0 before rising edge
		--read rt=r4 ,its value=4 
		--write value=15 to rd=r5
      RF_WrEn<='1';
		ALU_out<=x"0000000f";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='0';
		wait for CLK_period;
		----------------------------------------------------------
		--write is unenabled=0 so i cant write
		
		Instr<=B"000000_00101_00101_00011_00000_000000";
		--read rs=r5 ,its value=15 STAYS 15 for the hall time because i can not write 
		--read rt=r3 ,its value=9 
		--CANT write value=255 to rd=r5,so value=15 as before
      RF_WrEn<='0';
		ALU_out<=x"000000ff";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='0';
		wait for CLK_period;
		----------------------------------------------------------
		--data source is coming from memory output, rf_wrData=1
		--write is enabled=1 so i can write
		
		Instr<=B"000000_01000_00111_00111_00000_000000";
		--read rs=r8 ,its value=0 
		--read rt=r7 ,its value=10 after rising edge, 0 before rising edge
		--write value=10 to rd=r7
      RF_WrEn<='1';
		ALU_out<=x"00000003";
		MEM_out<=x"0000000a";
		RF_WrData_sel<='1';
		RF_B_sel<='0';
		wait for CLK_period;
		Instr<=B"000000_00111_00100_00100_00000_000000";
		--read rs=r7 ,its value=10 
		--read rt=r8 ,its value=254 after rising edge, 4 before rising edge
		--write value=254 to rd=r8
      RF_WrEn<='1';
		ALU_out<=x"00000003";
		MEM_out<=x"000000fe";
		RF_WrData_sel<='1';
		RF_B_sel<='0';
		wait for CLK_period;
		----------------------------------------------------------
		--write is unenabled=0 so i cant write
		
		Instr<=B"000000_00100_00100_01100_00000_000000";
		--read rs=r8 ,its value=254 STAYS 15 for the hall time because i can not write 
		--read rt=r12 ,its value=0 
		--CANT write value=1 to rd=r8,so value=254 as before
      RF_WrEn<='0';
		ALU_out<=x"00000003";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='0';
		wait for CLK_period;
		
		--now we are testing the second type of instructions format ** opcode_rs_rd_rt_immediate **
		--the instructions below will have RB_sel=1, that means that the second read register is going ot be the rd register
		--now we are also going to test the all the different immediate extender cases 
		--=======================================================
		--data source is coming from alu output, rf_wrData=0
		--write is enabled=1 so i can write
		
		Instr<=B"000000_00011_00111_1000000000000111";
		--read rs=r3 ,its value=9 
		--read rt=r7 ,its value=3 after rising edge, 10 before rising edge
		--write value=3 to rd=r7
		--immediate zero-fill
      RF_WrEn<='1';
		ALU_out<=x"00000003";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='1';
		ImmExt<="00";
		wait for CLK_period;
		Instr<=B"000000_00111_01111_1000000000000111";
		--read rs=r7 ,its value=3 
		--read rt=r15 ,its value=254 after rising edge, 0 before rising edge
		--write value=254 to rd=r15
		--immediate sign-extension(sign=1)
      RF_WrEn<='1';
		ALU_out<=x"000000fe";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='1';
		ImmExt<="01";
		wait for CLK_period;
		----------------------------------------------------------
		--write is unenabled=0 so i cant write
		
		Instr<=B"000000_00101_01111_1000000000000111";
		--read rs=r5 ,its value=15 
		--read rt=r15 ,its value=254 STAYS 254 for the hall time because i can not write 
		--CANT write value=1 to rd=r15,so value=254 as before
		--immediate logical shift left 16+ zero-fill
      RF_WrEn<='0';
		ALU_out<=x"00000003";
		MEM_out<=x"00000001";
		RF_WrData_sel<='0';
		RF_B_sel<='1';
		ImmExt<="10";
		wait for CLK_period;
		
		---------------------------------------------------------
		--data source is coming from memory output, rf_wrData=1
		--write is enabled=1 so i can write
		
		Instr<=B"000000_10001_11111_0000000000000111";
		--read rs=r17 ,its value=0 
		--read rt=r31 ,its value=13 after rising edge, 0 before rising edge
		--write value=13 to rd=r31
		--immediate sign-extension(sign=0)
      RF_WrEn<='1';
		ALU_out<=x"00000003";
		MEM_out<=x"0000000d";
		RF_WrData_sel<='1';
		RF_B_sel<='1';
		ImmExt<="01";
		wait for CLK_period;
		Instr<=B"000000_11111_00100_1000000000000111";
		--read rs=r31 ,its value=13
		--read rt=r8 ,its value=1399 after rising edge, 254 before rising edge
		--write value=1399 to rd=r8
		--immediate sign-extension(sign=1)+ shift logical left 2
      RF_WrEn<='1';
		ALU_out<=x"00000003";
		MEM_out<=x"00000577";
		RF_WrData_sel<='1';
		RF_B_sel<='1';
		ImmExt<="11";--sign extend +shift 2
		wait for CLK_period;
		----------------------------------------------------------
		--write is unenabled=0 so i cant write
		
		Instr<=B"000000_00100_00100_0000000000000111";
		--cant write read 8 and read 8 same =1399
		--read rs=r8 ,its value=1399
		--read rt=r8 ,its value=1399 STAYS 1399 for the hall time because i can not write 
		--CANT write value=1 to rd=r8,so value=1399 as before
		--immediate sign-extension(sign=1)+ shift logical left 2
      RF_WrEn<='0';
		ALU_out<=x"00000003";
		MEM_out<=x"00000001";
		RF_WrData_sel<='1';
		RF_B_sel<='1';
		ImmExt<="11";
		wait for CLK_period;
		
		
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
