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
	
	signal busy_prev  : std_logic;
	signal busy       : std_logic;

	variable dot_char : dot_fonts.dot_char_t;
	
attribute mark_debug of nrst : signal is "TRUE";
attribute mark_debug of ena : signal is "TRUE";
attribute mark_debug of rw : signal is "TRUE";
attribute mark_debug of addr : signal is "TRUE";
attribute mark_debug of txdata : signal is "TRUE";
attribute mark_debug of rxdata : signal is "TRUE";
attribute mark_debug of ack_t : signal is "TRUE";
--attribute mark_debug of counter : signal is "TRUE";

attribute mark_debug of sclk : signal is "TRUE";
attribute mark_debug of scl : signal is "TRUE";
attribute mark_debug of sda : signal is "TRUE";
attribute mark_debug of ack_err : signal is "TRUE";
attribute mark_debug of busy : signal is "TRUE";
attribute mark_debug of dbg_st : signal is "TRUE";
attribute mark_debug of busy_prev : signal is "TRUE";
attribute mark_debug of busy_cnt : signal is "TRUE";

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
	begin
	if (rising_edge(sclk)) then
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
			txdata <= "00000000";    --cfg address        --data to be written
		 WHEN 1 =>
			txdata <= "00011000";   --cfg                          
		 WHEN 2 =>                                 
			--txdata <= "10101010";   -- matrix 1 data ...
			dot_char := get_dot_char(87);
			txdata <= dot_char(4);
		 WHEN 3 =>                                  
			--txdata <= "10101010";                  
			dot_char := get_dot_char(87);
			txdata <= dot_char(3);
		 WHEN 4 =>    
			--txdata <= "10101010";                    
			dot_char := get_dot_char(87);
			txdata <= dot_char(2);
		 WHEN 5 =>
			--txdata <= "10101010";                   
			dot_char := get_dot_char(87);
			txdata <= dot_char(1);
		 WHEN 6 =>
			--txdata <= "10101010";                    
			dot_char := get_dot_char(87);
			txdata <= dot_char(0);
		 WHEN 7 =>
			txdata <= "10101010";                  
		 WHEN 8 =>
			txdata <= "10101010";                   
		 WHEN 9 =>
			txdata <= "10101010";                   
		 WHEN 10 =>	                               
			txdata <= "10101010"; 
		 WHEN 11 =>                                  
			txdata <= "10101010";    
		 WHEN 12 =>                                  
			txdata <= "10101010"; 			
		 WHEN 13 =>  
			ena <= '0';                -- end transmission to start a new one   		 		                 
		 WHEN 14 =>		   
			ena <= '1';                -- start new transmission					
			txdata(7 downto 4) <= "0000";		-- matrix 2 data address 
			txdata(3) <= '1';
			txdata(2) <= '0';
			txdata(1) <= '1';
			txdata(0) <= '1';
		 WHEN 15 =>
			txdata <= "01010101";     -- matrix 2 data ...              
		 WHEN 16 =>
			txdata <= "01010101";                  
		 WHEN 17 =>	                                 
			txdata <= "01010101";                   
		 WHEN 18 =>    
			txdata <= "01010101";                  
		 WHEN 19 =>
			txdata <= "01010101";                    
		 WHEN 20 =>
			txdata <= "01010101";                  
		 WHEN 21 =>
			txdata <= "01010101";                    
		 WHEN 22 =>
			txdata <= "01010101";                   
		 WHEN 23 =>
			txdata <= "01010101";                    
		 WHEN 24 =>	                               
			txdata <= "01010101";
		 WHEN 25 =>                                  
			txdata <= "01010101";                  
		 WHEN 26 =>
			ena <= '0';                -- end transmission to start a new one   		 		                 
		 WHEN 27 =>
			ena <= '1';                -- start new transmission
			--txdata(7 downto 4) <= "0000??";		-- update register address	                  
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

--	gen: process(sclk)
--	begin
--		if (rising_edge(sclk)) then
--			if (counter > 64_000) then
--				counter <= 0;
--				alive <= '0';
--			else
--				counter <= counter + 1;
--				alive <= '1';
--				if (rxdata = x"ff") then 
--					counter <= counter + 2; -- use it somehow
--				end if;
--			end if;
--		end if;
--	end process;
--
--	go: process(sclk, counter, ack_t)
--	begin
--		if (counter >= 1) and (counter < 3) then
--			nrst	<= '0';
--			ena <= '0';
--			rw	<= '1';
--			addr <= "1100010"; --std_logic_vector(to_unsigned(counter, 7)); --"1100010";
--			txdata <= std_logic_vector(to_unsigned(counter, 8));
--			ack_err <= '0';
--		else 
--			nrst	<= '1';
--			ena <= '1';
--			rw	<= '0';
--			addr <= "1100011"; --std_logic_vector(to_unsigned(counter - 1, 7)); --"1100001";
--			txdata <= std_logic_vector(to_unsigned(counter +1, 8));
--			ack_err <= '1';
--		end if;
--	end process go;

end stimulus;
