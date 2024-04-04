library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity RA is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        mux_RA : in std_logic_vector(15 downto 0);
        output_RA : out std_logic_vector(15 downto 0)
    );
end RA;

architecture RA_arch of RA is
signal stored_value: std_logic_vector(15 downto 0);
begin   
    process(i_rst,i_clk)
    begin
        if (i_rst = '1') then
            stored_value <= (others =>'0');
        elsif (i_clk'event and i_clk='1') then
            stored_value <= mux_RA;
        
        end if; 
        output_RA<= stored_value;
    end process;
end RA_arch;
