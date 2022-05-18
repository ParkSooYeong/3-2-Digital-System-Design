LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY lcd_heartsensor IS
	port( clk			: in std_logic;
			resetn		: in std_logic;
			
			sw_ststp		: in std_logic;

--			address		: buffer std_logic_vector(6 downto 0) := "0000000";
--			busy			: buffer	std_logic;

			led : out std_logic;
			
			e, rs, rw	: out std_logic;
			lcd_data		: out std_logic_vector(7 downto 0) );
END lcd_heartsensor;

ARCHITECTURE sample of lcd_heartsensor IS
	COMPONENT lcd
		port( clk			: in std_logic;
			strobe         	: in std_logic;
			address        	: in std_logic_vector(6 downto 0); 
			data           	: in std_logic_vector(7 downto 0); 
			e, rs, rw, busy	: out std_logic;
			lcd_data       	: out std_logic_vector(7 downto 0) );
	END component;

	COMPONENT heart_sensor
		port( clk	: in std_logic;
			sw_ststp	: in std_logic;
			sw_reset	: in std_logic;
			address	: in std_logic_vector(6 downto 0);
			led 		: out std_logic;
			out_data	: out std_logic_vector(7 downto 0) );
	END COMPONENT;	
	
	SIGNAL	busy		: std_logic;
	SIGNAL	busy_pre	: std_logic;
	SIGNAL	strobe	: std_logic;
	SIGNAL	re_write	: std_logic;
	SIGNAL	ram_data	: std_logic_vector(7 downto 0);
	SIGNAL	address		: std_logic_vector(6 downto 0) := "0000000";
	SIGNAL	ini_pulse	: std_logic;
	SIGNAL	cnt 			: integer range 0 to 999;
	
BEGIN
	lcd_control : lcd PORT MAP( clk, strobe, address, ram_data, e, rs, rw, busy, lcd_data );
	watch_ctrl	: heart_sensor PORT MAP( clk, sw_ststp, not resetn, address, led, ram_data );
	
	P_REFRESH : PROCESS(clk, resetn)
	BEGIN
		IF resetn = '0' THEN
			cnt <= 0;
		ELSIF clk'EVENT AND clk='1' THEN
			IF cnt /= 999 THEN
				cnt <= cnt + 1;
				re_write <= '0';
			ELSE
				cnt <= 0;
				re_write <= '1';
			END IF;
		END IF;
	END PROCESS;
	
--	P_MK_INIT_P : PROCESS(clk, resetn, cnt)			-- Making auto reset pulse (==ini_puls)
--	BEGIN
--		IF resetn = '0' THEN
--			ini_flag		<= '0';
--			ini_pulse	<= '0';
--		ELSIF ini_flag = '0' THEN
--			IF cnt < 99 THEN									-- LCD SETUP TIME 100ms
--				ini_pulse <= '0';
--				ini_flag <= '0';
--			ELSIF cnt = 99 THEN
--				ini_pulse <= '1';
--				ini_flag <= '1';
--			END IF;
--		ELSE	
--			ini_pulse <= '0';
--		END IF;
--	END PROCESS;

	P_ADD : PROCESS(clk, resetn, re_write)
	BEGIN
		IF resetn = '0' THEN									--ini_pulse = '1' THEN
				strobe <= '1';
				address <= "0000000";
		ELSIF re_write = '1' THEN
				strobe <= '1'; 
				address <= "1000000";
		ELSIF clk'event and clk = '1' THEN
			busy_pre <= busy;
			
			IF busy = '0' and busy_pre = '1' THEN
				IF address = "0001111" THEN
					address <= "1000000";
					strobe <= '1';
				ELSIF address /= "1001111" THEN
					address <= address + 1;
					strobe <= '1';
				END IF;
			ELSE
				strobe <= '0'; 
			END IF;
		END IF;  
	END PROCESS;

END sample;