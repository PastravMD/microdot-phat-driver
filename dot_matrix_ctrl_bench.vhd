----------------------------------------------------------------------------------------------------
-- test bench for the dot_matrix_ctrl core and the dot_fonts package
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;

entity testbench is
end testbench;

architecture behavior of testbench is 

	component dot_matrix_ctrl
		port(symbol_code:	in natural;
		     module_id:		in natural;
		     kick_cmd:		in std_logic;
		     valid_kick:	out std_logic;
		     dot_matrix:	out dot_matrix_t;
		     i2c_addr:		out natural;
		     module_sel:	out std_logic);
	end component;
	
	signal sym_code:	natural := 0;
	signal mod_id:	natural := 0;
	signal kick:		std_logic := '0';
	signal valid_kick:	std_logic := '0';
	signal module_sel:	std_logic := '0';
	signal i2c_addr:	natural := 0;
	signal matrix:		dot_matrix_t;

begin

	uut: dot_matrix_ctrl
	port map(symbol_code	=> sym_code,
		 module_id	=> mod_id,
		 kick_cmd	=> kick,
		 valid_kick	=> valid_kick,
		 dot_matrix	=> matrix,
		 i2c_addr	=> i2c_addr,
		 module_sel	=> module_sel);

	-- generate valid and invalid character codes and module numbers
	p1 : process
	begin
		wait for 6 ns;
		sym_code <= sym_code + 1;
		mod_id <= sym_code rem 8;
	end process p1;
	
	-- generate the kick signal. This is only propagated if the other inputs are valid
	p2 : process
	begin
		wait for 2 ns;
		if (kick = '0') then
			kick <= '1';
		else
			kick <= '0';
		end if;
	end process p2;

end;
