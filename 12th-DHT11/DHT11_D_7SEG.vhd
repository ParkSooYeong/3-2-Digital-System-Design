--
--	CLOCK : 100kHz
-- Relative Humidity and Temp. Sensor : DHT11
--	Display : On FND ARRAY
-- Conversion binary to BCD
--
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DHT11_D_7Seg is
	port(
		clk_100k		: in		std_logic;										--100khz
		sensor_d	: inout	std_logic;
		
		seg_com	: OUT		STD_LOGIC_VECTOR(7 DOWNTO 0);				-- 7-SEGMENT COMMON SELECT 
		seg_data	: OUT		STD_LOGIC_VECTOR(7 DOWNTO 0)	);			-- 7-SEGMENT DATA 
end DHT11_D_7Seg;

architecture DHT11_D_7Seg of DHT11_D_7Seg is
	signal val_sensor : std_logic_vector(39 downto 0);				-- rhum:39~24, temp:23~8, checksum:7~0
	signal val_disp : std_logic_vector(31 downto 0);
	signal temp_val : std_logic_vector(7 downto 0);
	signal rhum_val : std_logic_vector(7 downto 0);
	
	component DHT11 is
		port(	clk		: in		std_logic;					--100khz
				dht11_d	: inout	std_logic;
				res_data	: out 	std_logic_vector(39 downto 0) );
	end component;
	
	component D_7SEG IS 
		PORT(	CLK : IN STD_LOGIC;											-- 1kHz
			DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			SEG_COM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);				-- 7-SEGMENT COMMON SELECT 
			SEG_DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	);			-- 7-SEGMENT DATA 
	END component; 

	function to_bcd ( bin : std_logic_vector ) return std_logic_vector is
		variable i : integer:=0;
		variable bcd : std_logic_vector(bin'length+3 downto 0) := (others => '0');
		variable bint : std_logic_vector(bin'length-1 downto 0) := bin;
	begin
		for i in 0 to bin'length-1 loop  -- repeating 8 times.
			bcd(bcd'length-1 downto 1) := bcd(bcd'length-2 downto 0);  --shifting the bits.
			bcd(0) := bint(bin'length-1);
			bint(bin'length-1 downto 1) := bint(bin'length-2 downto 0);
			bint(0) :='0';

			if(i < bin'length-1 and bcd(3 downto 0) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;

			if(i < bin'length-1 and bcd(7 downto 4) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

			if(i < bin'length-1 and bcd(11 downto 8) > "0100") then  --add 3 if BCD digit is greater than 4.
				bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;

			if(bin'length > 8 and i < bin'length-1 and bcd(15 downto 12) > "0100") then  --add 3 if BCD digit is greater than 4.
				bcd(15 downto 12) := bcd(15 downto 12) + "0011";
			end if;

			if(bin'length > 8 and i < bin'length-1 and bcd(19 downto 16) > "0100") then  --add 3 if BCD digit is greater than 4.
				bcd(19 downto 16) := bcd(19 downto 16) + "0011";
			end if;
		end loop;

		return bcd;
	end to_bcd;


begin

	rhum_val(7 downto 0) <= val_sensor(39 downto 32);
	temp_val(7 downto 0) <= val_sensor(23 downto 16);
	
	val_disp(31 downto 28) <= (31 downto 28 => '0');
	val_disp(27 downto 16) <= to_bcd(rhum_val);
	val_disp(15 downto 12) <= (15 downto 12 => '0');
	val_disp(11 downto  0) <= to_bcd(temp_val);
	
	temp	: DHT11	port map(clk_100k, sensor_d, val_sensor);
	disp	: D_7SEG	port map(clk_100k, val_disp, seg_com, seg_data);

end  DHT11_D_7Seg;

