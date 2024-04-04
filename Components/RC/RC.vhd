library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RC is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        SUB_RC: in std_logic_vector(7 downto 0);
        SUB_EN: in std_logic;
        output_RC : out std_logic_vector(7 downto 0)
    );
end RC;

architecture RC_arch of RC is
signal stored_value: std_logic_vector (7 downto 0);
begin
    process(i_rst,i_clk)
        --Sequenziale
    begin
        if i_rst = '1' then
            stored_value <= "00011111";
        elsif i_clk' event and i_clk='1' then
            stored_value <= SUB_RC;
        end if;
    output_RC <= stored_value;
    end process;

end RC_arch;
