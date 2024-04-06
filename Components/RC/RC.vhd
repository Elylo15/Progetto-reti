library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RC is
    port(
        i_clk : in std_logic;
        RC_RST : in std_logic;
        SUB_RC: in std_logic_vector(7 downto 0);
        output_RC : out std_logic_vector(7 downto 0)
    );
end RC;

architecture RC_arch of RC is
--signal stored_value: std_logic_vector (7 downto 0);
begin
    process(RC_RST,i_clk)
        --Sequenziale
    begin
        if RC_RST = '1' then
            --stored_value <= "00011111";
            output_RC <= "00011111";
        elsif i_clk'event and i_clk='1' then
            output_RC <= SUB_RC;
        end if;
    end process;
     --output_RC <= stored_value;
end RC_arch;
