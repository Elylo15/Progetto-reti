library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_K is
    Port (
        RK: in std_logic_vector(9 downto 0);
        K_EN: in std_logic;
        output_SUM_RK: out std_logic_vector(9 downto 0)
    );
end SUM_K;

architecture SUM_K_arch of SUM_K is
 signal carry: std_logic_vector(9 downto 0);
 
begin
     HA0: entity work.half_adder
        port map(
            a => RK(0),
		    b => K_EN,
		    c => carry(0),
		    s => output_SUM_RK(0)
    );
    
     GEN_HALF_ADDERS: for i in 1 to 9 generate 
        HA_i: entity work.half_adder
            port map(
               a => RK(i),
		       b => carry(i-1),
		       c => carry(i),
		       s => output_SUM_RK(i)
    );
    end generate GEN_HALF_ADDERS;
    
end SUM_K_arch;
