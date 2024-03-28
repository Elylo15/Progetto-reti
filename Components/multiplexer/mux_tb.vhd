library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_tb is
end mux_tb;

architecture mux_tb_arch of mux_tb is
    component multiplexer_o_mem_data is
    port(
        RC: in std_logic_vector(7 downto 0);
        RD: in std_logic_vector(7 downto 0);
        SEL_OUT: in std_logic;
        o_mem_data:	out std_logic_vector(7 downto 0)
    );
    end component;
    
    signal s_RC: std_logic_vector(7 downto 0);
    signal s_RD: std_logic_vector(7 downto 0);
    signal s_SEL_OUT: std_logic;
    signal s_o_mem_data: std_logic_vector(7 downto 0);
    
begin
    --unit under test 
    uut: multiplexer_o_mem_data port map(
        RC => s_RC,
        RD => s_RD,
        SEL_OUT => s_SEL_OUT,
        o_mem_data => s_o_mem_data
    );
    
    stim_proc: process
    begin
        s_RC <= "00000000";
        s_SEL_OUT <= '0';
        wait for 10 ns;
        assert  s_o_mem_data = "00000000" report "Errore con Sel=0";
        
        s_RD <= "01100100";
        s_SEL_OUT <= '1';
        wait for 10 ns;
        assert  s_o_mem_data = "01100100" report "Errore con Sel=1";
        
        report "Successo";
        wait;
        
    end process;

end mux_tb_arch;
