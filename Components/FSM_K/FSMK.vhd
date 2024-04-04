library ieee;
use ieee.std_logic_1164.all;

entity FSMK is
    port(
        ADD_EN: in std_logic;
        clk: in std_logic;
        rst: in std_logic;
        INC_EN: out std_logic
    );
end entity;

architecture FSMK_arch of FSMK is
    type S is (S0, S1, S2);
    signal curr_state: S;

begin
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= S0;
        elsif clk'event and clk='1' then
            case curr_state is
                when S0 =>
                    if ADD_EN='0' then
                        curr_state <= S0;
                    elsif ADD_EN='1' then
                        curr_state <= S1;
                    end if;
                when S1 =>
                    if ADD_EN='0' then
                        curr_state <= S1;
                    elsif ADD_EN='1' then
                        curr_state <= S2;
                    end if;
                when S2=>
                    if ADD_EN='0' then
                        curr_state <= S0;
                    elsif ADD_EN='1' then
                        curr_state <= S1;
                    end if;
            end case;
        end if;
    end process;

    process(curr_state)
    begin
        INC_EN <='0';

        if curr_state = S0 then
            INC_EN <= '0';
        elsif curr_state = S1 then
            INC_EN <= '0';
        elsif curr_state = S2 then
            INC_EN <= '1';
        end if;
    end process;
end FSMK_arch;
