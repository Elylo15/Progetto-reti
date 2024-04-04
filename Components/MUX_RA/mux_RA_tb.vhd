library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_RA_tb is
end mux_RA_tb;

architecture mux_RA_tb_arch of mux_RA_tb is
    component multiplexer_RA is
    port(
        i_add: in std_logic_vector(15 downto 0);
        sum_ra: in std_logic_vector(15 downto 0);
        SEL_ADD: in std_logic;
        output_mux_RA:	out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal s_i_add: std_logic_vector(15 downto 0);
    signal s_sum_ra: std_logic_vector(15 downto 0);
    signal s_SEL_ADD: std_logic;
    signal s_output_mux_RA: std_logic_vector(15 downto 0);
    
begin
    --unit under test 
    uut: multiplexer_RA port map(
        i_add => s_i_add,
        sum_ra => s_sum_ra,
        SEL_ADD => s_SEL_ADD,
        output_mux_RA => s_output_mux_RA
    );
    
    process
    begin
        s_i_add <= "1010000101001010";
        s_sum_ra <= "0000000000000001" ;
        
        s_SEL_ADD <= '0';
        wait for 10 ns;
        assert  s_output_mux_RA = "1010000101001010" report "Errore con Sel=0";
        
      
        s_SEL_ADD <= '1';
        wait for 10 ns;
        assert  s_output_mux_RA = "0000000000000001" report "Errore con Sel=U";
        
  
         s_SEL_ADD <= 'U';
         wait for 10 ns;
        assert  s_output_mux_RA = "XXXXXXXXXXXXXXXX" report "Errore con Sel=1";
        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;

end mux_RA_tb_arch;
