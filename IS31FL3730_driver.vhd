library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;
use work.ltp305.all;

entity IS31FL3730_driver is
--	generic	();
	port (	sclk		: in	std_logic;
		char_code 	: in	integer;
		dec_dot		: in	std_logic;
		ltp_addr	: in	ltp_addr_t;
		en_cmd		: in	std_logic;
		sda		: inout std_logic;
		scl		: inout std_logic);
end IS31FL3730_driver;

architecture arch of IS31FL3730_driver is 
	type ltp_update_state is (st_ready, st_init_data_tx, st_byte_0, st_byte_1, st_byte_2, st_byte_3, st_byte_4, st_byte_5, 
					st_byte_6, st_byte_7, st_end_data_tx, st_init_update, st_update_latch, st_finish);
	signal ns, ps		: ltp_update_state;
	signal nrst		: std_logic;
	signal ena		: std_logic;
	signal rw		: std_logic;
	signal addr		: std_logic_vector(6 downto 0); 
	signal txdata		: std_logic_vector(7 downto 0);
	signal rxdata		: std_logic_vector(7 downto 0);
	signal ack_t		: std_logic;
	signal busy       	: std_logic;
		
	attribute mark_debug : string;
	attribute mark_debug of nrst : signal is "TRUE";
	attribute mark_debug of ena : signal is "TRUE";
	attribute mark_debug of rw : signal is "TRUE";
	attribute mark_debug of addr : signal is "TRUE";
	attribute mark_debug of txdata : signal is "TRUE";
	attribute mark_debug of rxdata : signal is "TRUE";
	attribute mark_debug of ack_t : signal is "TRUE";
	
	attribute mark_debug of sclk : signal is "TRUE";
	attribute mark_debug of scl : signal is "TRUE";
	attribute mark_debug of sda : signal is "TRUE";
	attribute mark_debug of busy : signal is "TRUE";

	component i2c_master
		generic(	input_clk : integer := 12_000_000; --input clock speed from user logic in hz
				bus_clk   : integer := 100_000);   --speed the i2c bus (scl) will run at in hz	

		port(	clk       : in     std_logic;                    --system clock
			reset_n   : in     std_logic;                    --active low reset
			ena       : in     std_logic;                    --latch in command
			addr      : in     std_logic_vector(6 downto 0); --address of target slave
			rw        : in     std_logic;                    --'0' is write, '1' is read
			data_wr   : in     std_logic_vector(7 downto 0); --data to write to slave
			busy      : out    std_logic;                    --indicates transaction in progress
			data_rd   : out    std_logic_vector(7 downto 0); --data read from slave
			ack_error : buffer std_logic;                    --flag if improper acknowledge from slave
			sda       : inout  std_logic;                    --serial data output of i2c bus
			scl       : inout  std_logic);                   --serial clock output of i2c bus
	end component;

begin
	i2c_controller: i2c_master
	generic map (12_000_000, 100_000)
	port map(	clk		=> sclk,
			reset_n 	=> nrst,
			ena		=> ena,
			addr		=> addr,
			rw		=> rw,
			data_wr		=> txdata,
			data_rd		=> rxdata,
			busy		=> busy,
			ack_error	=> ack_t,
			sda		=> sda, 
			scl		=> scl);

	sync_proc: process(sclk, ns)
	begin
		if (rising_edge(sclk)) then
			ps <= ns;
		end if;
	end process sync_proc;

	comb_proc: process(ps, en_cmd, busy)
		variable dot_char : dot_char_t;
	begin
		
		case ps is
			when st_ready =>
				nrst		<= '1';
				if rising_edge(en_cmd) then
					ns <= st_init_data_tx;
				end if;
			when st_init_data_tx =>
				dot_char 	:= get_dot_char(char_code);
				ena		<= '1';
				rw		<= '0';
				addr		<= std_logic_vector(to_unsigned(ltp_addr.i2c, 7));
				if ltp_addr.module = '0' then
					txdata <= "00000001"; -- 0x1 mat 1 data reg address
				else
					txdata <= "00001110"; -- 0xE mat 2 data reg address
				end if;

				if rising_edge(busy) then
					ns <= st_byte_0;
				end if;
			when st_byte_0 =>
				txdata		<= dotline(dot_char, 0, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_1;
				end if;
			when st_byte_1 =>
				txdata		<= dotline(dot_char, 1, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_2;
				end if;
			when st_byte_2 =>
				txdata		<= dotline(dot_char, 2, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_3;
				end if;
			when st_byte_3 =>
				txdata		<= dotline(dot_char, 3, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_4;
				end if;
			when st_byte_4 =>
				txdata		<= dotline(dot_char, 4, ltp_addr.module);
				if rising_edge(busy)  then
					ns <= st_byte_5;
				end if;
			when st_byte_5 =>
				txdata		<= dotline(dot_char, 5, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_6;
				end if;
			when st_byte_6 =>
				txdata		<= dotline(dot_char, 6, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_byte_7;
				end if;
			when st_byte_7 =>
				txdata		<= dotline(dot_char, 7, ltp_addr.module);
				if rising_edge(busy) then
					ns <= st_end_data_tx;
				end if;
			when st_end_data_tx =>
				ena		<= '0';
				ns <= st_init_update;
			when st_init_update =>
				ena		<= '1';
				txdata <= "00001100"; -- 0xC update reg address
				if rising_edge(busy) then
					ns <= st_update_latch;
				end if;
			when st_update_latch =>
				txdata <= "11111111";
				if rising_edge(busy) then
					ns <= st_finish;
				end if;
			when st_finish =>
				ena		<= '0';
				nrst		<= '0';
				ns <= st_ready;
			when others => NULL;
		end case;
	end process comb_proc;
end arch;
