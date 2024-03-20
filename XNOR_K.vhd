library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XNOR_K is
	port(
		i_k: in std_logic_vector(9 downto 0);
		SUM_K: in std_logic_vector(9 downto 0);
		output: out std_logic
	);
end entity XNOR_K;

architecture XNOR_K_arch of XNOR_K is
	signal intermediate: std_logic_vector(9 downto 0);
begin
	process(i_k, SUM_K)
	begin
		for i in 0 to 9 loop
			intermediate(i) <= not (i_k(i) xnor SUM_K(i));
		end loop;
		x <= '1' when intermediate = (other=>'1') else '0';
	end process;
end XNOR_K_arch;
