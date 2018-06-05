library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dot_fonts.all;

entity IS31FL3730_ctrl is
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
	end IS31FL3730_ctrl;

architecture arch of IS31FL3730_ctrl is
	type display_update_state is (st_ready, st_init_data_tx, st_byte_0, st_byte_1, st_byte_2, st_byte_3, st_byte_4, st_byte_5,
					st_byte_6, st_byte_7, st_end_data_tx, st_init_update, st_update_latch, st_finish);

	signal ns, ps		: display_update_state;

	-- local signals required to latch input values when kicked
	signal active_i2c_addr:	natural;
	signal active_module:	std_logic;
	signal active_symbol:	dot_matrix_t;
begin
	sync_proc: process(sclk, ns)
	begin
		if (rising_edge(sclk)) then
			ps <= ns;
		end if;
	end process sync_proc;

	comb_proc: process(ps, kick_cmd, device_busy)
	begin
		case ps is
			when st_ready =>
				reset_n		<= '0';
				if kick_cmd = '1' then
					ns		<= st_init_data_tx; -- FIXME: make function for advancing the state ?
					active_symbol	<= dot_matrix;
					active_i2c_addr	<= i2c_addr;
					active_module 	<= module_sel;
				end if;
			when st_init_data_tx =>
				reset_n		<= '1';
				ena		<= '1';
				rw		<= '0';
				addr		<= std_logic_vector(to_unsigned(active_i2c_addr, 7));
				if active_module = '0' then
					txdata <= "00000001"; -- 0x1 mat 1 data reg address
				else
					txdata <= "00001110"; -- 0xE mat 2 data reg address
				end if;

				if device_busy = '0' then
					ns <= st_byte_0;
				end if;
			when st_byte_0 =>
				txdata		<= get_char_line(active_symbol, 0, active_module);
				if device_busy = '0' then
					ns <= st_byte_1;
				end if;
			when st_byte_1 =>
				txdata		<= get_char_line(active_symbol, 1, active_module);
				if device_busy = '0' then
					ns <= st_byte_2;
				end if;
			when st_byte_2 =>
				txdata		<= get_char_line(active_symbol, 2, active_module);
				if device_busy = '0' then
					ns <= st_byte_3;
				end if;
			when st_byte_3 =>
				txdata		<= get_char_line(active_symbol, 3, active_module);
				if device_busy = '0' then
					ns <= st_byte_4;
				end if;
			when st_byte_4 =>
				txdata		<= get_char_line(active_symbol, 4, active_module);
				if device_busy = '0' then
					ns <= st_byte_5;
				end if;
			when st_byte_5 =>
				txdata		<= get_char_line(active_symbol, 5, active_module);
				if device_busy = '0' then
					ns <= st_byte_6;
				end if;
			when st_byte_6 =>
				txdata		<= get_char_line(active_symbol, 6, active_module);
				if device_busy = '0' then
					ns <= st_byte_7;
				end if;
			when st_byte_7 =>
				txdata		<= get_char_line(active_symbol, 7, active_module);
				if device_busy = '0' then
					ns <= st_end_data_tx;
				end if;
			when st_end_data_tx =>
				ena		<= '0';
				ns <= st_init_update;
			when st_init_update =>
				ena		<= '1';
				txdata <= "00001100"; -- 0xC update reg address
				if device_busy = '0' then
					ns <= st_update_latch;
				end if;
			when st_update_latch =>
				txdata <= "11111111";
				if device_busy = '0' then
					ns <= st_finish;
				end if;
			when st_finish =>
				ena		<= '0';
				reset_n		<= '0';
				ns <= st_ready;
			when others =>
				ns <= st_ready;
		end case;
	end process comb_proc;

end arch;
