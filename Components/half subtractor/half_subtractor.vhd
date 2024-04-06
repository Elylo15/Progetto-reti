library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity half_subtractor is
    Port (
        a: in std_logic;
        b: in std_logic;
        c: out std_logic;
        s: out std_logic
    );
end half_subtractor;

architecture half_subtractor_arch of half_subtractor is
begin
    c <= a xor b;
	s <= (not a) and b;
end half_subtractor_arch;
