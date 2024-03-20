library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_i_mem_data is
port(
    i_mem_data: in std_logic_vector(7 downto 0);
	E: out std_logic
);
end or_i_mem_data;

architecture or_imem_data_arch of or_i_mem_data is

begin
    E <= '1' when not(i_mem_data) = ("00000000") else '0';
end or_imem_data_arch;
