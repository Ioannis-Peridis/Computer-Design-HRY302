-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY DATAPATH_testBench IS
  END DATAPATH_testBench;

  ARCHITECTURE behavior OF DATAPATH_testBench IS 

  -- Component Declaration
      COMPONENT DATAPATH
      PORT(--Inputs
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  
			  --Inputs of IFSTAGE
			  Pc_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           --Output of IFSTAGE
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
           
			  --Inputs of DECSTAGE
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
          END COMPONENT;

          
          SIGNAL Reset :std_logic  := '0';
			 SIGNAL CLK :std_logic  := '0';
			 SIGNAL Pc_sel :std_logic  := '0';
			 SIGNAL PC_LdEn :std_logic;
			 SIGNAL RF_B_sel :std_logic  := '0';
			 SIGNAL ImmExt :std_logic_vector(1 downto 0) := (others => '0');
			 SIGNAL RF_WrEn :std_logic  := '0';
			 SIGNAL Instr :std_logic_vector(31 downto 0) := (others => '0');
			 SIGNAL RF_WrData_sel :std_logic  := '0';
			 SIGNAL ALU_func :std_logic_vector(3 downto 0) := (others => '0');
			 SIGNAL ALU_Bin_sel :std_logic  := '0';
			 SIGNAL ByteOp :std_logic  := '0';
			 SIGNAL MEM_WrEn :std_logic  := '0';
			 SIGNAL MM_RdData :std_logic_vector(31 downto 0) := (others => '0');
			
			 SIGNAL PC:std_logic_vector(31 downto 0);
			 SIGNAL ALU_zero:std_logic;
			 SIGNAL ALU_cout:std_logic;
			 SIGNAL ALU_ovf:std_logic;
			 SIGNAL MM_WrEn:std_logic;
			 SIGNAL MM_Addr:std_logic_vector(31 downto 0);
			 SIGNAL MM_WrData:std_logic_vector(31 downto 0);
			 
			 constant clk_period : time := 200 ns;

  BEGIN

  -- Component Instantiation
          uut: DATAPATH PORT MAP(
                Reset=>Reset,
					 CLK=>CLK,
					 Pc_sel=>Pc_sel,
					 PC_LdEn=>PC_LdEn,
					 ImmExt=>ImmExt,
					 RF_WrEn=>RF_WrEn,
					 RF_B_sel=>RF_B_sel,
					 Instr=>Instr,
					 RF_WrData_sel=>RF_WrData_sel,
					 ALU_func=>ALU_func,
					 ALU_Bin_sel=>ALU_Bin_sel,
					 ByteOp=>ByteOp,
					 MEM_WrEn=>MEM_WrEn,
					 MM_RdData=>MM_RdData,
					 PC=>PC,
					 ALU_zero=>ALU_zero,
					 ALU_cout=>ALU_cout,
					 ALU_ovf=>ALU_ovf,
					 MM_WrEn=>MM_WrEn,
					 MM_Addr=>MM_Addr,
					 MM_WrData=>MM_WrData);

CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

	

  --  Test Bench Statements
-- Stimulus process
 stim_proc: process
   begin		
      -- hold Reset state for 100 ns.
		--activate reset for 2 clock periodos, so every output is seto to 0
        Reset <= '1';
        wait for 2 * clk_period;
        Reset <= '0';
        	--pc+4
			--always fetches isntruction
			
        -- addi r5, r0, 8
        
        Pc_sel <= '0';			
        PC_LdEn <= '1';		
        RF_WrEn <= '1';			--rf write enabled
        RF_WrData_sel <= '0'; --Alu out
        RF_B_sel <= '0';		--rt
        ImmExt <= "01";       --Sign extend
        ALU_Bin_sel <= '1';   --Immed
        ALU_func <= "0000";   --add
        MEM_WrEn <= '0';		--memory write unenabled
        ByteOp <= '-';	
        Instr <= "11000000000001010000000000001000";
        wait for clk_period;
        
        -- ori r3, r0, x"abcd"
        
        Pc_sel <= '0';
        PC_LdEn <= '1';
        RF_WrEn <= '1';			--rf write enabled
        RF_WrData_sel <= '0'; --Alu out
        RF_B_sel <= '0';		--rt
        ImmExt <= "00";       --Zero fill
        ALU_Bin_sel <= '1';   --Immed
        ALU_func <= "0011";   --or
        MEM_WrEn <= '0';		--memory write unenabled
        ByteOp <= '-';
        Instr <= "11001100000000111010101111001101";
        wait for clk_period;
        
        -- sw r3, 4(r0)
        
        Pc_sel <= '0';
        PC_LdEn <= '1';
        RF_WrEn <= '0';				 --rf write unenabled
        RF_WrData_sel <= '1';		 --mem out
        RF_B_sel <= '1';			 --rd
        ImmExt <= "01";				 --sign extend
        ALU_Bin_sel <= '1';       --Immed
        ALU_func <= x"0";         --add
        MEM_WrEn <= '1';			 --mem write enabled
        ByteOp <= '0';				 --word
        Instr <= "01111100000000110000000000000100";
        
        wait for clk_period;
        
        -- lw r10, -4(r5)
        
        Pc_sel <= '0';
        PC_LdEn <= '1';
        RF_WrEn <= '1';			--rf write enabled
        RF_WrData_sel <= '1'; --Mem out
        RF_B_sel <= '0';		--rt
        ImmExt <= "01";       --Sign extend
        ALU_Bin_sel <= '1';   --Immed    
        ALU_func <= x"0";     --add
        MEM_WrEn <= '0';		--mem write unenabled
        ByteOp <= '0';			--word
        MM_RdData <= x"0000abcd";
        Instr <= "00111100101010101111111111111100";
        
        wait for clk_period;
        
        -- lb r16 4(r0)
        
        Pc_sel <= '0';
        PC_LdEn <= '1';
        RF_WrEn <= '1';			--rf write enabled
        RF_WrData_sel <= '1'; --Mem out
        RF_B_sel <= '0';		--rt
        ImmExt <= "01";			--Sign extend
        ALU_Bin_sel <= '1';   --Immed
        ALU_func <= x"0";     --add
        MEM_WrEn <= '0';		--mem write unenabled
        ByteOp <= '1';			--byte
        MM_RdData <= x"0000abcd";
        Instr <= "00001100000100000000000000000100";
        
        wait for clk_period;
        
        -- nand r4, r0, r16
        
        Pc_sel <= '0';
        PC_LdEn <= '1';
        RF_WrEn <= '1';			--rf write enabled
        RF_WrData_sel <= '0'; --alu out
        RF_B_sel <= '0';		--rt
        ImmExt <= "--";
        ALU_Bin_sel <= '0';	--rf_b
        ALU_func <= x"6";     --nand
        MEM_WrEn <= '0';		--mem write unenabled
        ByteOp <= '-';
        Instr <= "10000001010001001000000000110101";
        
        wait for clk_period;
    
      wait;
   end process;
  END;
