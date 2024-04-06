library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_RK is
 Port ( 
    xnor_input: in std_logic;
    DONE_MUX: in std_logic;
    output_mux_K: out std_logic
 );
end mux_RK;

architecture mux_RK_arch of mux_RK is

begin
 process (DONE_MUX, xnor_input)
    begin
        if DONE_MUX= '0' then
            output_mux_K <= '0';
        elsif DONE_MUX = '1' then
            output_mux_K <= xnor_input;
        end if;
    end process;

end mux_RK_arch;
