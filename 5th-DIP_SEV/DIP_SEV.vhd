-- SKU CoE ITE - ParkSooYoung
-- Grade 3 , Semester 2 , Week 5

library ieee; 
use ieee.std_logic_1164.all;

entity DIP_SEV is -- 7 segment decoder
	port ( val : in std_logic_vector (3 downto 0);
				y : out std_logic_vector (0 to 7)); 
end DIP_SEV;

architecture sample_other of DIP_SEV is 
begin
	process(val)
	begin
		if val= "0000" then
			y <= "11111100";
		elsif val= "0001" then
			y <= "01100000";
		elsif val = "0010" then
			y <= "11011010";
		elsif val = "0011" then
			y <= "11110010";
		elsif val = "0100" then
			y <= "01100110";
		elsif val = "0101" then
			y <= "10110110";
		elsif val = "0110" then
			y <= "10111110";
		elsif val = "0111" then
			y <= "11100100";
		elsif val = "1000" then
			y <= "11111110";
		elsif val = "1001" then
			y <= "11110110";
		elsif val = "1010" then
			y <= "11101110";
		elsif val = "1011" then
			y <= "00111110";
		elsif val = "1100" then
			y <= "00011010";
		elsif val = "1101" then
			y <= "01111010";
		elsif val= "1110" then
			y <= "10011110";
		elsif val= "1111" then
			y <= "10001110";
		else y <= "00000010";
		end if;
	end process;
end sample_other; 
