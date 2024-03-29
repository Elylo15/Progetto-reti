library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sub_RC_tb is
end sub_RC_tb;

architecture sub_RC_tb_arch of sub_RC_tb is

   component SUB_RC is
    Port (
        RC: in std_logic_vector(7 downto 0);
        SUB_EN: in std_logic;
        output: out std_logic_vector(7 downto 0)
    );
    end component;
    
    signal s_RC: std_logic_vector(7 downto 0);
    signal s_SUB_EN: std_logic;
    signal s_output: std_logic_vector(7 downto 0);
    
begin
     --unit under test 
    uut: SUB_RC port map(
        RC => s_RC,
        SUB_EN => s_SUB_EN,
        output => s_output
    );
    
     stim_proc: process
    begin
        s_RC <= "00011111";
        s_SUB_EN <= '0';
        assert  s_output = "00011111" report "Errore con sub_en =0 all'inizio";
        wait for 10 ns;
        
        s_RC <= "00011111";
        s_SUB_EN <= '1';
        assert  s_output = "00011110" report "Errore con sub_en =1 all'inizio";
        wait for 10 ns;
        
        s_RC <= (others=> '0');
        s_SUB_EN <= '1';
        assert  s_output = "00000000" report "Errore con sub_en =1 alla fine";
        wait for 10 ns;
        
        
        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;
    

end sub_RC_tb_arch;
