library ieee;
use ieee.std_logic_1164.all;

entity RD_tb is
end RD_tb;

architecture RD_tb_arch of RD_tb is
    component RD is
        port( 
            i_mem_data : in std_logic_vector(7 downto 0);
            i_clk : in std_logic;
            RD_RST: in std_logic;
            RD_EN: in std_logic;
            output: out std_logic_vector(7 downto 0)
         );
    end component;

    constant clock_period : time := 20 ns;
    signal s_i_mem_data : std_logic_vector(7 downto 0);
    signal s_output : std_logic_vector(7 downto 0);
    signal s_RD_EN, s_RD_RST : std_logic;
    signal s_i_clk : std_logic := '1';
    shared variable simulend : boolean :=false;

    begin
        uut: RD port map(
            --inputs
            i_mem_data => s_i_mem_data,
            i_clk => s_i_clk,
            RD_RST => s_RD_RST,
            RD_EN => s_RD_EN,
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
            s_i_mem_data <= "00101110";
            s_RD_RST <= '1';
            wait for 100 ns;
            assert s_output="00000000" report "Reset failed";
            s_RD_RST <= '0';

            s_RD_EN <= '0';
            s_i_mem_data <= "00101110";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="00000000" report "Error: memory not mantained";

            s_RD_EN <= '1';
            s_i_mem_data <= "00101110";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="00000000" report "Memory read error";

            s_RD_EN <= '0';
            s_i_mem_data <= "01101111";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="00101110" report "Error: memory not mantained";

            s_RD_EN <= '1';
            s_i_mem_data <= "01101111";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="00101110" report "Error: memory not mantained";

            s_RD_EN <= '1';
            s_i_mem_data <= "11111111";
            wait until rising_edge(s_i_clk);
            wait for 1 ns;
            assert s_output="01101111" report "Memory read error";

            s_RD_RST <= '1';
            wait for 10 ns;
            assert s_output="00000000" report "Reset failed";

            wait for 1 ns;
            simulend := true;
            report "The testbench is over";
            wait;
        end process;
    end RD_tb_arch;

