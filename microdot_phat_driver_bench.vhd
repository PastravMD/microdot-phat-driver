----------------------------------------------------------------------------------------------------
-- test bench for the microdot phat driver core
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;

entity phat_driver_testbench is
end phat_driver_testbench;

architecture behavior of phat_driver_testbench is 

	component microdot_phat_driver
		port(sclk:	in std_logic;
		     sda:	inout std_logic;
		     scl:	inout std_logic);
	end component;

	signal sclk:	std_logic := '0';
	signal sda:	std_logic := '0';
	signal scl:	std_logic := '0';
begin

	uut: microdot_phat_driver
	port map(sclk	=> sclk,
		 sda	=> sda,
		 scl	=> scl);

	p1 : process
	begin
		wait for 1 ns;
		sclk <= '0';
		wait for 1 ns;
		sclk <= '1';
	end process p1;
end;
