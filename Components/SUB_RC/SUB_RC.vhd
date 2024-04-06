library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SUB_RC is
    Port (
        RC: in std_logic_vector(7 downto 0);
        SUB_EN: in std_logic;
        output_SUM_RC: out std_logic_vector(7 downto 0)
    );
end SUB_RC;

architecture SUB_RC_arch of SUB_RC is
   signal s_borrow : std_logic_vector(7 downto 0); 
begin
  SUB0: entity work.half_subtractor
        port map (
            a => RC(0),
            b => SUB_EN,
            c => s_borrow(0),
            s => output_SUM_RC(0)
        );
       GEN_HALF_SUB: for i in 1 to 7 generate 
                HA_i: entity work.half_subtractor
                    port map(
                       a => RC(i),
                       b => s_borrow(i-1),
                       c => s_borrow(i),
                       s => output_SUM_RC(i)
            );
            end generate GEN_HALF_SUB;

end SUB_RC_arch;
