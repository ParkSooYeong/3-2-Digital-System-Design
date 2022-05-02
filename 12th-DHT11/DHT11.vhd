library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY DHT11 is
	port(
			clk		: in		std_logic;					--100khz
			dht11_d	: inout	std_logic;
			res_data	: out 	std_logic_vector(39 downto 0)
		);
end DHT11 ;

ARCHITECTURE DHT11 OF DHT11 IS

signal cnt			: integer range 0 to 19999;		-- checking for every 200ms 
signal stage		: integer range 0 to 43;			-- 0:start, 1:response, 2~41: input bit
signal dur_cnt		: integer range 0 to 15;			-- more than (50+70)us ----> 150us
signal indata		: std_logic_vector(39 downto 0);
signal ind			: std_logic;

BEGIN

	process(clk)
	begin
		if( clk'event and clk = '1' ) then
			if( cnt < 19999 ) then
				cnt <= cnt + 1;
			else
				cnt <= 0;
			end if;
			ind <= dht11_d;
		end if;
	end process;

	process(ind, cnt)
	begin
		if( cnt = 0 ) then
			stage <= 0;
			indata <= (others => '0');
		elsif( ind'event and ind = '0' ) then
			if( stage >= 3 and stage <= 42) then
				if( dur_cnt > 5 ) then						-- '1' : 70us
					indata(42-stage) <= '1';				-- '0' : 20us
				else
					indata(42-stage) <= '0';
				end if;
			end if;
			if( stage < 43 ) then
				stage <= stage + 1;
			end if;
		end if;
	end process;

	process(ind, cnt)
	begin
		if( ind'event and ind = '1' ) then
			if( stage = 43 ) then
				res_data <= indata;
			end if;
		end if;
	end process;

	process(ind, clk)
	begin
		if( ind = '0' ) then
			dur_cnt <= 0;
		elsif( clk'event and clk = '1' ) then
			dur_cnt <= dur_cnt + 1;
		end if;
	end process;
	
	process(cnt, clk)
	begin
		if( clk'event and clk = '1' ) then
			if( cnt < 2000 ) then							-- output '0' more than 18ms	---> 20ms
				dht11_d <= '0';
			elsif( cnt < 2003 ) then						-- output '1' 20us ~ 40us		---> 30us
				dht11_d <= '1';
			else
				dht11_d <= 'Z';
			end if;
		end if;
	end process;
	
END DHT11;
