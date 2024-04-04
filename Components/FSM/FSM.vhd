library ieee;
use ieee.std_logic_1164.all;

entity FSM is
    port(
        START: in std_logic;
        E: in std_logic;
        DONE: in std_logic;
        CHECK_ZERO: in std_logic;
        clk: in std_logic;
        rst: in std_logic;


        ADD_EN: out std_logic;
        RD_EN: out std_logic;
        SEL_OUT: out std_logic;
        RC_RST: out std_logic;
        RD_RST: out std_logic;
        SEL_ADD: out std_logic;
        SUB_EN: out std_logic;
        O_MEM_E: out std_logic;
        O_MEM_WE: out std_logic
    );
end entity;

architecture FSM_arch of FSM is
    type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, SF, SX);
    signal curr_state: S;

begin
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= S0;
        elsif clk'event and clk='1' then
            case curr_state is

                when S0 =>
                    if START='0' then
                        curr_state <= S0;
                    elsif START='1' then
                        curr_state <= SX;
                    end if;

                when SX =>
                    curr_state <= S1;

                when S1 =>
                    if START='1' and E='0' then
                        curr_state <= S2;
                    elsif START='1' and E='1' then
                        curr_state <= S3;
                    end if;

                when S2 =>
                    curr_state <= S5;

                when S3 =>
                    curr_state <= S4;

                when S4 =>
                    if START='1' and DONE='1' then
                        curr_state <= SF;
                    else
                        curr_state <= S1;
                    end if;

                when S5 =>
                    if START='1' and DONE='1' then
                        curr_state <= SF;
                    else
                        curr_state <= S6;
                    end if;

                when S6 =>
                    if START='1' and E='0' then
                        curr_state <= S2;
                    elsif  START='1' and E='1' then
                        curr_state <= S7;
                    end if;

                when S7 =>
                    curr_state <= S8;

                when S8 =>
                    if CHECK_ZERO='0' then
                        curr_state <= S6;
                    elsif CHECK_ZERO='1' then
                        curr_state <= S9;
                    elsif START='1' and DONE='1' then
                        curr_state <= SF;
                    end if;

                when S9 =>
                    if START='1' and E='1' then
                        curr_state <= S7;
                    elsif  START='1' and E='0' then
                        curr_state <= S2;
                    end if;

                when SF =>
                    if START='1' and DONE='1' then
                        curr_state <= SF;
                    elsif START='0' and DONE='1' then
                        curr_state <= S0;
                    end if;
            end case;
        end if;
    end process;

    process(curr_state)
    begin
        ADD_EN<='0';
        RD_EN <='0';
        SEL_OUT <='0';
        RC_RST <='0';
        RD_RST <='0';
        SEL_ADD <='0';
        SUB_EN <='0';
        O_MEM_E <='0';
        O_MEM_WE <='0';

        if curr_state = S0 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '1';
            RD_RST <= '1';
            SUB_EN <= '0';
            O_MEM_E <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='0';

        elsif curr_state = SX then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='0';

        elsif curr_state = S1 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S2 then
            ADD_EN <='1';
            RD_EN <= '1';
            SEL_OUT <= '0';
            RC_RST <= '1';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S3 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S4 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S5 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S6 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '1';
            O_MEM_E <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S7 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S8 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S9 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = SF then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            SUB_EN <= '0';
            O_MEM_E <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='1';
        end if;
    end process;

end FSM_arch;
