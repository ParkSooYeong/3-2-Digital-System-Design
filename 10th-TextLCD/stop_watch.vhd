LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY stop_watch IS
	port( clk	: in std_logic;
			sw_reset	: in std_logic;
			sw_ststp	: in std_logic;
			address	: in std_logic_vector(6 downto 0);

			out_data	: out std_logic_vector(7 downto 0) );
END stop_watch;

ARCHITECTURE sample of stop_watch IS
	SIGNAL	sec_val	: integer	range 0 to 86399;		--	1day=24h=1440m=86400s
	SIGNAL	ststp		: std_logic := '0';
	TYPE		lcd_disp IS ARRAY(0 to 1, 0 to 15) of std_logic_vector(7 downto 0);
	SIGNAL	msg : lcd_disp := ((	X"20", X"20", X"20", X"20", X"53", X"54", X"4F", X"50",		--
											X"57", X"41", X"54", X"43", X"48", X"20", X"20", X"20"),		--   STOP WATCH 
										(	X"20", X"20", X"20", X"20", X"20", X"20", X"3A", X"20", 		--    ??:??.??     
											X"20", X"2E", X"20",X"20",X"20", X"20", X"20", X"20") ); 	--
BEGIN
	P_SW_STSTP : PROCESS(sw_reset, sw_ststp)
	BEGIN
		IF sw_reset = '1' THEN
			ststp <= '0';
		ELSIF sw_ststp'EVENT AND sw_ststp='1' THEN
			ststp <= not ststp;
		END IF;
	END PROCESS;
										
	P_VAL : PROCESS(clk, sw_reset, ststp)
		VARIABLE	cnt : integer range 0 to 999;
	BEGIN
		IF sw_reset = '1' THEN
			cnt := 0;
			sec_val <= 0;
		ELSIF clk'EVENT AND clk='1' AND ststp='1'THEN
			IF cnt /= 999 THEN
				cnt := cnt + 1;
			ELSE
				cnt := 0;
				IF sec_val /= 86399 THEN
					sec_val <= sec_val + 1;
				ELSE
					sec_val <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	P_DATA : PROCESS(sec_val)
		VARIABLE d_sec		: integer range 0 to 59 := 0;
		VARIABLE d_min		: integer range 0 to 59 := 0;
		VARIABLE d_hour	: integer range 0 to 23 := 0;
	BEGIN
		d_hour := sec_val / 3600;
		d_min := (sec_val mod 3600) / 60;
		d_sec := (sec_val mod 3600) mod 60;
	
		msg(1, 4)	<=	(d_hour  /  10)  + X"30";
		msg(1, 5)	<= (d_hour mod 10)  + X"30";
		msg(1, 7)	<=	(d_min  /  10)  + X"30";
		msg(1, 8)	<= (d_min mod 10)  + X"30";
		msg(1, 10)	<=	(d_sec  /  10)  + X"30";
		msg(1, 11)	<= (d_sec mod 10)  + X"30";
	END PROCESS;
	
	P_OUT : PROCESS(address, msg)
		VARIABLE col_add	: integer range 0 to 63;
		VARIABLE row_add	: integer range 0 to 1;
	BEGIN
		col_add := to_integer(unsigned(address(5 downto 0)));		-- convert std_logic_vector to integer
		row_add := to_integer(unsigned(address(6 downto 6)));
		
		out_data <= msg(row_add, col_add);
	END PROCESS;

END sample;