library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RC is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        RC: in std_logic_vector(15 downto 0);
        SUB_EN: in std_logic;
        output : out std_logic_vector(15 downto 0)
    );
end RC;

architecture RC_arch of RC is
    signal stored_value: std_logic_vector(15 downto 0);

    component SUB_RC is
        Port (
            RC: in std_logic_vector(15 downto 0);
            SUB_EN: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
    end component;
begin
    SUB: SUB_RC port map (RC, SUB_EN,stored_value);

    process(i_rst,i_clk)
        --Sequenziale
    begin
        if i_rst = '1' then
            stored_value <= "00011111";

        elsif i_clk' event and i_clk='1' then
            output <= stored_value;
        end if;
    end process;

end RC_arch;
