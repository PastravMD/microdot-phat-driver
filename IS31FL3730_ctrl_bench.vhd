
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
		      ack_error:	buffer std_logic;
		      sda:		inout  std_logic;
		      scl:		inout  std_logic);
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
	signal sda:		std_logic := '0';
	signal scl:		std_logic := '0';
	signal sym_code:	natural := 0;

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
		  ack_error => ack_error,
		  sda => sda,
		  scl => scl);


	clk_gen : process
	begin
		wait for 1 ns;
		if sclk = '0' then
			sclk <= '1';
		else
			sclk <= '0';
		end if;
	end process clk_gen;

	kick_gen : process
	begin
		wait for 1 ns;
		if kick_cmd = '0' then
			kick_cmd <= '1';
		else
			kick_cmd <= '0';
			wait for 299 ns;
		end if;
	end process kick_gen;

	content_gen : process
	begin
		wait for 300 ns;
		if sym_code > 34 then
			sym_code <= 0;
		else
			sym_code <= sym_code + 1;
		end if;
		dot_matrix <= get_dot_char(sym_code);

		if (sym_code rem 2 = 1) then
			module_sel <= '1';
		else
			module_sel <= '0';
		end if;
	end process content_gen;

	-- keep the busy line asserted for 1 clk cycle
	i2c_finish : process(ena, sclk)
	begin
		if rising_edge(ena) then
			device_busy <= '1';
		elsif device_busy = '1' then
			device_busy <= '0';
		end if;
	end process i2c_finish;
end;



