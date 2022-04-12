-- SKU CoE ITE - ParkSooYoung
-- Grade 3 , Semester 2 , Week 3

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Test IS
	PORT( d : IN STD_LOGIC_VECTOR(0 to 7);
			sel : IN STD_LOGIC_VECTOR(2 downto 0);
				y : OUT STD_LOGIC );
END Test;

ARCHITECTURE Test OF Test IS
BEGIN
	y <= d(0) when (sel = "000") else
	d(1) when (sel = "001") else
	d(2) when (sel = "010") else
	d(3) when (sel = "011") else
	d(4) when (sel = "100") else
	d(5) when (sel = "101") else
	d(6) when (sel = "110") else
	d(7) when (sel = "111");
END Test;
