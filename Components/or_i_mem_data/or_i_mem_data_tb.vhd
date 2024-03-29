library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_i_mem_data_tb is
end or_i_mem_data_tb;

architecture or_i_mem_data_tb_arch of or_i_mem_data_tb is
    component or_i_mem_data is
        port(
            i_mem_data: in std_logic_vector(7 downto 0);
            E: out std_logic
        );
    end component;
    
    signal s_i_mem_data: std_logic_vector(7 downto 0);
    signal s_E: std_logic;
begin
      --unit under test 
    uut: or_i_mem_data port map(
        i_mem_data => s_i_mem_data,
        E => s_E
    );
    
     stim_proc: process
    begin
        s_i_mem_data <= (others =>'0');
        wait for 10 ns;
        assert  s_E = '1' report "Errore con ingresso = 0";
        
        s_i_mem_data <= "00011111";
        wait for 10 ns;
        assert  s_E='0' report "Errore con ingresso1 != 0";
      
         s_i_mem_data <= "10000000";
        wait for 10 ns;
        assert  s_E='0' report "Errore con ingresso2 != 0";
        
        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;
    


end or_i_mem_data_tb_arch;
