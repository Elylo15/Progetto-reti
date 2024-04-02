library ieee;
use ieee.std_logic_1164.all;

entity RK_tb is
end RK_tb;

architecture RK_tb_arch of RK_tb is
    component RK is
        port( 
            i_clk : in std_logic;
            i_rst : in std_logic;
            RK: in std_logic_vector(9 downto 0);
            output : out std_logic_vector(9 downto 0)
         );
    end component;

    constant clock_period : time := 20 ns;
    signal s_RK, s_output : std_logic_vector(9 downto 0);
    signal s_i_rst : std_logic;
    signal s_i_clk : std_logic := '1';
    shared variable simulend : boolean :=false;

    begin
        uut: RK port map(
            --inputs
            RK => s_RK,
            i_rst => s_i_rst,
            i_clk => s_i_clk,
            --outputs
            output => s_output
        );

        clock : process
        begin
            while simulend=false loop
                s_i_clk <= not s_i_clk;
                wait for clock_period/2;
            end loop;
            wait;
        end process clock;
        
        
        stim_proc : process
        begin
            s_RK <= "1010001001";
            s_i_rst <= '1';
            wait for 100 ns;
            assert s_output="0000000000" report "Reset failed";
            s_i_rst <= '0';

            s_RK <= "1100011011";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="0000000000" report "Memory persistence error";

            s_RK <= "1101011011";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="1100011011" report "Memory persistence error";

            s_i_rst <= '1';
            wait for 10 ns;
            assert s_output="0000000000" report "Reset failed";

            wait for 1 ns;
            simulend := true;
            report "The testbench is over";
            wait;
        end process;
    end RK_tb_arch;

