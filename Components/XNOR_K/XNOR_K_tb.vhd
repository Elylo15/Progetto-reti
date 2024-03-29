library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XNOR_K_tb is
end XNOR_K_tb;

architecture XNOR_K_tb_arch of XNOR_K_tb is
    component XNOR_K is
	port(
		i_k: in std_logic_vector(9 downto 0);
		RK: in std_logic_vector(9 downto 0);
		output: out std_logic
	);
    end component;
    
    signal s_i_k: std_logic_vector(9 downto 0);
	signal s_RK: std_logic_vector(9 downto 0);
    signal s_output: std_logic;
begin
      --unit under test 
    uut: XNOR_K port map(
        i_k => s_i_k,
        RK => s_RK,
        output => s_output
    );
    
     stim_proc: process
    begin
        s_i_k <= "0000000110";
        s_RK <="0000000110" ;
        wait for 10 ns;
        assert  s_output= '1' report "Errore con ingressi uguali";
        
        s_i_k <= "0000000110";
        s_RK <="0000000000";
        wait for 10 ns;
        assert  s_output = '0' report "Errore con ingressi diversi";
        
        s_i_k <= "0000000000";
        s_RK <="0000000000";
        wait for 10 ns;
        assert  s_output = '1' report "Errore con ingressi zero";
        
        assert false report "Successo" severity FAILURE;
        wait;
        
    end process;

end XNOR_K_tb_arch;
