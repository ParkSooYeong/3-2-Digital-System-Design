LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY heart_sensor IS
	port( clk	: in std_logic;
			sw_reset	: in std_logic;
			sw_ststp	: in std_logic;
			address	: in std_logic_vector(6 downto 0);
			led 		: out std_logic;
			out_data	: out std_logic_vector(7 downto 0) );
END heart_sensor;

ARCHITECTURE sample of heart_sensor IS
	SIGNAL	sec		: integer	range 0 to 60;
	SIGNAL	sec_val	: integer	range 0 to 999;
	SIGNAL	count		: integer	range 0 to 999;
	SIGNAL	BPM		: integer	range 0 to 999;
	SIGNAL	ststp		: std_logic := '0';
	TYPE		lcd_disp IS ARRAY(0 to 1, 0 to 15) of std_logic_vector(7 downto 0);
	SIGNAL	msg : lcd_disp := ((	X"42", X"50", X"4D", X"20", X"20", X"20", X"20", X"43",		--
											X"4E", X"54", X"20", X"20", X"20", X"54", X"49", X"4D"),		--   BPM CNT TIM
										(	X"20", X"20", X"20", X"20", X"20", X"20", X"20", X"20", 		--   xxx yyy zzz   
											X"20", X"20", X"20",X"20",X"20", X"20", X"20", X"20") ); 		--
	
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
				led <= '0';
			ELSE
				cnt := 0;
				led <= '1';
				IF sec /= 60 THEN
					sec_val <= sec_val + 1;
				ELSE
					sec_val <= 0;
				END IF;
			END IF;
		END IF;
		BPM <= sec_val;
	END PROCESS;
	
	P_TIME : PROCESS(clk, sw_reset, ststp)
		VARIABLE	cnt : integer range 0 to 999;
	BEGIN
		IF sw_reset = '1' THEN
			cnt := 0;
			sec <= 0;
		ELSIF clk'EVENT AND clk='1' THEN
			IF cnt /= 999 THEN
				cnt := cnt + 1;
			ELSE
				cnt := 0;
				IF sec /= 60 THEN
					sec <= sec + 1;
				ELSE
					sec <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	P_DATA : PROCESS(sec_val, sec, BPM)
		VARIABLE d_1		: integer range 0 to 10 := 0;
		VARIABLE d_2		: integer range 0 to 10 := 0;
		VARIABLE d_3		: integer range 0 to 10 := 0;
		
		VARIABLE s_1		: integer range 0 to 99900 := 0;
		VARIABLE s_2		: integer range 0 to 999 := 0;
	BEGIN
	
		s_1 := BPM*100;
		s_2 := s_1/sec;

		d_3 := s_2 / 100;
		d_2 := s_2 / 10;
		d_1 := s_2 mod 10;
		
		msg(1, 0) 	<=	d_3  + X"30";
		msg(1, 1)	<=	(d_2 mod 10)  + X"30";
		msg(1, 2)	<=	d_1  + X"30";
		msg(1, 7) 	<= (sec_val / 100) + X"30";
		msg(1, 8) 	<= ((sec_val / 10) mod 10) + X"30";
		msg(1, 9) 	<= (sec_val mod 10) + X"30";
		msg(1, 14) 	<= (sec / 10) + X"30";
		msg(1, 15) 	<= (sec mod 10) + X"30";
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
