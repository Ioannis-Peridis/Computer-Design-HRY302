-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY PROCESSOR_MC_testBench IS
  END PROCESSOR_MC_testBench;

  ARCHITECTURE behavior OF PROCESSOR_MC_testBench IS 

  -- Component Declaration
          COMPONENT PROCESSOR_MC
          PORT(
                  CLK : IN std_logic;
						Reset: IN std_logic
                
                  );
          END COMPONENT;

          SIGNAL CLK:  std_logic:='0';
			 SIGNAL Reset:  std_logic:='0';
          constant CLK_period: time :=40 ns;
          

  BEGIN

  -- Component Instantiation
          uut: PROCESSOR_MC PORT MAP(
                  CLK=>CLK,
						Reset=>Reset
          );
			 
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
		 wait for 15 ns; 		  
		 Reset<='1';	         
		 wait for CLK_period * 3; 		  
		 --we deactivate reset and start to run our first instructions 		  
		 Reset<='0'; 

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
