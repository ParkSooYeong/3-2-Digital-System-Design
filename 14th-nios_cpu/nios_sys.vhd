library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nios_sys is
	port ( CLOCK_50 : in std_logic := '0';
			 RESETN	 : in std_logic := '1';
			 SW		 : in std_logic_vector(7 downto 0) := (others => '0');
			 LED		 : out std_logic_vector(7 downto 0) );
end entity nios_sys;

architecture embedded of nios_sys is

    component nios_cpu is
        port (
            clk_clk                               : in  std_logic                    := 'X';             -- clk
            reset_reset_n                         : in  std_logic                    := 'X';             -- reset_n
            pio_input_external_connection_export  : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
            pio_output_external_connection_export : out std_logic_vector(7 downto 0)                     -- export
        );
    end component nios_cpu;
	 
	 begin

    u0 : component nios_cpu
        port map (
            clk_clk                               => CLOCK_50,                               --                            clk.clk
            reset_reset_n                         => RESETN,                         --                          reset.reset_n
            pio_input_external_connection_export  => SW,  --  pio_input_external_connection.export
            pio_output_external_connection_export => LED  -- pio_output_external_connection.export
        );
end;
