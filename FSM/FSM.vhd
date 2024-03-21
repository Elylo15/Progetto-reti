library ieee;
use ieee.std_logic_1164.all;

entity FSM is
    port(
        START, E, DONE, ck, rst: in std_logic;
        ADD_EN, RD_EN, SEL_OUT, RC_RST, RD_RST, SUB_EN, O_MEM_E, O_MEM_WE: out std_logic
    );
end entity;

architecture FSM_arch of FSM is
    type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, SF);
    signal curr_state: S;

    begin
        delta_function : process(ck, rst) --spaghetti code per le transizioni della fsm
        begin
            if (rst='1') then
                curr_state <= S0;
            elsif (ck'event and ck='1') then
                if (curr_state=S0 and START='0' and DONE='0') then
                    curr_state <= S0;
                elsif (curr_state=S0 and START='1' and DONE='0') then 
                    curr_state <= S1;
                elsif (curr_state=S1 and START='1' and E='0' and DONE='0') then
                    curr_state <= S2;
                elsif (curr_state=S1 and START='1' and E='1' and DONE='0') then 
                    curr_state <= S3;
                elsif (curr_state=S3) then
                    curr_state <= S4;
                elsif (curr_state=S4 and DONE='0') then
                    curr_state <= S1;
                elsif (curr_state=S4 and START='1' and DONE='1') then
                    curr_state <= SF;
                elsif (curr_state=S2) then
                    curr_state <= S5;
                elsif (curr_state=S5 and DONE='0') then
                    curr_state <= S6;
                elsif (curr_state=S5 and START='1' and DONE='1') then
                    curr_state <= SF;
                elsif (curr_state=S6 and START='1' and E='0' and DONE='0') then
                    curr_state <= S2;
                elsif (curr_state=S6 and START='1' and E='1' and DONE='0') then
                    curr_state <= S7;
                elsif (curr_state=S7) then
                    curr_state <= S8;
                elsif (curr_state=S8 and DONE='0') then
                    curr_state <= S6;
                elsif (curr_state=S8 and START='1' and DONE='1') then
                    curr_state <= SF;
                elsif (curr_state=SF and START='1' and DONE='1') then
                    curr_state <= SF;
                elsif (curr_state=S0 and START='0' and DONE='1') then
                    curr_state <= S0;
                end if;
            end if;
        end process;
        --spaghettone allo scoglio per la lambda function
        with curr_state select
            ADD_EN <= '0' when S0,
                      '1' when S1,
                      '1' when S2,
                      '1' when S3,
                      '0' when S4,
                      '0' when S5,
                      '1' when S6,
                      '1' when S7,
                      '0' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
            RD_EN <=  '0' when S0,
                      '0' when S1,
                      '1' when S2,
                      '0' when S3,
                      '0' when S4,
                      '0' when S5,
                      '0' when S6,
                      '0' when S7,
                      '0' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
           SEL_OUT <= '0' when S0,
                      '0' when S1,
                      '0' when S2,
                      '1' when S3,
                      '1' when S4,
                      '0' when S5,
                      '0' when S6,
                      '1' when S7,
                      '0' when S8,
                      '1' when SF,
                      'X' when others;
        with curr_state select
            RC_RST <= '1' when S0,
                      '0' when S1,
                      '1' when S2,
                      '0' when S3,
                      '0' when S4,
                      '0' when S5,
                      '0' when S6,
                      '0' when S7,
                      '0' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
            RD_RST <= '1' when S0,
                      '0' when S1,
                      '0' when S2,
                      '0' when S3,
                      '0' when S4,
                      '0' when S5,
                      '0' when S6,
                      '0' when S7,
                      '0' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
            SUB_EN <= '0' when S0,
                      '0' when S1,
                      '0' when S2,
                      '0' when S3,
                      '0' when S4,
                      '0' when S5,
                      '1' when S6,
                      '0' when S7,
                      '1' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
           O_MEM_E <= '0' when S0,
                      '1' when S1,
                      '0' when S2,
                      '0' when S3,
                      '1' when S4,
                      '1' when S5,
                      '1' when S6,
                      '1' when S7,
                      '1' when S8,
                      '0' when SF,
                      'X' when others;
        with curr_state select
          O_MEM_WE <= '0' when S0,
                      '0' when S1,
                      '0' when S2,
                      '0' when S3,
                      '1' when S4,
                      '1' when S5,
                      '0' when S6,
                      '1' when S7,
                      '1' when S8,
                      '0' when SF,
                      'X' when others;
end architecture;