library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_K is
    Port (
        RK: in std_logic_vector(9 downto 0);
        K_EN: in std_logic;
        output: out std_logic_vector(9 downto 0)
    );
end SUM_K;

architecture SUM_K_arch of SUM_K is
    signal store: std_logic_vector (9 downto 0);
    signal sum: std_logic_vector(9 downto 0);
     signal carry_in: std_logic :='0';
    signal carry_out: std_logic :='0';
    signal AND_K: std_logic := K_EN and '1';
    component ha_k
        port(
            a: in std_logic;
            b: in std_logic;
            c: out std_logic;
            s: out std_logic
        );
    end component;
begin
    HA_0: ha_k port map (AND_K, RK(0),sum(0), carry_in);
    ADDS_generator: for I in 1 to 8 generate
        HA_I: ha_k port map (carry_in, RK(I), sum(0), carry_out);
        carry_in<= carry_out;
    end generate;
    store<=RK;
    output <= store;
end SUM_K_arch;
