library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_o_mem_data is
    port(
        RC: in std_logic_vector(7 downto 0);
        RD: in std_logic_vector(7 downto 0);
        SEL_OUT: in std_logic;
        o_mem_data:	out std_logic_vector(7 downto 0)
    );
end multiplexer_o_mem_data;

architecture multiplexer_o_mem_data_arch of multiplexer_o_mem_data is

begin
    --quando sel =0, O_MEM_DATA = RC
    --quando sel =1, O_MEM_DATA = RD
    process (SEL_OUT, RC, RD)
    begin
        if SEL_OUT = '0' then
            o_mem_data <= RC;
        elsif SEL_OUT = '1' then
            o_mem_data <= RD;
        else
            -- Default case if SEL_OUT is not 0 or 1
            o_mem_data <= (others => 'X'); -- Output undetermined
        end if;
    end process;
end multiplexer_o_mem_data_arch;
