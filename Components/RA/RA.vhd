library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity RA is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_add : in std_logic_vector(15 downto 0);
        RA: in std_logic_vector(15 downto 0);
        ADD_EN: in std_logic;
        output : out std_logic_vector(15 downto 0)
    );
end RA;

architecture RA_arch of RA is
signal stored_value: std_logic_vector(15 downto 0);
signal x: std_logic :='0';
component SUM_RA
        Port (
        RA: in std_logic_vector(15 downto 0);
        ADD_EN: in std_logic;
        output: out std_logic_vector(15 downto 0)
        );
 end component;

begin
    SUM: SUM_RA port map (RA, ADD_EN,stored_value);
        
    process(i_rst,i_clk, x)
        --Sequenziale
    begin
        -- serve per settare solo all'inizio il valore di RA = i_add
        if x = '1' then
            stored_value<= i_add;
            x <= '0';
        end if;
        if i_rst = '1' then
            stored_value <= (others =>'0');
            
        elsif i_clk' event and i_clk='1' then
            stored_value <= stored_value;
        end if;
      output <= stored_value;
    end process;
end RA_arch;
