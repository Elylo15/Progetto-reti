library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_subtractor_tb is
end half_subtractor_tb;

architecture half_subtractor_tb_arch of half_subtractor_tb is
    component half_subtractor is
        Port (
            a: in std_logic;
            b: in std_logic;
            borrow: out std_logic;
            diff: out std_logic
        );
    end component;
    
    signal s_a: std_logic;
    signal s_b: std_logic;
    signal s_borrow: std_logic;
    signal s_diff: std_logic;
begin
   --unit under test 
    uut: half_subtractor port map(
        a => s_a,
        b => s_b,
        borrow => s_borrow,
        diff => s_diff
    );
    
     stim_proc: process
     
     --diff <= a xor b;
     --borrow <= (not a) and b;
    begin
        s_a <= '0';
        s_b <= '0';
        wait for 10 ns;
        assert  s_borrow='0' and  s_diff='0'  report "Errore con a=0, b=0";
        
        s_a <= '0';
        s_b <= '1';
        wait for 10 ns;
        assert s_borrow='1'  and   s_diff='1' report "Errore con a=0, b=1";
        
        s_a <= '1';
        s_b <= '0';
        wait for 10 ns;
        assert  s_borrow='0'  and   s_diff='1' report "Errore con a=1, b=0";
        
        s_a <= '1';
        s_b <= '1';
        wait for 10 ns;
        assert  s_borrow='0'  and   s_diff='0' report "Errore con a=1, b=1";
        
         
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;

end half_subtractor_tb_arch;
