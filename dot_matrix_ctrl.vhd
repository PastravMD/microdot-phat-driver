----------------------------------------------------------------------------------------------------
-- display matrix module specifics
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;

entity dot_matrix_ctrl is
	port(sclk:		in std_logic;
	     symbol_code:	in natural;
	     module_id:		in natural;
	     kick_cmd:		in std_logic;
	     valid_kick:	buffer std_logic; --out std_logic;
	     dot_matrix:	out dot_matrix_t;
	     i2c_addr:		out natural;
	     module_sel:	buffer std_logic); --out std_logic);
end dot_matrix_ctrl;


architecture arch of dot_matrix_ctrl is
	signal symbol_valid:	std_logic;
	signal module_valid:	std_logic;
begin

	-- propagate the kick signal only if the inputs are valid
	validate_kick: process(sclk, kick_cmd, symbol_valid, module_valid)
	begin
--		if rising_edge(kick_cmd) then
			if (kick_cmd = '1') and (symbol_valid = '1') and (module_valid = '1') then
				valid_kick <= '1';
			else
				valid_kick <= '0';
			end if;
--		end if;

	end process validate_kick;

	-- translate a character code (like ASCII) into a matrix of binary values
	symbol_translate: process(symbol_code)
	begin
		dot_matrix <= get_dot_char(symbol_code);
		if symbol_code < 20 then
			symbol_valid <= '1';
		else
			symbol_valid <= '0';
		end if;
	end process symbol_translate;

	-- address the n-th LTP305 module using the i2c address of the IS31FL27 LED controller that
	-- drives it and a binary value that indicates which of the 2 modules is driven
	-- NB: valid module numbers are 1 to 6, everything else including 0 are ignored
	id_translate: process(module_id)
	begin
		module_valid <= '1';
		case (module_id) is
			when 1 => i2c_addr <= 16#61#; module_sel <= '0';
			when 2 => i2c_addr <= 16#61#; module_sel <= '1';
			when 3 => i2c_addr <= 16#62#; module_sel <= '0';
			when 4 => i2c_addr <= 16#62#; module_sel <= '1';
			when 5 => i2c_addr <= 16#63#; module_sel <= '0';
			when 6 => i2c_addr <= 16#63#; module_sel <= '1';
			when others =>
				module_valid	<= '0';
				i2c_addr	<= 0;
				module_sel 	<= '0';
		end case;
	end process id_translate;
end arch;

