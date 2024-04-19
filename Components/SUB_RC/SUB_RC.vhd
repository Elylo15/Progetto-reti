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
            borrow => s_borrow(0),
            res => output_SUM_RC(0)
        );
       GEN_HALF_SUB: for i in 1 to 7 generate 
                HA_i: entity work.half_subtractor
                    port map(
                       a => RC(i),
                       b => s_borrow(i-1),
                       borrow => s_borrow(i),
                       res => output_SUM_RC(i)
            );
            end generate GEN_HALF_SUB;

end SUB_RC_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity half_subtractor is
    Port (
        a: in std_logic;
        b: in std_logic;
        borrow: out std_logic;
        res: out std_logic
    );
end half_subtractor;

architecture half_subtractor_arch of half_subtractor is
begin
    res <= a xor b;
	borrow <= (not a) and b;
end half_subtractor_arch;