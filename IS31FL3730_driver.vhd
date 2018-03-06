----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:23:39 02/24/2018 
-- Design Name: 
-- Module Name:    IS31FL3730_driver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dot_fonts.all;

entity IS31FL3730_driver is
	port(	sclk		: in std_logic;
			scl		: inout std_logic;
			sda		: inout std_logic;
			ack_err	: out std_logic;
			dbg_st	: out std_logic_vector (3 downto 0));
end IS31FL3730_driver;

architecture stimulus of IS31FL3730_driver is 

	component i2c_master
   generic(
    input_clk : integer := 12_000_000; --input clock speed from user logic in hz
    bus_clk   : integer := 100_000);   --speed the i2c bus (scl) will run at in hz	
	port(
	    clk       : in     std_logic;                    --system clock
	    reset_n   : in     std_logic;                    --active low reset
	    ena       : in     std_logic;                    --latch in command
	    addr      : in     std_logic_vector(6 downto 0); --address of target slave
	    rw        : in     std_logic;                    --'0' is write, '1' is read
	    data_wr   : in     std_logic_vector(7 downto 0); --data to write to slave
	    busy      : out    std_logic;                    --indicates transaction in progress
	    data_rd   : out    std_logic_vector(7 downto 0); --data read from slave
	    ack_error : buffer std_logic;                    --flag if improper acknowledge from slave
	    sda       : inout  std_logic;                    --serial data output of i2c bus
	    scl       : inout  std_logic;                    --serial clock output of i2c bus
		 dbg_state : out std_logic_vector(3 downto 0));
	end component;

attribute	keep			:	string;
attribute	mark_debug	:	string;

-- signals --
	signal nrst			: std_logic;
	signal ena			: std_logic;
	signal rw			: std_logic;
	signal addr			: std_logic_vector(6 downto 0); 
	signal txdata		: std_logic_vector(7 downto 0);
	signal rxdata		: std_logic_vector(7 downto 0);
	signal ack_t		: std_logic;
	signal busy_cnt   : integer := 0;
	--signal counter    : integer := 0;
	
	signal busy_prev  : std_logic;
	signal busy       : std_logic;
	
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
attribute mark_debug of ack_err : signal is "TRUE";
attribute mark_debug of busy : signal is "TRUE";
attribute mark_debug of dbg_st : signal is "TRUE";
attribute mark_debug of busy_prev : signal is "TRUE";
attribute mark_debug of busy_cnt : signal is "TRUE";
--attribute mark_debug of counter  : signal is "TRUE";

begin
	i2c_controller: i2c_master
	generic map (12_000_000, 100_000)
	port map(	 clk			=> sclk,
                reset_n 	=> nrst,
                ena			=> ena,
                addr			=> addr,
                rw			=> rw,
                data_wr		=> txdata,
                data_rd		=> rxdata,
                busy			=> busy,
                ack_error	=> ack_t,
                sda			=> sda, 
                scl			=> scl,
                dbg_state	=> dbg_st);

	ack_err <= ack_t;
	nrst	<= '1';

	fun: process(sclk,busy)
		variable dot_char : dot_char_t;
	begin
	if (rising_edge(sclk)) then
	  --counter <= counter + 1;
	  busy_prev <= busy;                             --capture the value of the previous i2c busy signal
	  IF(busy_prev = '0' AND busy = '1') THEN        --i2c busy just went high
		 busy_cnt <= busy_cnt + 1;                    --counts the times busy has gone from low to high during transaction
	  elsif (busy = '0') and ((busy_cnt = 13) or (busy_cnt = 26) or (busy_cnt = 30)) then
		busy_cnt <= busy_cnt + 1;
	  end if;
	  
	  CASE busy_cnt IS                             --busy_cnt keeps track of which command we are on
		 WHEN 0 =>                                  --no command latched in yet
			ena <= '1';                            --initiate the transaction
			addr <= "1100001";                    --set the address of the slave
			rw <= '0';                             --command 1 is a write
			txdata <= "00000000";    --cfg register address = 0x0
		 WHEN 1 =>
			txdata <= "00011000";   -- enable digits 1 & 2                         
		 WHEN 2 => -- 1 (matrix 1 data)
			dot_char := get_dot_char(33);
			txdata <= row(0, dot_char);   			
		 WHEN 3 => -- 2       
			dot_char := get_dot_char(33);
			txdata <= row(1, dot_char); 
		 WHEN 4 => -- 3    
			dot_char := get_dot_char(33);
			txdata <= row(2, dot_char);
		 WHEN 5 => -- 4      
			dot_char := get_dot_char(33);
			txdata <= row(3, dot_char);
		 WHEN 6 => -- 5       
			dot_char := get_dot_char(33);
			txdata <= row(4, dot_char);
		 WHEN 7 => -- 6
			dot_char := get_dot_char(33);
			txdata <= row(5, dot_char);
		 WHEN 8 => -- 7      
			dot_char := get_dot_char(33);
			txdata <= row(6, dot_char);
		 WHEN 9 =>   -- NC
			txdata <= "00000000";
		 WHEN 10 =>	 -- NC                               
			txdata <= "00000000"; 
		 WHEN 11 =>  -- NC                                 
			txdata <= "00000000";   
		 WHEN 12 =>  -- NC                                 
			txdata <= "00000000"; 			
		 WHEN 13 =>  
			ena <= '0';                -- end transmission to start a new one   		 		                 
		 WHEN 14 =>		   
			ena <= '1';                -- start new transmission					
			txdata(7) <= '0'; -- matrix 2 data address = 0xE
			txdata(6) <= '0';
			txdata(5) <= '0';
			txdata(4) <= '0';
			txdata(3) <= '1';
			txdata(2) <= '1';
			txdata(1) <= '1';
			txdata(0) <= '0';
		 WHEN 15 => -- 1 (matrix 2 data) 
			dot_char := get_dot_char(32);
			txdata <= col(0, dot_char);                   
		 WHEN 16 =>  -- 2
			dot_char := get_dot_char(32);
			txdata <= col(1, dot_char);                   
		 WHEN 17 =>	 -- 3                                 
			dot_char := get_dot_char(32);
			txdata <= col(2, dot_char);                   
		 WHEN 18 => -- 4
			dot_char := get_dot_char(32);
			txdata <= col(3, dot_char);                   
		 WHEN 19 => -- 5
			dot_char := get_dot_char(32);
			txdata <= col(4, dot_char);                   
		 WHEN 20 => -- 6
			dot_char := get_dot_char(32);
			txdata <= col(4, dot_char);                   
		 WHEN 21 => -- 7
			dot_char := get_dot_char(32);
			txdata <= col(4, dot_char);                     
		 WHEN 22 => -- 8 (decimal dot)			
			txdata <= "01000000";                  
		 WHEN 23 => -- NC
			txdata <= "00000000";                    
		 WHEN 24 => -- NC                              
			txdata <= "00000000";
		 WHEN 25 => -- NC                                 
			txdata <= "00000000";                  
		 WHEN 26 =>
			ena <= '0';                -- end transmission to start a new one   		 		                 
		 WHEN 27 =>
			ena <= '1';                -- start new transmission	                  
			txdata(7) <= '0';
			txdata(6) <= '0';
			txdata(5) <= '0';
			txdata(4) <= '0';
			txdata(3) <= '1';
			txdata(2) <= '1';
			txdata(1) <= '0';
			txdata(0) <= '0';
		 WHEN 28 =>
			txdata <= "11111111";     -- latch LED values                   
		 WHEN 29 =>
			txdata <= "00000000";     -- led intensity 
		 WHEN 30 =>
			ena <= '0'; 
		 WHEN 31 =>	
			busy_cnt <= 0;
		 WHEN OTHERS => NULL;
	  END CASE;
	end if;
	end process fun;
end stimulus;
