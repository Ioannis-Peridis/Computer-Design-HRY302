----------------------------------------------------------------------------------
-- Company: Techincal University Of Crete
-- Engineer: Giannis Peridis
-- 
-- Create Date:    18:41:41 04/04/2021 
-- Design Name: 
-- Module Name:    RF - Behavioral 
-- Project Name: 	 Organosh ypologiston project 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Register file: contains 32x32bit registers, two  ports that are used for reading , one port that is
--used for writing. 
entity RF is
    Port ( Adr1 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);--first reigster address that we are reading from
           Adr2 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);--second register address that we are reading from
           Awr : in  STD_LOGIC_VECTOR(4 DOWNTO 0);	--the register address that we are writing to 
           Din : in  STD_LOGIC_VECTOR(31 DOWNTO 0);--the input that we are writing
           WrEn : in  STD_LOGIC;							--write enable:singal that is used to allow or not to write in the register
			  RST : in  STD_LOGIC; 							--RESET:SIGNAL THAT WHEN ITS ACTIVATED , ALL OUTPUTS OF THE REGISTERS AND ALL 
																	--THE VALUES THAT THEY HAVE ALLREADY STORED BECOME TO ZERO
           CLK : in  STD_LOGIC;							--clock
           Dout1 : out  STD_LOGIC_VECTOR(31 DOWNTO 0);--data of the first register that we read from
           Dout2 : out  STD_LOGIC_VECTOR(31 DOWNTO 0));--data of the second register that we read from
end RF;


architecture Behavioral of RF is

--decoder 5 to 32 bits
--it is used to calculate witch one of the registers is going to be able to get written on,depending on the address given 
component decoder5to32
Port ( decoderIN : in  STD_LOGIC_VECTOR( 4 DOWNTO 0);
       decoderOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--register 32 bits
--they are used to be read(two of the can be read in the same cycle) and to be written on( one of them can be written in the same cycle) 
component REG 
Port ( CLK : in  STD_LOGIC;
       RST : in  STD_LOGIC;
       Datain : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
       WE : in  STD_LOGIC;
       Dataout : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--mux 32 with 5 bit select
--two of them are used to calculate the data from the registers that we read from
component mux32x5
Port (  muxIN0 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN1 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN2 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN3 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN4 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN5 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN6 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN7 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN8 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN9 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN10 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN11 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN12 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN13 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN14 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN15 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN16 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN17 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN18 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN19 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN20 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN21 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN22 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN23 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN24 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN25 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN26 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN27 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN28 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN29 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN30 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxIN31 : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  muxSELECT : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
		  muxOUT : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--creation of a 32 bit array of 32 bit vectors, it is used to store all the outputs of the registers
type registersArray is array(0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0);
--integral signals that are used to calculate the singals between the components
signal decoderOUT_top,WE_top:STD_LOGIC_VECTOR(31 DOWNTO 0);--32 bit vectors
signal Dataout_top: registersArray;								  --array of the type we created

begin

--this is how the write enable that goes to every register is calculated
--if write enable is 1, then we write to the register with the given write address
with(WrEn)select
	WE_top<= (decoderOUT_top AND B"0000_0000_0000_0000_0000_0000_0000_0000") after 2ns when '0',--if write enable is 0, then we can not write in the registers
			   (decoderOUT_top AND B"1111_1111_1111_1111_1111_1111_1111_1110") after 2ns when '1';--if write enable is 1, then we can write to the register with the given address
																															  --EXPECT from the register 0 , that we cant write eitherways
--decoder port mapping																								  --NOTE: there is a 2ns delation in the AND GATE
--output is send to the AND gate with WrEn																							 						  
decoder:decoder5to32
port map(decoderIN=>Awr,
			decoderOUT=>decoderOUT_top);

--port mapping of 32 registers , using for generate		
registers32x32:		
for i in 0 to 31 generate
registers:REG
port map(CLK=>CLK,
			RST=>RST,
			--here we store every write enable bit in a vector
			WE=>WE_top(i),
			Datain=>Din,
			--here we store every registers output in the array
			Dataout=>Dataout_top(i));
end generate registers32x32;

--first multiplexer for the first address port mapping  
mux1:mux32x5
port map(muxIN0=>Dataout_top(0),
			muxIN1=>Dataout_top(1),
			muxIN2=>Dataout_top(2),
			muxIN3=>Dataout_top(3),
			muxIN4=>Dataout_top(4),
			muxIN5=>Dataout_top(5),
			muxIN6=>Dataout_top(6),
			muxIN7=>Dataout_top(7),
			muxIN8=>Dataout_top(8),
			muxIN9=>Dataout_top(9),
			muxIN10=>Dataout_top(10),
			muxIN11=>Dataout_top(11),
			muxIN12=>Dataout_top(12),
			muxIN13=>Dataout_top(13),
			muxIN14=>Dataout_top(14),
			muxIN15=>Dataout_top(15),
			muxIN16=>Dataout_top(16),
			muxIN17=>Dataout_top(17),
			muxIN18=>Dataout_top(18),
			muxIN19=>Dataout_top(19),
			muxIN20=>Dataout_top(20),
			muxIN21=>Dataout_top(21),
			muxIN22=>Dataout_top(22),
			muxIN23=>Dataout_top(23),
			muxIN24=>Dataout_top(24),
			muxIN25=>Dataout_top(25),
			muxIN26=>Dataout_top(26),
			muxIN27=>Dataout_top(27),
			muxIN28=>Dataout_top(28),
			muxIN29=>Dataout_top(29),
			muxIN30=>Dataout_top(30),
			muxIN31=>Dataout_top(31),
			--the selection of the 32registers output is based on the address address given
			muxSELECT=>Adr1,
			muxOUT=>Dout1);

--second multiplexer for the first address port mapping  			
mux2:mux32x5
port map(muxIN0=>Dataout_top(0),
			muxIN1=>Dataout_top(1),
			muxIN2=>Dataout_top(2),
			muxIN3=>Dataout_top(3),
			muxIN4=>Dataout_top(4),
			muxIN5=>Dataout_top(5),
			muxIN6=>Dataout_top(6),
			muxIN7=>Dataout_top(7),
			muxIN8=>Dataout_top(8),
			muxIN9=>Dataout_top(9),
			muxIN10=>Dataout_top(10),
			muxIN11=>Dataout_top(11),
			muxIN12=>Dataout_top(12),
			muxIN13=>Dataout_top(13),
			muxIN14=>Dataout_top(14),
			muxIN15=>Dataout_top(15),
			muxIN16=>Dataout_top(16),
			muxIN17=>Dataout_top(17),
			muxIN18=>Dataout_top(18),
			muxIN19=>Dataout_top(19),
			muxIN20=>Dataout_top(20),
			muxIN21=>Dataout_top(21),
			muxIN22=>Dataout_top(22),
			muxIN23=>Dataout_top(23),
			muxIN24=>Dataout_top(24),
			muxIN25=>Dataout_top(25),
			muxIN26=>Dataout_top(26),
			muxIN27=>Dataout_top(27),
			muxIN28=>Dataout_top(28),
			muxIN29=>Dataout_top(29),
			muxIN30=>Dataout_top(30),
			muxIN31=>Dataout_top(31),
			--the selection of the 32registers output is based on the second address given
			muxSELECT=>Adr2,
			muxOUT=>Dout2);
			
end Behavioral;

