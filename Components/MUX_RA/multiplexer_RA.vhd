library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_RA is
    Port ( 
        i_add: in std_logic_vector(15 downto 0);
        sum_ra: in std_logic_vector(15 downto 0);
        SEL_ADD: in std_logic;
        output:	out std_logic_vector(15 downto 0)
    );
end multiplexer_RA;

architecture multiplexer_RA_arch of multiplexer_RA is

begin
     process (SEL_ADD, i_add, sum_ra)
    begin
        if SEL_ADD = '0' then
            output <= i_add;
        elsif SEL_ADD = '1' then
            output <= sum_ra;
        else
            -- Default case if SEL_OUT is not 0 or 1
            output <= (others => 'X'); -- Output undetermined
        end if;
    end process;

end multiplexer_RA_arch;
