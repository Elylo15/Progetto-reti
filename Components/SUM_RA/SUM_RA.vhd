library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_RA is
    Port (
        RA: in std_logic_vector(15 downto 0);
        ADD_EN: in std_logic;
        output: out std_logic_vector(15 downto 0)
    );
end SUM_RA;

architecture SUM_RA_arch of SUM_RA is

   signal carry: std_logic_vector(15 downto 0);
 begin   
    HA0: entity work.half_adder
        port map(
            a => RA(0),
		    b => ADD_EN,
		    c => carry(0),
		    s => output(0)
    );
    
    GEN_HALF_ADDERS: for i in 1 to 15 generate 
        HA_i: entity work.half_adder
            port map(
               a => RA(i),
		       b => carry(i-1),
		       c => carry(i),
		       s => output(i)
    );
    end generate GEN_HALF_ADDERS;
    

end SUM_RA_arch;
