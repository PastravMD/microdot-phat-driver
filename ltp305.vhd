library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ltp305 is
	type ltp_addr_t is
		record
		i2c		: natural range 0 to 16#7F#;
		module		: std_logic;
		end record ltp_addr_t;

end package ltp305;

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- 
-- package body ltp305 is
-- begin
-- 
-- end package body ltp305;
