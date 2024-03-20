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
    signal store: std_logic_vector (15 downto 0);
    signal sum: std_logic_vector(15 downto 0);
    signal carry: std_logic :='0';
    component ha
        port(
            a: in std_logic;
            b: in std_logic;
            c: out std_logic;
            s: out std_logic
        );
    end component;
begin
    HA_0: ha port map ((ADD_EN and '1'), RA(0),sum(0), carry);
    ADDS_generator: for I in 0 to 15 generate
        HA_I: ha port map (RA(I-1), RA(I), sum(0), carry);
    end generate;
    store<=RA;
    output <= store;
end SUM_RA_arch;
