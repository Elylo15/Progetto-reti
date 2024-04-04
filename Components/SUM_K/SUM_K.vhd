library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sum_K_tb is
end sum_K_tb;

architecture sum_K_tb of sum_K_tb is

    component SUM_K is
        Port (
            RK: in std_logic_vector(9 downto 0);
            K_EN: in std_logic;
            output_SUM_RK: out std_logic_vector(9 downto 0)
        );
    end component;
    
    signal s_RK: std_logic_vector(9 downto 0);
    signal s_K_EN: std_logic;
    signal s_output: std_logic_vector(9 downto 0);
begin

    uut: SUM_K port map(
        RK => s_RK,
        K_EN => s_K_EN,
        output_SUM_RK => s_output
    );
    
    stim_proc: process
    begin
        s_RK <= (others=>'0');
        s_k_EN <= '0';
        wait for 10 ns;
        assert  s_output = "0000000000" report "Errore con k_en =0 all'inizio";
        
        s_RK <= (others=>'0');
        s_k_EN <= '1';
        wait for 10 ns;
        assert  s_output = "0000000001" report "Errore con sub_en =1 all'inizio";    
        
        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;
    


end sum_K_tb;
