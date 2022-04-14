LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY D_7SEG IS 
	PORT( CLK : IN STD_LOGIC; -- 1kHz
	      DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	  SEG_COM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 7-SEGMENT COMM. 
	 SEG_DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ); -- 7-SEGMENT DATA 
END D_7SEG; 

ARCHITECTURE D_7SEG OF D_7SEG IS 
	SIGNAL CNT_SCAN : INTEGER RANGE 0 TO 7 := 0; -- SCAN COUNT 

	function dec_7_seg( inbin : STD_LOGIC_VECTOR(3 downto 0) ) 
		return std_logic_vector is -- 7 segment decoder

		variable res : std_logic_vector(7 downto 0);
		variable val : integer range 0 to 15;
	begin
		val := to_integer( unsigned(inbin ) );

		if (val = 16#0#) then res := "00111111"; --X"3F" -- '0' : OFF
		elsif (val = 16#1#) then res := "00000110"; --X"06" -- '1' : ON
		elsif (val = 16#2#) then res := "01011011"; --X"5B" -- MSB : Segment 'h'
		elsif (val = 16#3#) then res := "01001111"; --X"4F" -- LSB : Segment 'a'
		elsif (val = 16#4#) then res := "01100110"; --X"66"
		elsif (val = 16#5#) then res := "01101101"; --X"6D"
		elsif (val = 16#6#) then res := "01111101"; --X"7D"
		elsif (val = 16#7#) then res := "00000111"; --X"07"
		elsif (val = 16#8#) then res := "01111111"; --X"7F"
		elsif (val = 16#9#) then res := "01101111"; --X"6F"
		elsif (val = 16#A#) then res := "01110111"; --X"77"
		elsif (val = 16#B#) then res := "01111100"; --X"7C"
		elsif (val = 16#C#) then res := "00111001"; --X"39"
		elsif (val = 16#D#) then res := "01011110"; --X"5E"
		elsif (val = 16#E#) then res := "01111001"; --X"79"
		elsif (val = 16#F#) then res := "01110001"; --X"71"
		else res := "01000000";
		end if;

		return res;
	end dec_7_seg;

BEGIN
	PROCESS(CLK) 
	BEGIN 
		IF CLK'EVENT AND CLK = '1' THEN 
			IF CNT_SCAN = 7 THEN 
				CNT_SCAN <= 0; 
			ELSE
				CNT_SCAN <= CNT_SCAN + 1; 
			END IF; 
		END IF; 
	END PROCESS;

	PROCESS(CNT_SCAN, DIN)
	BEGIN 
		CASE CNT_SCAN IS 
			WHEN 0 => 
				SEG_DATA <= dec_7_seg( DIN( 3 downto 0) );
				SEG_COM <= "11111110";-- SEL COM1
			WHEN 1 => 
				SEG_DATA <= dec_7_seg( DIN( 7 downto 4) );
				SEG_COM <= "11111101";-- SEL COM2 
			WHEN 2 =>
				SEG_DATA <= dec_7_seg( DIN( 11 downto 8) );
				SEG_COM <= "11111011";-- SEL COM3 
			WHEN 3 => 
				SEG_DATA <= dec_7_seg( DIN( 15 downto 12) );
				SEG_COM <= "11110111";-- SEL COM4
			WHEN 4 => 
				SEG_DATA <= dec_7_seg( DIN( 19 downto 16) );
				SEG_COM <= "11101111";-- SEL COM5
			WHEN 5 => 
				SEG_DATA <= dec_7_seg( DIN( 23 downto 20) );
				SEG_COM <= "11011111";-- SEL COM6 
			WHEN 6 =>
				SEG_DATA <= dec_7_seg( DIN( 27 downto 24) );
				SEG_COM <= "10111111";-- SEL COM7 
			WHEN 7 => 
				SEG_DATA <= dec_7_seg( DIN( 31 downto 28) );
				SEG_COM <= "01111111";-- SEL COM8
			WHEN OTHERS => 
				SEG_DATA <= X"00"; --
				SEG_COM <= "11111111";-- SEL X 
		END CASE; 
	END PROCESS; 
END D_7SEG;
