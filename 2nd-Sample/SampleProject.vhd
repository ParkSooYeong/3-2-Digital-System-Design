-- SKU CoE ITE - ParkSooYoung --
-- Grade 3 , Semester 2 , Week 2 --

library ieee; 
use ieee.std_logic_1164.all; 

entity SampleProject is
	port(
		clk		: in std_logic;
		reset		: in std_logic;
		out_clk5	: buffer std_logic );
end SampleProject;

architecture divby5 of SampleProject is
begin
	P1 : process(clk, reset)
		variable	cnt : integer range 0 to 4;
	begin
		if( reset = '0' ) then
			cnt := 0;
			out_clk5 <= '0' ;
		elsif( clk'event and clk ='1' ) then
			if( cnt = 4 ) then
				cnt := 0;
				out_clk5 <= not out_clk5;
			else
				cnt := cnt + 1;
			end if;
		end if;
	end process;
end divby5;
