----------------------------------------------------------------------------------------------------
-- display matrix module specifics
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dot_fonts.all;

package dot_matrix_ctrl is

end package dot_matrix_ctrl;

package ltp305 body is

	type ltp305_info is
		record
			i2c_addr		: natural range 1 to 16#7F#;
			module_sel		: std_logic;
		end record ltp305_info;
	type display_module_array is array (1 to 6) of ltp305_info;


	-- FIXME: use a case structure instead
	-- address each LTP 305 dot matrix module using its controller's I2C address and the id
	constant display_modules : display_module_array := ((i2c_addr := 16#61#. module_sel := '0'),
							    (i2c_addr := 16#61#, module_sel := '1'),
							    (i2c_addr := 16#62#, module_sel := '0'),
							    (i2c_addr := 16#62#, module_sel := '1'),
							    (i2c_addr := 16#63#, module_sel := '0'),
							    (i2c_addr := 16#63#, module_sel := '1'));

	-- on the microdot pHat board the LTP305 display modules come in groups of 2, with each group
	-- being controlled by an IS31FL3730 driver. The 2 modules are also 'inversely' wired:
	-- the value that sets rows for the first module, sets the columns for the other. This function
	-- abstracts away this peculiarity, for more uniform control.
	function get_char_line(dots		: dot_matrix_t;
			       line_nr		: integer;
			       module_sel	: std_logic) return std_logic_vector is

		variable dl : std_logic_vector(7 downto 0);
	begin
		if module_sel = '0' then
			dl := row(line_nr, dots);
		else
			dl := col(line_nr, dots);
		end if;
		return dl;
	end function get_char_line;

end package ltp305;
