----------------------------------------------------------------------------------------------------
-- the fonts package contains the dot-maxtrix values and functions required for displaying symbols
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TODO: add support for decimal dot
package dot_fonts is
	type dot_matrix_t is array (6 downto 0, 4 downto 0) of std_logic;

	function get_dot_char(ascii_code:natural) return dot_matrix_t;
	function col(x : natural; dots: dot_matrix_t) return std_logic_vector;
	function row(y : natural; dots: dot_matrix_t) return std_logic_vector;
	function get_char_line(dots:		dot_matrix_t;
			       line_nr:		natural;
			       module_sel:	std_logic) return std_logic_vector;
end package dot_fonts;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package body dot_fonts is

	-- returns the value of the dot matrix associated with an ASCII code
	function get_dot_char(ascii_code : natural) return dot_matrix_t is
		variable dot_char : dot_matrix_t;
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

	-- extracts a column from the given dot matrix
	function col(x : natural; dots : dot_matrix_t) return std_logic_vector is
	begin
		if x < 5 then
			return '0' & dots(6, x) & dots(5, x) & dots(4, x) & dots(3, x) & dots(2, x) & dots(1, x) & dots(0, x);
		else
			return "00000000";
		end if;
	end function col;

	-- extracts a row from the given dot matrix
	function row(y : natural; dots : dot_matrix_t) return std_logic_vector is
	begin
		if y < 7 then
			return "000" & dots(y, 4) & dots(y, 3) & dots(y, 2) & dots(y, 1) & dots(y, 0);
		else
			return "00000000";
		end if;

	end function row;
	-- on the microdot pHat board the LTP305 display modules come in groups of 2, with each group
	-- being controlled by an IS31FL3730 driver. The 2 modules are also 'inversely' wired:
	-- the IS31FL register that sets rows for the first module, sets the columns for the other. This function
	-- abstracts away this peculiarity, for more uniform control.
	function get_char_line(dots:		dot_matrix_t;
			       line_nr:		natural;
			       module_sel:	std_logic) return std_logic_vector is

		variable dl : std_logic_vector(7 downto 0);
	begin
		if module_sel = '0' then
			dl := row(line_nr, dots);
		else
			dl := col(line_nr, dots);
		end if;
		return dl;
	end function get_char_line;

end package body dot_fonts;
