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
begin
    process(i_rst,i_clk)
        --Sequenziale
    begin
        if i_rst = '1' then
            output_RC <= "00011111";
        elsif i_clk' event and i_clk='1' then
            output_RC <= SUB_RC;
        else
            output_RC <= (others =>'X');
        end if;
    end process;

end RC_arch;
