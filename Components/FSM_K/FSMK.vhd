library ieee;
use ieee.std_logic_1164.all;

entity FSMK is
    port(
        ADD_EN, ck, rst: in std_logic;
        INC_EN: out std_logic
    );
end entity;

architecture FSMK_arch of FSMK is
    type S is (S0, S1, S2);
    signal curr_state: S;

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
                    curr_state <= S2;
                elsif (curr_state=S2 and ADD_EN='0') then
                    curr_state <= S0;
                elsif (curr_state=S2 and ADD_EN='1') then
                    curr_state <= S1;
                end if;
            elsif (rst='1') then
                curr_state <= S0;
            end if;
        end process;
        
        with curr_state select
            INC_EN <= '0' when S0,
                      '0' when S1,
                      '1' when S2,
                      'X' when others;
end architecture;