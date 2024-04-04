library ieee;
use ieee.std_logic_1164.all;

entity RA_tb is
end entity;

architecture arch of RA_tb is

    component RA is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            mux_RA : in std_logic_vector(15 downto 0);
            output_RA : out std_logic_vector(15 downto 0)
        );
    end component; 
    
    constant clock_period : time := 20 ns;
    signal s_i_rst : std_logic;
    signal s_i_clk : std_logic := '1';
    shared variable simulend : boolean :=false;
    signal s_muxRA, s_out : std_logic_vector(15 downto 0);

    begin
        uut: RA port map(
            mux_RA => s_muxRA,
            output_RA => s_out,
            i_clk => s_i_clk,
            i_rst => s_i_rst
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
            s_muxRA <= "1010001001001100";
            s_i_rst <= '1';
            wait for 100 ns;
            assert s_out="0000000000000000" report "Reset failed";
            s_i_rst <= '0';
            
            s_muxRA <= "1010001001001100";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_out="0000000000000000" report "Memory persistence error";

            s_muxRA <= "1101011000101000";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_out="1010001001001100" report "Memory persistence error";

            s_i_rst <= '1';
            wait for 10 ns;
            assert s_out="0000000000000000" report "Reset failed";

            wait for 1 ns;
            simulend := true;
            report "The testbench is over";
            wait;
        end process;

end architecture;
