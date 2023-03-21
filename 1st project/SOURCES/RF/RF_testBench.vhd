----------------------------------------------------------------------------------
-- Company: Techincal University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    18:41:41 04/04/2021 
-- Design Name: 
-- Module Name:    RF_testBench - Behavioral 
-- Project Name: 	 Organosh ypologiston project 1
----------------------------------------------------------------------------------
-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY RF_testBench IS
  END RF_testBench;

  ARCHITECTURE behavior OF RF_testBench IS 

  -- Component Declaration
          COMPONENT RF
          PORT(Adr1 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
               Adr2 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
				   Awr : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
				   Din : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
				   WrEn : in  STD_LOGIC;
					RST : in  STD_LOGIC;
				   CLK : in  STD_LOGIC;
				   Dout1 : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
				   Dout2 : out  STD_LOGIC_VECTOR(31 DOWNTO 0)
					);
          END COMPONENT;

          signal CLK: STD_LOGIC := '0';
			 signal RST: STD_LOGIC := '0';
			 signal WrEn: STD_LOGIC := '0';
			 signal Din: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
			 signal Adr1: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
			 signal Adr2: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
			 signal Dout1: STD_LOGIC_VECTOR(31 DOWNTO 0);
			 signal Dout2: STD_LOGIC_VECTOR(31 DOWNTO 0);
			 signal Awr: STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
          constant CLK_period : time := 190 ns;

  BEGIN

  -- Component Instantiation
          uut: RF PORT MAP(
					Adr1=>Adr1,
               Adr2=>Adr2, 
				   Awr=>Awr, 
				   Din=>Din,
					RST=>RST,					
				   WrEn=>WrEn, 
				   CLK=>CLK, 
				   Dout1=>Dout1,
				   Dout2=>Dout2 );

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
			
        -- wait so there is no problem with the memory timing diagramm
		  wait for 40 ns;
		  --reset =1 so the outputs are zero no matter from were we read and we cant write to the registers 
		  RST<='1';
		  WrEn<='1';
		  Din<=X"0000000F";
		  Awr<="00001";
		  Adr1<="00011";
		  Adr2<="00010";
		  wait for CLK_period;
		  --reset =0
		  --write enable =1 so we write the input to the register with address 1
		  --we read from the two given addresses-> address 1 has data that we just wrote on so we havge to wait for the clock to see it but address 3 has zeros so there is nothing to read 
		  RST<='0';
		  WrEn<='1';
		  Din<=X"000000FF";
		  Awr<="00001";
		  Adr1<="00011";
		  Adr2<="00001";
		  wait for CLK_period;
		  --reset =0
		  --write enable =1 so we write the input to the register with address 2
		  --we read from the two given addresses-> address 1 and 2 that we just wrote on so we have to wait the clock to see it
		  WrEn<='1';
		  Din<=X"00000AFF";
		  Awr<="00010";
		  Adr1<="00010";
		  Adr2<="00001";
		  wait for CLK_period;
		  --reset =1(active high)
		  --reset =1 so the outputs are zero no matter from were we read and we cant write to the registers 
		  RST<='1';
		  WrEn<='1';
		  Din<=X"00000FFF";
		  Awr<="00011";
		  Adr1<="00001";
		  Adr2<="00011";
		  wait for CLK_period;
		  --reset =0-> So now we can see the outputs
		  --write enable =1 so we write the input to the register with address 6
		  --we read from the two given addresses-> address 2 and 2 again that are zero due to the reset
		  RST<='0';
		  WrEn<='1';
		  Din<=X"0000AAFF";
		  Awr<="00110";
		  Adr1<="00010";
		  Adr2<="00010";
		  wait for CLK_period;
		  --write enable =1 so we write the input to the register with address 1
		  --we read from the two given addresses-> address 6 and 3 that is zero due to the reset
		  WrEn<='1';
		  Din<=X"000AAAFF";
		  Awr<="00001";
		  Adr1<="00110";
		  Adr2<="00011";
		  wait for CLK_period;
		  --write enable =0 so we cant write to the register->so the register with address 1 keeps his old value
		  --we read from the two given addresses-> address 6 and 2
		  WrEn<='0';
		  Din<=X"0000FFFF";
		  Awr<="00001";
		  Adr1<="00110";
		  Adr2<="00010";
		  wait for CLK_period;
		  --write enable =1 so we cant write to the register
		  --we read from the two given addresses-> address 1 that has the same data than before and 4 that we just wrote onwe just wrote on so we have to wait the clock to see it
		  WrEn<='1';
		  Din<=X"00FFFFFF";
		  Awr<="00100";
		  Adr1<="00001";
		  Adr2<="00100";
		  wait for CLK_period;
		  --write enable =1 so we cant write to the register,BUT we try to write on register 0 and we see that this is not possible 
		  --we read from the address 0 , both times 
		  WrEn<='1';
		  Din<=X"00FFFFFF";
		  Awr<="00000";
		  Adr1<="00000";
		  Adr2<="00000";
		  wait for CLK_period;
		  --write enable =1 so we cant write to the register
		  --we read from the two given addresses-> address 7 that we just wrote on we just wrote on so we have to wait the clock to see it  and from the address 3
		  WrEn<='1';
		  Din<=X"0FFFFFFF";
		  Awr<="00111";
		  Adr1<="00111";
		  Adr2<="00011";
		  
		--We initialize read register 2 to 0 
		--reset is unenabled
		--write is enabled
		Adr2 <= "00000";
		RST<='0';
		WrEn<='1';
		
		--We are going to test write and read to all the possible 32 registers
		--we are writing to register read 1 and we are reading register read 1 at the same clock cycle
		--read is asynchronous so we alwyays read, but write is sychronous so we write the new value after the rising edge of the clock comes
		Awr <= "00000";
		Din <= X"0000_0000";
		Adr1 <= "00000";
		wait for Clk_period;
		Awr <= "00001";
		Din <= X"0000_0001";
		Adr1 <= "00001";
		wait for Clk_period;
		Awr <= "00010";
		Din <= X"0000_0002";
		Adr1 <= "00010";
		wait for Clk_period;
		Awr <= "00011";
		Din <= X"0000_0003";
		Adr1 <= "00011";
		wait for Clk_period;
		Awr <= "00100";
		Din <= X"0000_0004";
		Adr1 <= "00100";
		wait for Clk_period;
		Awr <= "00101";
		Din <= X"0000_0005";
		Adr1 <= "00101";
		wait for Clk_period;
		Awr <= "00110";
		Din <= X"0000_0006";
		Adr1 <= "00110";
		wait for Clk_period;
		Awr <= "00111";
		Din <= X"0000_0007";
		Adr1 <= "00111";
		wait for Clk_period;
		Awr <= "01000";
		Din <= X"0000_0008";
		Adr1 <= "01000";
		wait for Clk_period;
		Awr <= "01001";
		Din <= X"0000_0009";
		Adr1 <= "01001";
		wait for Clk_period;
		Awr <= "01010";
		Din <= X"0000_000A";
		Adr1 <= "01010";
		wait for Clk_period;
		Awr <= "01011";
		Din <= X"0000_000B";
		Adr1 <= "01011";
		wait for Clk_period;
		Awr <= "01100";
		Din <= X"0000_000C";
		Adr1 <= "01100";
		wait for Clk_period;
		Awr <= "01101";
		Din <= X"0000_000D";
		Adr1 <= "01101";
		wait for Clk_period;
		Awr <= "01110";
		Din <= X"0000_000E";
		Adr1 <= "01110";
		wait for Clk_period;
		Din <= X"0000_000F";
		Awr <= "01111";
		Adr1 <= "01111";
		wait for Clk_period;
		Din <= X"0000_0010";
		Awr <= "10000";
		Adr1 <= "10000";
		wait for Clk_period;
		Din <= X"0000_0011";
		Awr <= "10001";
		Adr1 <= "10001";
		wait for Clk_period;
		Din <= X"0000_0011";
		Awr <= "10001";
		Adr1 <= "10001";
		wait for Clk_period;
		Din <= X"0000_0012";
		Awr <= "10010";
		Adr1 <= "10010";
		wait for Clk_period;
		Din <= X"0000_0013";
		Awr <= "10011";
		Adr1 <= "10011";
		wait for Clk_period;
		Din <= X"0000_0014";
		Awr <= "10100";
		Adr1 <= "10100";
		wait for Clk_period;
		Din <= X"0000_0015";
		Awr <= "10101";
		Adr1 <= "10101";
		wait for Clk_period;
		Din <= X"0000_0016";
		Awr <= "10110";
		Adr1 <= "10110";
		wait for Clk_period;
		Din <= X"0000_0017";
		Awr <= "10111";
		Adr1 <= "10111";
		wait for Clk_period;
		Din <= X"0000_0018";
		Awr <= "11000";
		Adr1 <= "11000";
		wait for Clk_period;
		Din <= X"0000_0019";
		Awr <= "11001";
		Adr1 <= "11001";
		wait for Clk_period;
		Din <= X"0000_001A";
		Awr <= "11010";
		Adr1 <= "11010";
		wait for Clk_period;
		Din <= X"0000_001B";
		Awr <= "11011";
		Adr1 <= "11011";
		wait for Clk_period;
		Din <= X"0000_001C";
		Awr <= "11100";
		Adr1 <= "11100";
		wait for Clk_period;
		Din <= X"0000_001D";
		Awr <= "11101";
		Adr1 <= "11101";
		wait for Clk_period;
		Din <= X"0000_001E";
		Awr <= "11110";
		Adr1 <= "11110";
		wait for Clk_period;
		Din <= X"0000_001F";
		Awr <= "11111";
		Adr1 <= "11111";
		wait for CLK_period;
		
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
