--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:00:31 03/09/2018
-- Design Name:   
-- Module Name:   D:/Projects/FPGAs/dotdisplaydriver/tb_microdot_phat.vhd
-- Project Name:  dotdisplaydriver
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IS31FL3730_driver
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.dot_fonts.all;
use work.ltp305.all;
 
ENTITY microdot_phat_driver IS
	port(
		sclk	: in std_logic;
		en_dbg	: out std_logic;
		sda	: inout std_logic;
		scl	: inout std_logic);
END microdot_phat_driver;
 
ARCHITECTURE behavior OF microdot_phat_driver IS 
   attribute mark_debug	: string;

   constant char_code : integer := 32;
   constant ltp_addr : ltp_addr_t := (i2c => 16#61#, module => '0');
   constant dec_dot : std_logic := '0';
   signal en_cmd : std_logic := '1';
   signal cnt_r : natural := 0;

    COMPONENT IS31FL3730_driver
    PORT(
         sclk : IN  std_logic;
         char_code : IN  integer;
         dec_dot : IN  std_logic;
         ltp_addr : IN  ltp_addr_t;
         en_cmd : IN  std_logic;
         sda : INOUT  std_logic;
         scl : INOUT  std_logic
        );
    END COMPONENT;

    attribute mark_debug of en_cmd : signal is "TRUE";
    attribute mark_debug of cnt_r : signal is "TRUE"; 	 
    attribute mark_debug of sclk : signal is "TRUE";  
    attribute mark_debug of sda : signal is "TRUE";  
    attribute mark_debug of scl : signal is "TRUE";  
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: IS31FL3730_driver PORT MAP (
          sclk => sclk,
          char_code => char_code,
          dec_dot => dec_dot,
          ltp_addr => ltp_addr,
          en_cmd => en_cmd,
          sda => sda,
          scl => scl
        );

	process(sclk) is
	begin
		if rising_edge(sclk) then
			cnt_r <= cnt_r + natural(1);
		end if;
	end process;

	process (cnt_r) is
	begin
		if (cnt_r mod 40_000_000 /= 0) then 
			en_cmd <= '1';
			en_dbg <= '1';
		else
			en_cmd <= '0';
			en_dbg <= '0';
		end if;
	end process;
END;
