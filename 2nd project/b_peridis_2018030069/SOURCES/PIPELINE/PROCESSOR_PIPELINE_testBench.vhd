LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY PROCESSOR_PIPELINE_testBench IS
  END PROCESSOR_PIPELINE_testBench;

  ARCHITECTURE behavior OF PROCESSOR_PIPELINE_testBench IS 

  -- Component Declaration
          COMPONENT PROCESSOR_PIPELINE
          PORT(CLK : in  STD_LOGIC;
					Reset : in  STD_LOGIC);
          END COMPONENT;

			 SIGNAL Reset :std_logic  := '0';
			 SIGNAL CLK :std_logic  := '0';
          constant CLK_period : time :=20 ns;

  BEGIN

  -- Component Instantiation
          uut: PROCESSOR_PIPELINE PORT MAP(
                 CLK=>CLK,
					  Reset=>Reset);
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
		--The testbench here is just given a clock and a reset , we load to the RAM module the files withe the MIPS like instructions that we want to test
		
		  --we activate the reset for 3 clock periods so all the outputs are set to zero
		  Reset<='1';	
        wait for CLK_period * 3;
		  --we deactivate reset and start to run our first instructions
		  Reset<='0';

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
