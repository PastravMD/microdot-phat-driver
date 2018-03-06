library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dot_fonts is
	subtype dot_col_t is std_logic_vector(7 downto 0);

	type dot_char_t is 
		array (4 downto 0) of dot_col_t;

	function get_dot_char(ascii_code : integer) return dot_char_t;
end package dot_fonts;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package body dot_fonts is
	function get_dot_char(ascii_code : integer) return dot_char_t is
		variable dot_char : dot_char_t;
	begin
	case ascii_code is
		when 32   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- (space)
		when 33   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#5f#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- !
		when 34   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#07#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#07#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- "
		when 35   => dot_char := (std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#14#, 8))); -- -- 
		when 36   => dot_char := (std_logic_vector(to_unsigned(16#24#, 8)), std_logic_vector(to_unsigned(16#2a#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#2a#, 8)), std_logic_vector(to_unsigned(16#12#, 8))); -- $
		when 37   => dot_char := (std_logic_vector(to_unsigned(16#23#, 8)), std_logic_vector(to_unsigned(16#13#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#64#, 8)), std_logic_vector(to_unsigned(16#62#, 8))); -- %
		when 38   => dot_char := (std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#55#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#50#, 8))); -- &
		when 39   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#05#, 8)), std_logic_vector(to_unsigned(16#03#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- '
		when 40   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#1c#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- (
		when 41   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#1c#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- )
		when 42   => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#2a#, 8)), std_logic_vector(to_unsigned(16#1c#, 8)), std_logic_vector(to_unsigned(16#2a#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- *
		when 43   => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- +
		when 44   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#50#, 8)), std_logic_vector(to_unsigned(16#30#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- ,
		when 45   => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- -
		when 46   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#60#, 8)), std_logic_vector(to_unsigned(16#60#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- .
		when 47   => dot_char := (std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#10#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#02#, 8))); -- /
		when 48   => dot_char := (std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#3e#, 8))); -- 0
		when 49   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#42#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- 1
		when 50   => dot_char := (std_logic_vector(to_unsigned(16#42#, 8)), std_logic_vector(to_unsigned(16#61#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#46#, 8))); -- 2
		when 51   => dot_char := (std_logic_vector(to_unsigned(16#21#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#4b#, 8)), std_logic_vector(to_unsigned(16#31#, 8))); -- 3
		when 52   => dot_char := (std_logic_vector(to_unsigned(16#18#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#12#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#10#, 8))); -- 4
		when 53   => dot_char := (std_logic_vector(to_unsigned(16#27#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#39#, 8))); -- 5
		when 54   => dot_char := (std_logic_vector(to_unsigned(16#3c#, 8)), std_logic_vector(to_unsigned(16#4a#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#30#, 8))); -- 6
		when 55   => dot_char := (std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#71#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#05#, 8)), std_logic_vector(to_unsigned(16#03#, 8))); -- 7
		when 56   => dot_char := (std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#36#, 8))); -- 8
		when 57   => dot_char := (std_logic_vector(to_unsigned(16#06#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#29#, 8)), std_logic_vector(to_unsigned(16#1e#, 8))); -- 9
		when 58   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- :
		when 59   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#56#, 8)), std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- ;
		when 60   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#41#, 8))); -- <
		when 61   => dot_char := (std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8))); -- =
		when 62   => dot_char := (std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- >
		when 63   => dot_char := (std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#06#, 8))); -- ?
		when 64   => dot_char := (std_logic_vector(to_unsigned(16#32#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#79#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#3e#, 8))); -- @
		when 65   => dot_char := (std_logic_vector(to_unsigned(16#7e#, 8)), std_logic_vector(to_unsigned(16#11#, 8)), std_logic_vector(to_unsigned(16#11#, 8)), std_logic_vector(to_unsigned(16#11#, 8)), std_logic_vector(to_unsigned(16#7e#, 8))); -- A
		when 66   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#36#, 8))); -- B
		when 67   => dot_char := (std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#22#, 8))); -- C
		when 68   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#1c#, 8))); -- D
		when 69   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#41#, 8))); -- E
		when 70   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#01#, 8))); -- F
		when 71   => dot_char := (std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#32#, 8))); -- G
		when 72   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#7f#, 8))); -- H
		when 73   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- I
		when 74   => dot_char := (std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#3f#, 8)), std_logic_vector(to_unsigned(16#01#, 8))); -- J
		when 75   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#22#, 8)), std_logic_vector(to_unsigned(16#41#, 8))); -- K
		when 76   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8))); -- L
		when 77   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#7f#, 8))); -- M
		when 78   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#10#, 8)), std_logic_vector(to_unsigned(16#7f#, 8))); -- N
		when 79   => dot_char := (std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#3e#, 8))); -- O
		when 80   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#06#, 8))); -- P
		when 81   => dot_char := (std_logic_vector(to_unsigned(16#3e#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#21#, 8)), std_logic_vector(to_unsigned(16#5e#, 8))); -- Q
		when 82   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#19#, 8)), std_logic_vector(to_unsigned(16#29#, 8)), std_logic_vector(to_unsigned(16#46#, 8))); -- R
		when 83   => dot_char := (std_logic_vector(to_unsigned(16#46#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#31#, 8))); -- S
		when 84   => dot_char := (std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#01#, 8))); -- T
		when 85   => dot_char := (std_logic_vector(to_unsigned(16#3f#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#3f#, 8))); -- U
		when 86   => dot_char := (std_logic_vector(to_unsigned(16#1f#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#1f#, 8))); -- V
		when 87   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#18#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#7f#, 8))); -- W
		when 88   => dot_char := (std_logic_vector(to_unsigned(16#63#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#63#, 8))); -- X
		when 89   => dot_char := (std_logic_vector(to_unsigned(16#03#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#78#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#03#, 8))); -- Y
		when 90   => dot_char := (std_logic_vector(to_unsigned(16#61#, 8)), std_logic_vector(to_unsigned(16#51#, 8)), std_logic_vector(to_unsigned(16#49#, 8)), std_logic_vector(to_unsigned(16#45#, 8)), std_logic_vector(to_unsigned(16#43#, 8))); -- Z
		when 91   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8))); -- (
		when 92   => dot_char := (std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#10#, 8)), std_logic_vector(to_unsigned(16#20#, 8))); -- \
		when 93   => dot_char := (std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- )
		when 94   => dot_char := (std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#04#, 8))); -- ^
		when 95   => dot_char := (std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8))); -- _
		when 96   => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#02#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- `
		when 97   => dot_char := (std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#78#, 8))); -- a
		when 98   => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#48#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#38#, 8))); -- b
		when 99   => dot_char := (std_logic_vector(to_unsigned(16#38#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#20#, 8))); -- c
		when 100  => dot_char := (std_logic_vector(to_unsigned(16#38#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#48#, 8)), std_logic_vector(to_unsigned(16#7f#, 8))); -- d
		when 101  => dot_char := (std_logic_vector(to_unsigned(16#38#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#18#, 8))); -- e
		when 102  => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#7e#, 8)), std_logic_vector(to_unsigned(16#09#, 8)), std_logic_vector(to_unsigned(16#01#, 8)), std_logic_vector(to_unsigned(16#02#, 8))); -- f
		when 103  => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#3c#, 8))); -- g
		when 104  => dot_char := (std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#78#, 8))); -- h
		when 105  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#7d#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- i
		when 106  => dot_char := (std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#3d#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- j
		when 107  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#10#, 8)), std_logic_vector(to_unsigned(16#28#, 8)), std_logic_vector(to_unsigned(16#44#, 8))); -- k
		when 108  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- l
		when 109  => dot_char := (std_logic_vector(to_unsigned(16#7c#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#18#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#78#, 8))); -- m
		when 110  => dot_char := (std_logic_vector(to_unsigned(16#7c#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#78#, 8))); -- n
		when 111  => dot_char := (std_logic_vector(to_unsigned(16#38#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#38#, 8))); -- o
		when 112  => dot_char := (std_logic_vector(to_unsigned(16#7c#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- p
		when 113  => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#14#, 8)), std_logic_vector(to_unsigned(16#18#, 8)), std_logic_vector(to_unsigned(16#7c#, 8))); -- q
		when 114  => dot_char := (std_logic_vector(to_unsigned(16#7c#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- r
		when 115  => dot_char := (std_logic_vector(to_unsigned(16#48#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#20#, 8))); -- s
		when 116  => dot_char := (std_logic_vector(to_unsigned(16#04#, 8)), std_logic_vector(to_unsigned(16#3f#, 8)), std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#20#, 8))); -- t
		when 117  => dot_char := (std_logic_vector(to_unsigned(16#3c#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#7c#, 8))); -- u
		when 118  => dot_char := (std_logic_vector(to_unsigned(16#1c#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#20#, 8)), std_logic_vector(to_unsigned(16#1c#, 8))); -- v
		when 119  => dot_char := (std_logic_vector(to_unsigned(16#3c#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#30#, 8)), std_logic_vector(to_unsigned(16#40#, 8)), std_logic_vector(to_unsigned(16#3c#, 8))); -- w
		when 120  => dot_char := (std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#28#, 8)), std_logic_vector(to_unsigned(16#10#, 8)), std_logic_vector(to_unsigned(16#28#, 8)), std_logic_vector(to_unsigned(16#44#, 8))); -- x
		when 121  => dot_char := (std_logic_vector(to_unsigned(16#0c#, 8)), std_logic_vector(to_unsigned(16#50#, 8)), std_logic_vector(to_unsigned(16#50#, 8)), std_logic_vector(to_unsigned(16#50#, 8)), std_logic_vector(to_unsigned(16#3c#, 8))); -- y
		when 122  => dot_char := (std_logic_vector(to_unsigned(16#44#, 8)), std_logic_vector(to_unsigned(16#64#, 8)), std_logic_vector(to_unsigned(16#54#, 8)), std_logic_vector(to_unsigned(16#4c#, 8)), std_logic_vector(to_unsigned(16#44#, 8))); -- z
		when 123  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- {
		when 124  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#7f#, 8)), std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- |
		when 125  => dot_char := (std_logic_vector(to_unsigned(16#00#, 8)), std_logic_vector(to_unsigned(16#41#, 8)), std_logic_vector(to_unsigned(16#36#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#00#, 8))); -- }
		when 126  => dot_char := (std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#08#, 8)), std_logic_vector(to_unsigned(16#2a#, 8)), std_logic_vector(to_unsigned(16#1c#, 8)), std_logic_vector(to_unsigned(16#08#, 8))); -- ~
		when others => dot_char := (std_logic_vector(to_unsigned(16#ff#, 8)), std_logic_vector(to_unsigned(16#ff#, 8)), std_logic_vector(to_unsigned(16#ff#, 8)), std_logic_vector(to_unsigned(16#ff#, 8)), std_logic_vector(to_unsigned(16#ff#, 8))); -- (undefined)
	end case;
	return dot_char;
	end function get_dot_char;

end package body dot_fonts;
