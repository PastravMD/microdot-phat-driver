----------------------------------------------------------------------------------------------------
-- the fonts package contains the dot-maxtrix values and functions required for displaying symbols
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TODO: add support for decimal dot
package dot_fonts is
	type dot_char_t is 
		array (6 downto 0, 4 downto 0) of std_logic;

	function get_dot_char(ascii_code : integer) return dot_char_t;
	function col(x : integer; dots : dot_char_t) return std_logic_vector;
	function row(y : integer; dots : dot_char_t) return std_logic_vector;
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

	function col(x : integer; dots : dot_char_t) return std_logic_vector is
	begin
		return '0' & dots(6, x) & dots(5, x) & dots(4, x) & dots(3, x) & 
			dots(2, x) & dots(1, x) & dots(0, x);
	end function col;

	function row(y : integer; dots : dot_char_t) return std_logic_vector is
	begin
		return "000" & dots(y, 4) & dots(y, 3) & dots(y, 2) & dots(y, 1) & dots(y, 0);
	end function row;

end package body dot_fonts;

	type dot_matrix_t is array (6 downto 0, 4 downto 0) of std_logic;
	function get_dot_char(ascii_code:natural) return dot_matrix_t;
	function col(x : natural; dots: dot_matrix_t) return std_logic_vector;
	function row(y : natural; dots: dot_matrix_t) return std_logic_vector;
	function get_char_line(dots:		dot_matrix_t;
			       line_nr:		natural;
			       module_sel:	std_logic) return std_logic_vector;
		when 0  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 1  => dot_char := (('1','0','0','0','0'),
					('1','0','0','0','0'),
					('1','0','0','0','0'),
					('1','0','0','0','0'),
					('1','0','0','0','0'),
					('1','0','0','0','0'),
					('1','0','0','0','0'));
		when 2  => dot_char := (('0','1','0','0','0'),
					('0','1','0','0','0'),
					('0','1','0','0','0'),
					('0','1','0','0','0'),
					('0','1','0','0','0'),
					('0','1','0','0','0'),
					('0','1','0','0','0'));
		when 3  => dot_char := (('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'));
		when 4  => dot_char := (('0','0','0','1','0'),
					('0','0','0','1','0'),
					('0','0','0','1','0'),
					('0','0','0','1','0'),
					('0','0','0','1','0'),
					('0','0','0','1','0'),
					('0','0','0','1','0'));
		when 5  => dot_char := (('0','0','0','0','1'),
					('0','0','0','0','1'),
					('0','0','0','0','1'),
					('0','0','0','0','1'),
					('0','0','0','0','1'),
					('0','0','0','0','1'),
					('0','0','0','0','1'));
		when 6  => dot_char := (('1','1','1','1','1'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 7  => dot_char := (('0','0','0','0','0'),
					('1','1','1','1','1'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 8  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('1','1','1','1','1'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 9  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('1','1','1','1','1'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 10  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('1','1','1','1','1'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 11  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('1','1','1','1','1'),
					('0','0','0','0','0'));
		when 12  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'),
					('1','1','1','1','1'));
		when 13  => dot_char := (('1','0','1','0','1'),
					('0','1','0','1','0'),
					('1','0','1','0','1'),
					('0','1','0','1','0'),
					('1','0','1','0','1'),
					('0','1','0','1','0'),
					('1','0','1','0','1'));
		when 14  => dot_char := (('1','0','0','0','0'),
					('0','1','0','0','0'),
					('0','0','1','1','0'),
					('0','0','1','1','0'),
					('0','0','1','1','0'),
					('0','0','0','0','1'),
					('0','0','0','0','0'));
		when 15  => dot_char := (('0','0','0','0','0'),
					('0','1','1','1','0'),
					('0','1','0','1','0'),
					('0','1','0','1','0'),
					('0','1','0','1','0'),
					('0','1','1','1','0'),
					('0','0','0','0','0'));
		when 16  => dot_char := (('0','0','0','0','0'),
					('0','0','0','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','1','0','0'),
					('0','0','0','0','0'),
					('0','0','0','0','0'));
		when 17  => dot_char := (('1','1','1','1','1'),
					('1','0','0','0','1'),
					('1','0','0','0','1'),
					('1','0','0','0','1'),
					('1','0','0','0','1'),
					('1','0','0','0','1'),
					('1','1','1','1','1'));

		when others => dot_char := (('1','1','1','1','1'),
					    ('1','1','1','1','1'),
					    ('1','1','1','1','1'),
					    ('1','1','1','1','1'),
					    ('1','1','1','1','1'),
					    ('1','1','1','1','1'),
					    ('1','1','1','1','1'));
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
