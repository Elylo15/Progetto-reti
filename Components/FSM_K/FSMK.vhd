library ieee;
use ieee.std_logic_1164.all;

entity FSMK is
    port(
        ADD_EN, ck, rst: in std_logic;
        INC_EN: out std_logic
    );
end entity;

architecture FSMK_arch of FSMK is
    type S is (S0, S1);
    signal curr_state: S;
    signal codstate : std_logic; --per la codifica degli stati

    begin 
        delta_function : process(ck, rst)
        begin
            if (ck'event and ck='1' and rst='0') then
                if (curr_state=S0 and ADD_EN='0') then
                    curr_state <= S0;
                elsif (curr_state=S0 and ADD_EN='1') then
                    curr_state <= S1;
                elsif (curr_state=S1 and ADD_EN='0') then
                    curr_state <= S1;
                elsif (curr_state=S1 and ADD_EN='1') then
                    curr_state <= S0;
                end if;
            elsif (rst='1') then
                curr_state <= S0;
            end if;
        end process;
        
        --uscita combinatoria data da una realizzazione fisica della fsm usando flip flop di tipo D
        INC_EN <= ADD_EN and codstate;
        
        process(curr_state)
        begin
        case curr_state is
            when S0 =>
                codstate <= '0';        
            when S1 =>
                codstate <= '1';
            end case;        
        end process;
end architecture;