library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dot_fonts is
	type dot_char_t is 
		array (6 downto 0, 4 downto 0) of std_logic;

	function get_dot_char(ascii_code : integer) return dot_char_t;
	function col(x : integer; dots : dot_char_t) return std_logic_vector;
	function row(y : integer; dots : dot_char_t) return std_logic_vector;
	function dotline(dots : dot_char_t;
			line_nr : integer;
			module_sel : std_logic) return std_logic_vector;
end package dot_fonts;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package body dot_fonts is
	function get_dot_char(ascii_code : integer) return dot_char_t is
		variable dot_char : dot_char_t;
	begin
	case ascii_code is
		when 32   => dot_char := (('0','0','1','0','0'),
					  ('0','0','1','0','0'),
					  ('0','0','1','0','0'),
					  ('0','0','1','0','0'),
					  ('0','0','1','0','0'),
					  ('0','0','1','0','0'),
					  ('0','0','1','0','0'));

		when others => dot_char := (('0','1','0','1','0'),
					    ('0','1','0','1','0'),
					    ('0','1','0','1','0'),
					    ('0','1','0','1','0'),
					    ('0','1','0','1','0'),
					    ('0','1','0','1','0'),
					    ('0','1','0','1','0'));
	end case;
	return dot_char;
	end function get_dot_char;

	function col(x : integer; dots : dot_char_t) return std_logic_vector is
	begin
		return '0' & dots(6, x) & dots(5, x) & dots(4, x) & dots(3, x) & 
			dots(2, x) & dots(1, x) & dots(0, x);
	end function col;

	function row(y : integer; dots : dot_char_t) return std_logic_vector is
	begin
		return "000" & dots(y, 4) & dots(y, 3) & dots(y, 2) & dots(y, 1) & dots(y, 0);
	end function row;

	function dotline(dots : dot_char_t;
			line_nr : integer;
			module_sel : std_logic) return std_logic_vector is

		variable dl : std_logic_vector(7 downto 0);
	begin
		if module_sel = '0' then
			dl := row(line_nr, dots);
		else
			dl := col(line_nr, dots);
		end if;
		return dl;
	end function dotline;

end package body dot_fonts;
