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
    shared variable simend : boolean :=false;
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

        clkk : process
        begin
            while simend=false loop
                s_clk <= not s_clk;
                wait for clock_period/2;
            end loop;
            wait;
        end process clkk;

        --percorso S0-S1-S3-S4-S1-S2-S5-S6-S7-S8-SF-S0
        stim_proc: process
        begin
            s_rst <= '1';
            wait for 100 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "Reset failed";
            s_rst <='0';

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
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S0-S1 transition failed";

            s_START <= '1';
            s_E <= '1';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S3 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S3-S4 transition failed";
            
            s_START <= '-';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S4-S1 transition failed";
           
            s_START <= '1';
            s_E <= '0';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='1' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S2 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S2-S5 transition failed";
           
            s_START <= '-';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='1' and s_MEM_E='1' and s_MEM_WE='0' report "S5-S6 transition failed";

            s_START <= '1';
            s_E <= '1';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "S6-S7 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S7-S8 transition failed";

            s_START <= '1';
            s_E <= '-';
            s_DONE <= '1';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S8-SF transition failed";

            s_START <= '1';
            s_E <= '-';
            s_DONE <= '1';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "SF loop failed";

            s_START <= '0';
            s_E <= '-';
            s_DONE <= '1';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "SF-S1 transition failed";

            --path alternativi------------------------------------------------------------------------------------
            -- S0-S1-S3-S4-SF
            s_rst <= '1';
            wait for 100 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "Reset failed";
            s_rst <='0';
        
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
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S0-S1 transition failed";

            s_START <= '1';
            s_E <= '1';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S3 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S3-S4 transition failed";
            
            s_START <= '1';
            s_E <= '-';
            s_DONE <= '1';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S4-SF transition failed";

            -- S0-S1-S2-S5-SF
            
            s_rst <= '1';
            wait for 100 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "Reset failed";
            s_rst <='0';

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
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S0-S1 transition failed";

            s_START <= '1';
            s_E <= '0';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='1' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S2 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S2-S5 transition failed";
           
            s_START <= '1';
            s_E <= '-';
            s_DONE <= '1';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S5-SF transition failed";

            -- S0-S1-S3-S4-S1-S2-S5-S6-S7-S8-S6
            s_rst <= '1';
            wait for 100 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='1' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "Reset failed";
            s_rst <='0';

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
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S0-S1 transition failed";

            s_START <= '1';
            s_E <= '1';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S3 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S3-S4 transition failed";
            
            s_START <= '-';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='0' report "S4-S1 transition failed";
           
            s_START <= '1';
            s_E <= '0';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='1' and s_SEL_OUT='0' and s_RC_RST='1' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='0' and s_MEM_WE='0' report "S1-S2 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S2-S5 transition failed";
           
            s_START <= '-';
            s_E <= '-';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='1' and s_MEM_E='1' and s_MEM_WE='0' report "S5-S6 transition failed";

            s_START <= '1';
            s_E <= '1';
            s_DONE <= '0';
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='1' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "S6-S7 transition failed";

            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='0' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='0' and s_MEM_E='1' and s_MEM_WE='1' report "Spontaneous S7-S8 transition failed";
            
            wait until rising_edge(s_clk);
            wait for 1 ns;
            assert s_ADD_EN ='1' and s_RD_EN='0' and s_SEL_OUT='0' and s_RC_RST='0' and s_RD_RST='0' and s_SUB_EN='1' and s_MEM_E='1' and s_MEM_WE='0' report "Spontaneous S8-S6 transition failed";
            

            wait for 1 ns;
            simend := true;
            report "The testbench is over";
            wait;
        end process;
    end FSM_tb_arch;