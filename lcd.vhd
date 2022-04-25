library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lcd is
	port(	clk, strobe		: in std_logic;
			address			: in std_logic_vector(6 downto 0);
			data           	: in std_logic_vector(7 downto 0);
			e, rs, rw, busy	: out std_logic;
			lcd_data       	: out std_logic_vector(7 downto 0) );
end lcd;

architecture sample of lcd is
	constant	add_line_1			: std_logic_vector(7 downto 0) := "10000000";
	constant	add_line_2			: std_logic_vector(7 downto 0) := "11000000";
	constant	system_set			: std_logic_vector(7 downto 0) := "00111000";
	constant	clear_display		: std_logic_vector(7 downto 0) := "00000001";
	constant	entry_mode_set		: std_logic_vector(7 downto 0) := "00000110";
	constant	display_onoff		: std_logic_vector(7 downto 0) := "00001100";
	signal 	internal_count, max_count : std_logic_vector(3 downto 0);
	type		lcd_states is (t0, t1, t2);
	signal	state : lcd_states;
	signal	addr : std_logic_vector(6 downto 0);
begin
	P_MKENB : process(clk, strobe, address)
	begin
		if strobe = '1' then
				state <= t0; 
				addr <= address;
				e <= '0';
		elsif (clk'event and clk = '1') then
			case state is
				when t0 =>
					state <= t1;
					e <= '1';
				when t1 =>
					state <= t2;
					e <= '0';
				when t2 =>
					if internal_count /= max_count then
						state <= t0;
					end if;
					e <= '0';
			end case;
		end if; 
	end process;

	P_MKBUSY : process(clk, strobe)
	begin
		if strobe = '1' then
			internal_count <= "0000";
			busy <= '1';
		elsif (clk'event and clk = '1') then
			if state=t2 then 
				if internal_count = max_count then
					busy <= '0';
				else
					internal_count <= internal_count + 1;
				end if;
			end if;
		end if; 
	end process;
    
	P_NOOP : process(addr, data)
	begin
		if addr = "0000000" then
			max_count <= "0101";
		elsif addr = "1000000" then
			max_count <= "0001";
		else
			max_count <= "0000";
		end if;
	end process;
   
	P_OUT : process(addr, internal_count, data)
	begin
		case addr is
			when "0000000" => 
					case internal_count is
						when "0000"=>           
							rs <= '0';
							rw <= '0';
							lcd_data <=  system_set;
						when "0001" =>            
							rs <= '0';
							rw <= '0';
							lcd_data <= clear_display;
						when "0010"=>
							rs <= '0';
							rw <= '0';
							lcd_data <= entry_mode_set;
						when "0011"=>             
							rs <= '0';
							rw <= '0';
							lcd_data <= display_onoff;  
						when "0100"=>             
							rs <= '0';
							rw <= '0';
							lcd_data <= add_line_1;
						when others =>             
							rs <= '1';
							rw <= '0';
							lcd_data <= data;		--enter_data;
					end case;
			when "1000000" => 
					case internal_count is
						when "0000" =>           
							rs <= '0';
							rw <= '0';
							lcd_data <= add_line_2;
						when others =>             
							rs <= '1';
							rw <= '0';
							lcd_data <= data;
					end case;
			when others => 
				rs <= '1';
				rw <= '0';
				lcd_data <= data;
			end case;
  	end process;
end sample;