-- SKU CoE ITE - ParkSooYoung
-- Grade 3 , Semester 2 , Week 7

library ieee; 
use ieee.std_logic_1164.all;

ENTITY DFND_StopWatch IS
	PORT( clk1k : in std_logic;
		sw_reset : in std_logic;
	sw_strtstop : in std_logic;
		 seg_com : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		seg_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END DFND_StopWatch;

ARCHITECTURE StopWatch of DFND_StopWatch IS
	COMPONENT D_7SEG IS 
		PORT( CLK : IN STD_LOGIC; -- 1kHz
				DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  SEG_COM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 7-SEGMENT COMM. 
		 SEG_DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ); -- 7-SEGMENT DATA 
	END COMPONENT; 
	
	COMPONENT StopWatch is
		port( clk1k : in std_logic;
			sw_reset : in std_logic;
		sw_strtstop : in std_logic; -- Value 
			disp_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0') ); -- to display
	end COMPONENT;
	
	SIGNAL val : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
		stw : StopWatch PORT MAP ( clk1k, sw_reset, sw_strtstop, val );
		seg : D_7SEG PORT MAP( clk1k, val, SEG_COM, SEG_DATA );
END StopWatch;
