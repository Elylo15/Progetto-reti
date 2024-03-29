library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder_tb is
end half_adder_tb;

architecture half_adder_tb of half_adder_tb is

    component half_adder is
        port(
            a: in std_logic;
            b: in std_logic;
            c: out std_logic;
            s: out std_logic
        );
    end component;
    
     signal s_a: std_logic;
     signal s_b: std_logic;
     signal s_c: std_logic;
     signal s_s: std_logic;

begin
      --unit under test 
    uut: half_adder port map(
        a => s_a,
        b => s_b,
        c => s_c,
        s => s_s
    );
    
     stim_proc: process
    begin
    
        s_a <= '0';
        s_b <= '0';
        wait for 10 ns;
        assert  s_c='0' and  s_s='0'  report "Errore con a=0, b=0";
        
        s_a <= '0';
        s_b <= '1';
        wait for 10 ns;
        assert  s_c='0' and  s_s='1'  report "Errore con a=0, b=1";
        
        s_a <= '1';
        s_b <= '0';
        wait for 10 ns;
        assert  s_c='0' and  s_s='1'  report "Errore con a=1, b=0";
        
        s_a <= '1';
        s_b <= '1';
        wait for 10 ns;
        assert  s_c='1' and  s_s='0'  report "Errore con a=1, b=1";
        
         
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;

end half_adder_tb;
