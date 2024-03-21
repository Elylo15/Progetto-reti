library ieee;
use ieee.std_logic_1164.all;

entity FSM_tb is
end FSM_tb;

architecture FSM_tb_arch of FSM_tb is
    component FSM is
        port(
            START, E, DONE, ck, rst: in std_logic;
            ADD_EN, RD_EN, SEL_OUT, RC_RST, RD_RST, SUB_EN, O_MEM_E, O_MEM_WE: out std_logic
        );
    end component;

    constant clock_period : time := 20 ns;

    signal s_START, s_E, s_DONE, s_rst, s_ADD_EN, s_RD_EN, s_SEL_OUT, s_RC_RST, s_RD_RST, s_SUB_EN, s_MEM_E, s_MEM_WE : std_logic;
    signal s_clk : std_logic := '1';
    begin
        uut: FSM port map(
            --INPUTS
            START => s_START, 
            E => s_E, 
            DONE => s_DONE, 
            ck => s_clk, 
            rst => s_rst,
            --OUTPUTS
            ADD_EN => s_ADD_EN, 
            RD_EN => s_RD_EN, 
            SEL_OUT => s_SEL_OUT, 
            RC_RST => s_RC_RST, 
            RD_RST => s_RD_RST, 
            SUB_EN => s_SUB_EN, 
            O_MEM_E => s_MEM_E, 
            O_MEM_WE => s_MEM_WE
        );

        s_clk <= not s_clk after clock_period/2;

        stim_proc: process
        begin
            s_rst <= '1';
            wait for 100 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "Reset failed";

            s_START <= '0';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S0 loop failed";

            s_START <= '1';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S0 loop failed";

            wait for 1 ns;
            report "The testbench was successful";
            wait;
        end process;
    end FSM_tb_arch;