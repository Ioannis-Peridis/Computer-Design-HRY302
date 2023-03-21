-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY EXSTAGE_testBench IS
  END EXSTAGE_testBench;

  ARCHITECTURE behavior OF EXSTAGE_testBench IS 

  -- Component Declaration
          COMPONENT EXSTAGE
          PORT(RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC;
			  ALU_Cout: out  STD_LOGIC;
			  ALU_Ovf: out  STD_LOGIC);
          END COMPONENT;

			 SIGNAL ALU_Bin_sel :  std_logic := '0';
			 SIGNAL ALU_zero :  std_logic;
			 SIGNAL ALU_Cout :  std_logic;
			 SIGNAL ALU_Ovf :  std_logic;
          SIGNAL RF_B :  std_logic_vector(31 downto 0):= (others => '0');
          SIGNAL RF_A :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL Immed :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL ALU_func :  std_logic_vector(3 downto 0):= (others => '0');
			 SIGNAL ALU_out :  std_logic_vector(31 downto 0);

  BEGIN

  -- Component Instantiation
          uut: EXSTAGE PORT MAP(
                  RF_A=>RF_A,
						RF_B=>RF_B,
						Immed=>Immed,
						ALU_Bin_sel=>ALU_Bin_sel,
						ALU_func=>ALU_func,
						ALU_out=>ALU_out,
						ALU_zero=>ALU_zero,
						ALU_Cout=>ALU_Cout,
						ALU_Ovf=>ALU_Ovf);


  --  Test Bench Statements
     tb : PROCESS
     BEGIN --In this testbench we are going to check only the necessary operation cases of the ALU,because they were tested by detail in the ALU module
			  
			  --hold rest state for 50 ns
			  --so there is no problem with the timing diagramms
			  wait for 50 ns;
			  --initialization of the inputs to zero
			  RF_A<=x"00000000";
			  RF_B<=x"00000000";
			  Immed<=x"00000000";
			  wait for 200 ns;
			  --initialization of the first operand input of the ALU	,RF_A	  
			  RF_A<=x"0000000f";  --=15 DEC
			  --initialization of the two possible second operands inputs of the AL,RF_B or Immediate
           RF_B<=x"0000000a";  --=10 DEC
           Immed <=x"00000009";--=9 DEC
			  
			  --selection of the second operand of the ALU to be the RF_B
           ALU_Bin_sel<='0';
			  --testing every possible operation of the ALU between the operands RF_A and RF_B 
			  
			  ALU_func<="0000";--ADD 15+10=25
			  wait for 200 ns;
			  ALU_func<="0001";--SUB15-10=5
			  wait for 200 ns;
			  ALU_func<="0010";--AND
			  wait for 200 ns;
			  ALU_func<="0011";--OR
			  wait for 200 ns;
			  ALU_func<="0101";--NAND
			  wait for 200 ns;
			  ALU_func<="0110";--NOR
			  wait for 200 ns;
			  
			  --selection of the second operand of the ALU to be the Immediate
           ALU_Bin_sel<='1';
			  --testing every possible operation of the ALU between the operands RF_A and Immediate
			  
			  ALU_func<="0000";--ADD 15+9=24
			  wait for 200 ns;
			  ALU_func<="0001";--SUB 15-9=6
			  wait for 200 ns;
			  ALU_func<="0010";--AND
			  wait for 200 ns;
			  ALU_func<="0011";--OR
			  wait for 200 ns;
			  ALU_func<="0101";--NAND
			  wait for 200 ns;
			  ALU_func<="0110";--NOR
			  wait for 200 ns;
			  
			  --the cases below are not associated with the second input, they are dependning only from the first input
			  --so they are the same for either secon input RF_B or Immediate
			  ALU_func<="0100";--NOT A
			  wait for 200 ns;
			  ALU_func<="1000";--SRA A
			  wait for 200 ns;
			  ALU_func<="1001";--SLR A
			  wait for 200 ns;
			  ALU_func<="1010";--SLL A
			  wait for 200 ns;
			  ALU_func<="1100";--ROL A
			  wait for 200 ns;
			  ALU_func<="1101";--ROR A
			  wait for 200 ns;
			  
			  --check if the zero flag output works with either RF_B and Immediate
			  --ALU_zero=1
			  RF_A<=x"0000000f";
			  RF_B<=x"0000000f";
			  Immed <=x"0000000f";
			  ALU_func<="0001";--SUB
			  --RF_A-RF_B=0
			  ALU_Bin_sel<='0';
			  wait for 200 ns;
			  --RF_A-Immed=0
			  ALU_Bin_sel<='1';
			  wait for 200 ns;
			  
			  
			  --check if Cout output works with either RF_B and Immediate
			  --ALU_cout=1
			  RF_A <= X"ffffffff";
			  RF_B <= X"00000010"; 			  
			  Immed <= X"00000010";
			  ALU_func<="0000";--ADD
			  --RF_A+RF_B=>COUT=1
			  ALU_Bin_sel<='0';
			  wait for 200 ns;
			  --RF_A+Immed=>COUT=1
			  ALU_Bin_sel<='1';
			  wait for 200 ns;
			  
			  --check if overflow output works with either RF_B and Immediate
			  --ALU_ovf=1
			  --MAX positive number + 1 =>overflow
			  RF_A <= X"7fffffff";
			  RF_B <= X"00000001"; 			  
			  Immed <= X"00000001";
			  ALU_func<="0000";--ADD
			  --RF_A+RF_B=>OVF=1
			  ALU_Bin_sel<='0';
			  wait for 200 ns;
			  --RF_A+Immed=>OVF=1
			  ALU_Bin_sel<='1';
			  wait for 200 ns;

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
