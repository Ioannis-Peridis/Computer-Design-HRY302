-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY IFSTAGE_testBench IS
  END IFSTAGE_testBench;

  ARCHITECTURE behavior OF IFSTAGE_testBench IS 

 -- Component Declaration for the Unit Under Test (UUT)
          COMPONENT IFSTAGE
          PORT(PC_Immed : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
          END COMPONENT;

			 --Inputs
          SIGNAL PC_Immed :std_logic_vector(31 downto 0) := (others => '0');
          SIGNAL PC_sel :std_logic  := '0';
			 SIGNAL PC_LdEn :std_logic := '0';
			 SIGNAL Reset :std_logic := '0';
			 SIGNAL Clk :std_logic := '0';
			 --Outputs
			 SIGNAL PC:std_logic_vector(31 downto 0);
			 --clock period
			 constant CLK_period : time := 200 ns;
			 
  BEGIN

  --- Instantiate the Unit Under Test (UUT)
          uut: IFSTAGE PORT MAP(
                  PC_Immed=>PC_Immed,
						PC_sel=>PC_sel,
						PC_LdEn=>PC_LdEn,
						Reset=>Reset,
						Clk=>Clk,
						PC=>PC);
						
	-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;



	-- Stimulus process
     tb : PROCESS
     BEGIN
		  --hold rest state for 50 ns
        wait for 50 ns; 
		  --reset is activated ,so every output is initialized to zero
		  --PC=0
		  Reset<='1';
		  wait for CLK_period;
		  --reset is deactivated so we can see the outputs now
		  Reset<='0';
		  --load enable is activated & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=4 
		  PC_Immed<=x"0000000f";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is activated  & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=8
		  PC_Immed<=x"0000000f";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is deactivated , so we can not fetch an instruction and the PC remains the same
		  --PC same as before=8
		  PC_Immed<=x"0000000f";
		  PC_sel<='0';
		  PC_LdEn<='0';
		  wait for CLK_period;
		  --load enable is activated  & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=12
		  PC_Immed<=x"0000000a";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is activated & selector chooses to brunch to immediate value 15,so the next isntructions fetched is going to be immediate*4+4
		  --PC+15*4+4=76
		  PC_Immed<=x"0000000f";
		  PC_sel<='1';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  --load enable is activated & selector chooses to brunch to immediate value 88,so the next isntructions fetched is going to be immediate*4+4
		  --PC+88*4+4=432
		  PC_Immed<=x"00000058";
		  PC_sel<='1';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is deactivated , so we can not fetch an instruction and the PC remains the same
		  --PC=432
		  PC_Immed<=x"000000B3";
		  PC_sel<='1';
		  PC_LdEn<='0';
		  wait for CLK_period;
		  --load enable is activated  & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=436
		  PC_Immed<=x"0000000A";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is activated & selector chooses to brunch to immediate value 145,so the next isntructions fetched is going to be immediate*4+4
		  --PC+145*4+4=1020
		  PC_Immed<=x"00000091";
		  PC_sel<='1';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is activated  & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=1024
		  PC_Immed<=x"0000000A";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --load enable is activated  & selector chooses to fetch the next instruction(program counter increased by 4,immediate value dosent matter)
		  --PC+4=1028
		  --Thats and address that is not allowed , the instruction segment is between addresses 0-1024 so if 1024 is passed,
		  --then the PC is set to zero and w ecan not load more instructions
		  PC_Immed<=x"0000000A";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  --PC stays at 0, we can not load any more instructions
		  PC_Immed<=x"0000000A";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  wait for CLK_period;
		  
		  
		 
		  
		  
		  
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
