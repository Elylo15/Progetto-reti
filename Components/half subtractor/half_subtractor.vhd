library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity half_subtractor is
    Port (
        a: in std_logic;
        b: in std_logic;
        borrow: out std_logic;
        diff: out std_logic
    );
end half_subtractor;

architecture half_subtractor_arch of half_subtractor is
begin
    diff <= a xor b;
	borrow <= (not a) and b;
end half_subtractor_arch;
