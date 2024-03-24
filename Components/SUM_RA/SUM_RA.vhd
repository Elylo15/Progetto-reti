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
    signal AND_ADDRESS: std_logic := ADD_EN and '1';
    signal carry_in: std_logic :='0';
    signal carry_out: std_logic :='0';
    component ha
        port(
            a: in std_logic;
            b: in std_logic;
            c: out std_logic;
            s: out std_logic
        );
    end component;
begin
    HA_0: ha port map (AND_ADDRESS, RA(0),sum(0), carry_in);
    ADDS_generator: for I in 1 to 15 generate
        HA_I: ha port map (carry_in, RA(I), sum(0), carry_out);
        carry_in <=carry_out;
    end generate;
    store<=RA;
    output <= store;
end SUM_RA_arch;
