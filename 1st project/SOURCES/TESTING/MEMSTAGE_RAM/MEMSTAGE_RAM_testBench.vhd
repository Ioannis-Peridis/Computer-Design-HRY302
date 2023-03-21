-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY MEMSTAGE_RAM_testBench IS
  END MEMSTAGE_RAM_testBench;

  ARCHITECTURE behavior OF MEMSTAGE_RAM_testBench IS 

  -- Component Declaration
          COMPONENT MEMSTAGE_RAM
          PORT(CLK : in  STD_LOGIC;
			  ByteOp : in  STD_LOGIC;
           MEM_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
          END COMPONENT;

          SIGNAL CLK :  std_logic:= '0';
			 SIGNAL MEM_WrEn :  std_logic:= '0';
			 SIGNAL ByteOp :  std_logic:= '0';
          SIGNAL MEM_DataIn :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL ALU_MEM_Addr :  std_logic_vector(31 downto 0):= (others => '0');
			 SIGNAL MEM_DataOut :  std_logic_vector(31 downto 0);
			 constant clk_period : time := 200 ns;

          

  BEGIN

  -- Component Instantiation
          uut: MEMSTAGE_RAM PORT MAP(
                  ByteOp=>ByteOp,
						MEM_WrEn=>MEM_WrEn,
						ALU_MEM_Addr=>ALU_MEM_Addr,
						MEM_DataIn=>MEM_DataIn,
						MEM_DataOut=>MEM_DataOut,
						CLK=>CLK);
						
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
	  
	 wait for 20 ns;
			
			MEM_WrEn <= '0';
			ByteOp <= '0';
			ALU_MEM_Addr <= x"0000_0010";
			MEM_DataIn <= x"12e0_3415";
			wait for 200 ns;
			
			MEM_WrEn <= '1';
			ByteOp <= '0';
			ALU_MEM_Addr <= x"0000_0010";
			MEM_DataIn <= x"12e0_3415";			
			wait for 200 ns;
			
			MEM_WrEn <= '1';
			ByteOp <= '1';
			ALU_MEM_Addr <= x"0000_0010";
			MEM_DataIn <= x"12e0_3415";			
			wait for 200 ns;


        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
