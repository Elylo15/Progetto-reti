library ieee;
use ieee.std_logic_1164.all;

entity FSMK_tb is
end FSMK_tb;

architecture FSMK_tb_arch of FSMK_tb is
    component FSMK is
        port(
            ADD_EN, ck, rst: in std_logic;
            INC_EN: out std_logic
        );
    end component;

    constant clock_period : time := 20 ns;
    signal s_ADD_EN, s_rst, s_INC : std_logic;
    signal s_ck : std_logic :='1';
    shared variable simulend : boolean := false;
    begin
        uut : FSMK port map(
            ADD_EN => s_ADD_EN,
            ck => s_ck,
            rst => s_rst,
            INC_EN => s_INC
        );

        clock : process
        begin
            while simulend=false loop
                s_ck <= not s_ck;
                wait for clock_period/2;
            end loop;
            wait;
        end process clock;

        stim_proc : process
        begin
            s_rst <= '1';
            wait for 60 ns;
            assert s_INC ='0' report "Reset failed";
            
            s_rst <= '0';


            s_ADD_EN <= '0';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '0' report "S0 loop failed";
            
            s_ADD_EN <= '1';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '0' report "S0-S1 transition failed";

            s_ADD_EN <= '0';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '0' report "S1 loop failed";

            s_ADD_EN <= '1';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '1' report "S1-S2 transition failed";

            s_ADD_EN <= '1';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '0' report "S2-S1 transition failed";

            s_ADD_EN <= '1';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '1' report "S1-S2 transition failed";

            s_ADD_EN <= '0';
            wait until rising_edge(s_ck);
            wait for 1 ns;
            assert s_INC = '0' report "S2-S0 transition failed";

            wait for 1 ns;
            simulend := true;
            report "The testbench is over";
            wait;
        end process;
    end architecture;