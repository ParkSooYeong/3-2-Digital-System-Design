library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity StopWatch is
	port( clk1k : in std_logic;
	   sw_reset : in std_logic;
	sw_strtstop : in std_logic; -- Value 
	   disp_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0') ); -- to display
end StopWatch;

architecture StopWatch of StopWatch is
	signal cnt1k : integer range 0 to 999;
	signal clk_sec : std_logic;
	signal strtstop : std_logic;
	signal sec, min : integer range 0 to 99;
begin
	P0 : process(sw_strtstop, sw_reset)
	begin
		if( sw_reset = '0' ) then -- If sw_reset, Stop watch
			strtstop <= '0'; --
		elsif( sw_strtstop'event and sw_strtstop ='1' ) then -- If sw_strtstop, 
			strtstop <= not strtstop; -- toggle signal strtstop
		end if;
	end process;

	P1 : process(sw_reset, strtstop, clk1k)
	begin
		if( sw_reset = '0' ) then -- If sw_reset, 
			cnt1k <= 0; -- Clear counter
		elsif( clk1k'event and clk1k ='1' and strtstop = '1' ) then
			if( cnt1k = 499 ) then -- If not, skip count.
				cnt1k <= 0; -- When cnt1k is 499
				clk_sec <= not clk_sec; -- toggle 1Hz Clock
			else
				cnt1k <= cnt1k + 1;
			end if;
		end if;
	end process;

	PSEC : process(sw_reset, clk_sec)
	begin
		if( sw_reset = '0' ) then -- If sw_reset, 
			sec <= 0; -- Clear sec
		elsif( clk_sec'event and clk_sec ='1' ) then
			if( sec /= 59 ) then
				sec <= sec + 1;
			else
				sec <= 0;
			end if;
		end if;
	end process;

	PMIN : process(sw_reset, clk_sec)
	begin
		if( sw_reset = '0' ) then -- If sw_reset, 
			min <= 0; -- Clear min
		elsif( clk_sec'event and clk_sec ='1' ) then
			if( sec = 59 ) then -- If sec counter is 59,
				if( min /= 59 ) then -- Count minute
					min <= min + 1;
				else
					min <= 0;
				end if;
			end if;
		end if;
	end process;

	P_OUT : process(sec, min)
		variable sec_base, sec_10, min_base, min_10 : INTEGER range 0 to 9;
	begin
		sec_10 := sec / 10;
		sec_base := sec - sec_10 * 10; -- sec mod 10;
		min_10 := min / 10;
		min_base := min - min_10 * 10; -- min mod 10;

		disp_val(3 downto 0) <= std_logic_vector(to_unsigned(sec_base, 4));
		disp_val(7 downto 4) <= std_logic_vector(to_unsigned(sec_10, 4));
		disp_val(11 downto 8) <= std_logic_vector(to_unsigned(min_base, 4));
		disp_val(15 downto 12) <= std_logic_vector(to_unsigned(min_10, 4));
	end process;
end StopWatch;
