LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.dot_fonts.all;
use work.ltp305.all;
 
ENTITY microdot_phat_driver IS
	port(
		sclk	: in std_logic;
		sda	: inout std_logic;
		scl	: inout std_logic;
		symbol	: in std_logic_vector(7 downto 0);
		dbg_cmd	: out std_logic;
		dbg_busy: out std_logic;
		dbg_st	: out std_logic_vector (3 downto 0));
END microdot_phat_driver;
 
ARCHITECTURE behavior OF microdot_phat_driver IS 
   attribute mark_debug	: string;
   attribute keep	: string;
   attribute dont_touch	: string;

   signal char_code : integer; -- := 32;
   signal ltp_addr : ltp_addr_t; -- := (i2c => 16#61#, module => '0');
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
         scl : INOUT  std_logic;
	 dbg_busy : out std_logic;
         dbg_st	: out std_logic_vector (3 downto 0)
        );
    END COMPONENT;

    attribute mark_debug of en_cmd : signal is "TRUE";
    attribute mark_debug of cnt_r : signal is "TRUE"; 	 
    attribute mark_debug of sclk : signal is "TRUE";  
    attribute mark_debug of sda : signal is "TRUE";  
    attribute mark_debug of scl : signal is "TRUE";  
    attribute mark_debug of symbol : signal is "TRUE";  
    attribute mark_debug of dbg_busy : signal is "TRUE";
    attribute mark_debug of dbg_st : signal is "TRUE";

    attribute keep of en_cmd : signal is "TRUE";
    attribute keep of cnt_r : signal is "TRUE"; 	 
    attribute keep of sclk : signal is "TRUE";  
    attribute keep of sda : signal is "TRUE";  
    attribute keep of scl : signal is "TRUE";  
    attribute keep of symbol : signal is "TRUE";  
    attribute keep of dbg_busy : signal is "TRUE";
    attribute keep of dbg_st : signal is "TRUE";

    attribute dont_touch of en_cmd : signal is "TRUE";
    attribute dont_touch of cnt_r : signal is "TRUE"; 	 
    attribute dont_touch of sclk : signal is "TRUE";  
    attribute dont_touch of sda : signal is "TRUE";  
    attribute dont_touch of scl : signal is "TRUE";  
    attribute dont_touch of symbol : signal is "TRUE";  
    attribute dont_touch of dbg_busy : signal is "TRUE";
    attribute dont_touch of dbg_st : signal is "TRUE";

BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: IS31FL3730_driver PORT MAP (
          sclk => sclk,
          char_code => char_code,
          dec_dot => dec_dot,
          ltp_addr => ltp_addr,
          en_cmd => en_cmd,
          sda => sda,
          scl => scl,
	  dbg_busy => dbg_busy,
          dbg_st => dbg_st);

	process(sclk) is
	begin
		if rising_edge(sclk) then
			cnt_r <= cnt_r + natural(1);
		end if;
	end process;

	process (cnt_r) is
	begin
		if (cnt_r mod 36_000_000 /= 0) then 
			en_cmd <= '1';
		else
			en_cmd <= '0';
		end if;

		dbg_cmd <= en_cmd;
	end process;

	process(symbol) is
		variable temp_char : integer := 0;
		variable temp_addr : ltp_addr_t := (0,'0');
	begin
		temp_char := to_integer(unsigned(symbol));
		temp_char := temp_char + 32;
		char_code <= temp_char;

		temp_addr.i2c := to_integer(unsigned(symbol(7 downto 1))) + 16#61#;
		temp_addr.module := symbol(0);
		ltp_addr <= temp_addr;
	end process;
END;
