library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_o_mem_data is
port(
		RC: in std_logic_vector(7 downto 0);
        RD: in std_logic_vector(7 downto 0);
		SEL_OUT: in std_logic;
		o_mem_data:	out std_logic_vector(7 downto 0)
	);
end multiplexer_o_mem_data;

architecture multiplexer_o_mem_data_arch of multiplexer_o_mem_data is

begin
    --quando sel =0, O_MEM_DATA = RC
	--quando sel =1, O_MEM_DATA = RD
	o_mem_data <= RC when SEL_OUT = '0' else RD;
end multiplexer_o_mem_data_arch;
