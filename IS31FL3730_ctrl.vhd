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

	      dbg_ps:		out natural;

	      reset_n:		out std_logic;
	      ena:		out std_logic;
	      addr:		out std_logic_vector(6 downto 0);
	      rw:		out std_logic;
	      txdata:		out std_logic_vector(7 downto 0);
	      ack_error:	buffer std_logic);
	end IS31FL3730_ctrl;

architecture arch of IS31FL3730_ctrl is
	type display_update_state is (st_ready, st_init_data_tx, st_byte_0, st_byte_1, st_byte_2, st_byte_3, st_byte_4, st_byte_5,
					st_byte_6, st_byte_7, st_end_data_tx, st_init_update, st_update_latch, st_end_data_tx2, st_init_cfg, st_update_cfg, st_finish);

attribute keep    :  string;
attribute mark_debug  :  string;
attribute dont_touch  :  string;

signal ns, ps		: display_update_state;

-- local signals required to latch input values when kicked
signal active_i2c_addr:	natural;
signal active_module:	std_logic;
signal active_symbol:	dot_matrix_t;

--signal end_data_cnt: natural;
signal delay_cnt: natural;

attribute mark_debug of ns : signal is "TRUE";
attribute mark_debug of ps : signal is "TRUE";
attribute mark_debug of active_i2c_addr : signal is "TRUE";
attribute mark_debug of active_module : signal is "TRUE";
attribute mark_debug of active_symbol : signal is "TRUE";

attribute keep of ns : signal is "TRUE";
attribute keep of ps : signal is "TRUE";
attribute keep of active_i2c_addr : signal is "TRUE";
attribute keep of active_module : signal is "TRUE";
attribute keep of active_symbol : signal is "TRUE";

attribute dont_touch of ns : signal is "TRUE";
attribute dont_touch of ps : signal is "TRUE";
attribute dont_touch of active_i2c_addr : signal is "TRUE";
attribute dont_touch of active_module : signal is "TRUE";
attribute dont_touch of active_symbol : signal is "TRUE";


begin
	sync_proc: process(sclk)
	begin
		if rising_edge(sclk) then
			-- only advance the state if the i2c controller is idle
			if device_busy = '0' or ns = st_init_data_tx or ns = st_init_update or ns = st_init_cfg or ns = st_ready then
				ps <= ns;
			end if;
			dbg_ps <= natural(display_update_state'POS(ps));
		end if;
	end process sync_proc;

	comb_proc: process(sclk, ps, kick_cmd, device_busy,
			   dot_matrix, i2c_addr, module_sel,
			   active_i2c_addr, active_module, active_symbol)
	begin
	if rising_edge(sclk) then
		case ps is
			when st_ready =>
				reset_n		<= '0';
				ena		<= '0';
				if kick_cmd = '1' then
					ns		<= st_init_data_tx; -- FIXME: make function for advancing the state ?
					active_symbol	<= dot_matrix;
					active_i2c_addr	<= i2c_addr;
					active_module 	<= module_sel;
					reset_n		<= '1';

					rw		<= '0';
					addr		<= std_logic_vector(to_unsigned(i2c_addr, 7)); -- not active_i2c_addr since that's not set atm in the process
					if module_sel = '0' then --not active_model in here
						txdata <= "00000001"; -- 0x1 mat 1 data reg address
					else
						txdata <= "00001110"; -- 0xE mat 2 data reg address
					end if;
				end if;
			when st_init_data_tx =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif delay_cnt < 60 then
					delay_cnt <= delay_cnt + 1;
					ena		<= '1';
				elsif device_busy = '1' then
					ns <= st_byte_0;
					txdata		<= get_char_line(active_symbol, 0, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_0 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_1;
					txdata		<= get_char_line(active_symbol, 1, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_1 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_2;
					txdata		<= get_char_line(active_symbol, 2, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_2 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_3;
					txdata		<= get_char_line(active_symbol, 3, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_3 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_4;
					txdata		<= get_char_line(active_symbol, 4, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_4 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_5;
					txdata		<= get_char_line(active_symbol, 5, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_5 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_6;
					txdata		<= get_char_line(active_symbol, 6, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_6 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_byte_7;
					txdata		<= get_char_line(active_symbol, 7, active_module);
					delay_cnt <= 0;
				end if;
			when st_byte_7 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ena		<= '0';
					ns <= st_end_data_tx;
					delay_cnt <= 0;
				end if;
			when st_end_data_tx =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				else
					ns <= st_init_update;
					txdata <= "00001100"; -- 0xC update reg address
					delay_cnt <= 0;
				end if;
			when st_init_update =>
				ena		<= '1';
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_update_latch;
					txdata <= "11111111";
					delay_cnt <= 0;
				end if;
			when st_update_latch =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_end_data_tx2;
					delay_cnt <= 0;
					ena		<= '0';
				end if;
			when st_end_data_tx2 =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				else
					ns <= st_init_cfg;
					txdata <= "00000000"; -- 0x0 config reg address
					delay_cnt <= 0;
				end if;
			when st_init_cfg =>
				ena		<= '1';
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_update_cfg;
					txdata <= "00011000";
					delay_cnt <= 0;
				end if;
			when st_update_cfg =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				elsif device_busy = '1' then
					ns <= st_finish;
					delay_cnt <= 0;
					ena		<= '0';
				end if;
			when st_finish =>
				if delay_cnt < 30 then
					delay_cnt <= delay_cnt + 1;
				else
					ns <= st_ready;
					delay_cnt <= 0;
				end if;
		end case;
	end if;
	end process comb_proc;

end arch;
