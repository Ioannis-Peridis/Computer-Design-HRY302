-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY IFSTAGE_RAM_testBench IS
  END IFSTAGE_RAM_testBench;

  ARCHITECTURE behavior OF IFSTAGE_RAM_testBench IS 

  -- Component Declaration
          COMPONENT IFSTAGE_RAM
          PORT(PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Instr : out  STD_LOGIC_VECTOR (31 downto 0));
          END COMPONENT;

          SIGNAL PC_sel :  std_logic := '0';
			 SIGNAL PC_LdEn :  std_logic := '0';
			 SIGNAL Reset :  std_logic := '0';
			 SIGNAL Clk :  std_logic := '0';
          SIGNAL PC_Immed :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL Instr :  std_logic_vector(31 downto 0);
			 constant CLK_period : time := 200 ns;


          
  BEGIN

  -- Component Instantiation
          uut: IFSTAGE_RAM PORT MAP(
			 PC_Immed=>PC_Immed,
			 PC_sel=>PC_sel,
			 PC_LdEn=>PC_LdEn,
			 Reset=>Reset,
			 Clk=>Clk,
			 Instr=>Instr
          );
			 
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

        wait for 50 ns; -- wait until global set/reset completes
		  PC_Immed<=x"00000000";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='1';
		  wait for CLK_period;
		  PC_Immed<=x"0000000a";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"0000000b";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"0000000c";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"0000000d";
		  PC_sel<='1';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"000000ff";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"00000001";
		  PC_sel<='1';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"000000fe";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"00000000";
		  PC_sel<='0';
		  PC_LdEn<='0';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"00000000";
		  PC_sel<='0';
		  PC_LdEn<='0';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"00000000";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
		  PC_Immed<=x"00000000";
		  PC_sel<='0';
		  PC_LdEn<='1';
		  Reset<='0';
		  wait for CLK_period;
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
