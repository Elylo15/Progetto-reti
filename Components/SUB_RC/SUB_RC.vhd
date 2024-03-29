library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SUB_RC is
    Port (
        RC: in std_logic_vector(7 downto 0);
        SUB_EN: in std_logic;
        output: out std_logic_vector(7 downto 0)
    );
end SUB_RC;

architecture SUB_RC_arch of SUB_RC is
   signal s_borrow : std_logic; 
begin
  SUB0: entity work.half_subtractor
        port map (
            A => RC(0),
            B => SUB_EN,
            borrow => s_borrow,
            diff => output(0)
        );
       
    output(7 downto 1) <= RC(7 downto 1);

end SUB_RC_arch;
