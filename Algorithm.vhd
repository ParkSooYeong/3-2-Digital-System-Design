-- SKU CoE ITE - ParkSooYoung
-- Grade 3 , Semester 2 , Week 6 , Counter

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Algorithm IS
	PORT( clk : in std_logic;
			reset : in std_logic;
			led : buffer std_logic_vector (7 downto 0));
END Algorithm;

ARCHITECTURE Algorithm OF Algorithm IS
BEGIN
	P1 : PROCESS(clk, reset)
		variable cnt : integer range 0 to 12;
	BEGIN
		if(reset = '0') then
			cnt := 0;
			led <= "00000001";
		elsif(clk'event and clk = '1') then
			if(cnt = 12) then
				cnt := 0;
				led(0) <= led(7);
				led(7 downto 1) <= led(6 downto 0);
			else
				cnt := cnt + 1;
			end if;
		end if;
	END PROCESS;
END Algorithm;
