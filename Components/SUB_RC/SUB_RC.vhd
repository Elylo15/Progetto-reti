library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SUB_RC is
    Port (
        RC: in std_logic_vector(15 downto 0);
        SUB_EN: in std_logic;
        output: out std_logic_vector(15 downto 0)
    );
end SUB_RC;

architecture SUB_RC_arch of SUB_RC is
    signal store: std_logic_vector (15 downto 0);
    signal diff: std_logic_vector(15 downto 0);
    signal borrow: std_logic :='0';

    component hs  is
        Port (
            a: in std_logic;
            b: in std_logic;
            borrow: out std_logic;
            diff: out std_logic
        );
    end component;
begin
    HS_0: hs port map ((SUB_EN and '1'), RC(0),borrow, diff(0));
    ADDS_generator: for I in 1 to 7 generate
        HS_I: hs port map (RC(I-1), RC(I), borrow, diff(0));
    end generate;
    store<=RC;
    output <= store;

end SUB_RC_arch;
