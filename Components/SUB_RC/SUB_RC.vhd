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
    signal store: std_logic_vector (7 downto 0);
    signal diff: std_logic_vector(7 downto 0);
    signal borrow_in: std_logic :='0';
    signal borrow_out: std_logic :='0';
    signal AND_RC: std_logic := SUB_EN and '1';
    component hs  is
        Port (
            a: in std_logic;
            b: in std_logic;
            borrow: out std_logic;
            diff: out std_logic
        );
    end component;
begin
    HS_0: hs port map (AND_RC, RC(0),borrow_in, diff(0));
    ADDS_generator: for I in 1 to 7 generate
        HS_I: hs port map (borrow_in, RC(I), borrow_out, diff(0));
        borrow_in <= borrow_out;
    end generate;
    store<=RC;
    output <= store;

end SUB_RC_arch;
