library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sum_RA_tb is
end sum_RA_tb;

architecture sum_RA_tb_arch of sum_RA_tb is

    component SUM_RA is
        Port (
            RA: in std_logic_vector(15 downto 0);
            ADD_EN: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal s_RA: std_logic_vector(15 downto 0);
    signal s_ADD_EN: std_logic;
    signal s_output: std_logic_vector(15 downto 0);
    
begin
     --unit under test 
    uut: SUM_RA port map(
        RA => s_RA,
        ADD_EN => s_ADD_EN,
        output => s_output
    );
    
     stim_proc: process
    begin
    
        s_RA <= "0000000000000000";
        s_ADD_EN <= '0';
        assert  s_output = "0000000000000000" report "Errore con add_en =0 all'inizio";
        wait for 10 ns;
        
        s_RA <= (others=>'0');
        s_ADD_EN <= '1';
        assert  s_output = "0000000000000001" report "Errore con add_en =1 all'inizio";
        wait for 10 ns;
       
       s_RA <= "0000000000000001";
        s_ADD_EN <= '1';
        assert  s_output = "0000000000000010" report "Errore con add_en =1";
        wait for 10 ns;
        

        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;
    

end sum_RA_tb_arch;
