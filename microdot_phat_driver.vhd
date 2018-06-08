library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;

entity microdot_phat_driver is
	port(sclk:		in std_logic;
	     sda:		inout std_logic;
	     scl:		inout std_logic;

	     kick_cmd:		buffer std_logic;
	     valid_kick:	buffer std_logic;
	     module_sel:	buffer std_logic;
	     dbg_module_id:	out std_logic_vector(2 downto 0);
	     dbg_i2c_addr:	out std_logic_vector(6 downto 0)
	    );
end microdot_phat_driver;

architecture behavior of microdot_phat_driver is

attribute keep    :  string;
attribute mark_debug  :  string;
attribute dont_touch  :  string;

	-- simulate external inputs
	signal clk_cnt:		natural;
	-- dot matrix controller
	signal sym_code:	natural;
	signal module_id:	natural;
--	signal kick_cmd:	std_logic;
	-- is31fl3730 controller
--	signal valid_kick:	std_logic;
	signal i2c_addr:	natural;
--	signal module_sel:	std_logic;
	signal dot_matrix:	dot_matrix_t;
	signal device_busy:	std_logic;
	signal reset_n:		std_logic;
	signal ena:		std_logic;
	signal addr:		std_logic_vector(6 downto 0);
	signal rw:		std_logic;
	signal txdata:		std_logic_vector(7 downto 0);
	-- unimplemented
	signal ack_err:		std_logic;
	signal ack_err2:	std_logic;
	signal data_rd:		std_logic_vector(7 downto 0);
	-- debug signals
	signal dbg_st:		std_logic_vector(3 downto 0);

attribute mark_debug of clk_cnt : signal is "TRUE";  
attribute mark_debug of sym_code : signal is "TRUE"; 
attribute mark_debug of module_id : signal is "TRUE";
attribute mark_debug of kick_cmd : signal is "TRUE";  
attribute mark_debug of valid_kick : signal is "TRUE";  
attribute mark_debug of i2c_addr : signal is "TRUE";  
attribute mark_debug of module_sel : signal is "TRUE";
attribute mark_debug of dot_matrix : signal is "TRUE";  
attribute mark_debug of device_busy : signal is "TRUE";  
attribute mark_debug of reset_n : signal is "TRUE";  
attribute mark_debug of ena : signal is "TRUE";  
attribute mark_debug of addr : signal is "TRUE"; 
attribute mark_debug of txdata : signal is "TRUE"; 
attribute mark_debug of ack_err : signal is "TRUE"; 
attribute mark_debug of ack_err2 : signal is "TRUE"; 
attribute mark_debug of data_rd : signal is "TRUE"; 

attribute keep of clk_cnt : signal is "TRUE";  
attribute keep of sym_code : signal is "TRUE"; 
attribute keep of module_id : signal is "TRUE";
attribute keep of kick_cmd : signal is "TRUE";  
attribute keep of valid_kick : signal is "TRUE";  
attribute keep of i2c_addr : signal is "TRUE";  
attribute keep of module_sel : signal is "TRUE";
attribute keep of dot_matrix : signal is "TRUE";  
attribute keep of device_busy : signal is "TRUE";  
attribute keep of reset_n : signal is "TRUE";  
attribute keep of ena : signal is "TRUE";  
attribute keep of addr : signal is "TRUE"; 
attribute keep of txdata : signal is "TRUE"; 
attribute keep of ack_err : signal is "TRUE"; 
attribute keep of ack_err2 : signal is "TRUE"; 
attribute keep of data_rd : signal is "TRUE"; 

attribute dont_touch of clk_cnt : signal is "TRUE";  
attribute dont_touch of sym_code : signal is "TRUE"; 
attribute dont_touch of module_id : signal is "TRUE";
attribute dont_touch of kick_cmd : signal is "TRUE";  
attribute dont_touch of valid_kick : signal is "TRUE";  
attribute dont_touch of i2c_addr : signal is "TRUE";  
attribute dont_touch of module_sel : signal is "TRUE";
attribute dont_touch of dot_matrix : signal is "TRUE";  
attribute dont_touch of device_busy : signal is "TRUE";  
attribute dont_touch of reset_n : signal is "TRUE";  
attribute dont_touch of ena : signal is "TRUE";  
attribute dont_touch of addr : signal is "TRUE"; 
attribute dont_touch of txdata : signal is "TRUE"; 
attribute dont_touch of ack_err : signal is "TRUE"; 
attribute dont_touch of ack_err2 : signal is "TRUE"; 
attribute dont_touch of data_rd : signal is "TRUE"; 


	component dot_matrix_ctrl is
		port(sclk:		in std_logic;
		     symbol_code:	in natural;
		     module_id:		in natural;
		     kick_cmd:		in std_logic;
		     valid_kick:	out std_logic;
		     dot_matrix:	out dot_matrix_t;
		     i2c_addr:		out natural;
		     module_sel:	out std_logic);
	end component dot_matrix_ctrl;

	component is31fl3730_ctrl
		port (sclk:		in std_logic;
		      kick_cmd:		in std_logic;
		      i2c_addr:		in natural;
		      module_sel:	in std_logic;
		      dot_matrix:	in dot_matrix_t;
		      device_busy:	in std_logic;
		      reset_n:		out std_logic;
		      ena:		out std_logic;
		      addr:		out std_logic_vector(6 downto 0);
		      rw:		out std_logic;
		      txdata:		out std_logic_vector(7 downto 0);
		      ack_error:	buffer std_logic);
	end component IS31FL3730_ctrl;

	component i2c_master is
		port(clk:		in     std_logic;                    --system clock
		     reset_n:		in     std_logic;                    --active low reset
		     ena:		in     std_logic;                    --latch in command
		     addr:		in     std_logic_vector(6 downto 0); --address of target slave
		     rw:		in     std_logic;                    --'0' is write, '1' is read
		     data_wr:		in     std_logic_vector(7 downto 0); --data to write to slave
		     busy:		out    std_logic;                    --indicates transaction in progress
		     data_rd:		out    std_logic_vector(7 downto 0); --data read from slave
		     ack_error:		buffer std_logic;                    --flag if improper acknowledge from slave
		     sda:		inout  std_logic;                    --serial data output of i2c bus
		     scl:		inout  std_logic;                    --serial clock output of i2c bus
		     dbg_state:		out    std_logic_vector(3 downto 0));
	end component i2c_master;

begin
	s1: dot_matrix_ctrl
	port map(sclk		=> sclk,
		 symbol_code	=> sym_code,
		 module_id	=> module_id,
		 kick_cmd	=> kick_cmd,
		 valid_kick	=> valid_kick,
		 dot_matrix	=> dot_matrix,
		 i2c_addr	=> i2c_addr,
		 module_sel	=> module_sel);

	s2: is31fl3730_ctrl
	port map(sclk		=> sclk,
		 kick_cmd	=> valid_kick,
		 i2c_addr	=> i2c_addr,
		 module_sel	=> module_sel,
		 dot_matrix	=> dot_matrix,
		 device_busy	=> device_busy,
		 reset_n	=> reset_n,
		 ena		=> ena,
		 addr		=> addr,
		 rw		=> rw,
		 txdata		=> txdata,
		 ack_error	=> ack_err2);

	s3: i2c_master
	port map(clk		=> sclk,
		 reset_n	=> reset_n,
		 ena		=> ena,
		 addr		=> addr,
		 rw		=> rw,
		 data_wr	=> txdata,
		 busy		=> device_busy,
		 data_rd	=> data_rd,
		 ack_error	=> ack_err,
		 sda		=> sda,
		 scl		=> scl,
		 dbg_state	=> dbg_st);

	clk_counter: process(sclk) is
	begin
		if rising_edge(sclk) then
			if clk_cnt < (natural'high - 1) then
				clk_cnt <= clk_cnt + 1;
			else
				clk_cnt <= 0;
			end if;
		end if;
	end process clk_counter;

	-- run through all symbols
	symbol_gen : process(kick_cmd)
	begin
		if falling_edge(kick_cmd) then
			if sym_code > 50 then
				sym_code <= 0;
			else
				sym_code <= sym_code + 1;
			end if;
		end if;
	end process symbol_gen;

	module_id <= (sym_code rem 7);

	kick_gen: process (clk_cnt) is
	begin
		if (clk_cnt mod 136 /= 0) then 
			kick_cmd <= '0';
		else
			kick_cmd <= '1';
		end if;
	end process kick_gen;

	-- debug signals assignments
	dbg_module_id <= std_logic_vector(to_unsigned(module_id, 3));
	dbg_i2c_addr <= std_logic_vector(to_unsigned(i2c_addr, 7));
end;
