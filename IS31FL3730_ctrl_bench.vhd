
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dot_fonts.all;

entity IS31FL3730_testbench is
end IS31FL3730_testbench;

architecture behavior of IS31FL3730_testbench is 

	component IS31FL3730_ctrl
		port (sclk:		in std_logic;
		      kick_cmd:		in std_logic;
		      i2c_addr:		in natural;
		      module_sel:	in std_logic;
		      dot_matrix:	in dot_matrix_t;
		      device_busy:	in std_logic;

		      reset_n:		out std_logic;
		      ena:		out std_logic;
		      addr:		out std_logic_vector(6 downto 0);
		      rw:		out std_logic;
		      txdata:		out std_logic_vector(7 downto 0);
		      ack_error:	buffer std_logic);
	end component;

	signal sclk:		std_logic := '0';
	signal kick_cmd:	std_logic := '0';
	signal i2c_addr:	natural := 0;
	signal module_sel:	std_logic := '0';
	signal dot_matrix:	dot_matrix_t := get_dot_char(32);
	signal device_busy:	std_logic := '0';
	signal reset_n:		std_logic := '0';
	signal ena:		std_logic := '0';
	signal addr:		std_logic_vector(6 downto 0) := "0000000";
	signal rw:		std_logic := '0';
	signal txdata:		std_logic_vector(7 downto 0) := "00000000";
	signal ack_error:	std_logic := '0';
	signal sym_code:	natural := 0;
	signal clk_cnt:		natural := 0;

begin

-- component instantiation
uut: IS31FL3730_ctrl
	port map (sclk => sclk,
		  kick_cmd => kick_cmd,
		  i2c_addr => i2c_addr,
		  module_sel => module_sel,
		  dot_matrix => dot_matrix,
		  device_busy => device_busy,
		  reset_n => reset_n,
		  ena => ena,
		  addr => addr,
		  rw => rw,
		  txdata => txdata,
		  ack_error => ack_error);

	dot_matrix <= get_dot_char(sym_code);

	clk_gen : process
	begin
		wait for 1 ns;
		if sclk = '0' then
			sclk <= '1';
			clk_cnt <= clk_cnt + 1;
		else
			sclk <= '0';
		end if;
	end process clk_gen;

	-- generate kick pulse
	kick_cmd <= '1' when (clk_cnt rem 20 = 0) else
		    '0';

	-- run through all symbols
	symbol_gen : process(clk_cnt)
	begin
		if (clk_cnt rem 80 = 0) then
			if sym_code > 34 then
				sym_code <= 0;
			else
				sym_code <= sym_code + 1;
			end if;
		end if;
	end process symbol_gen;

	-- cycle both dot matrices connected to each controller
	matrix_module_select : process(clk_cnt)
	begin
		if (clk_cnt rem 20 = 0) then
			module_sel <= not module_sel;
		end if;
	end process matrix_module_select;

	-- cycle through all 3 controller addresses
	i2c_addr <= 16#61# + (clk_cnt rem 3) when (clk_cnt rem 40 = 0);

	-- keep the busy line asserted for 1 clk cycle
	i2c_finish : process(ena, sclk)
	begin
		if ena = '1' then
			if falling_edge(sclk) then
				device_busy <= '1';
			else
				device_busy <= '0';
			end if;
		end if;
	end process i2c_finish;
end;
