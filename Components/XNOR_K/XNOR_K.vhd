library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XNOR_K is
	port(
		i_k: in std_logic_vector(9 downto 0);
		RK: in std_logic_vector(9 downto 0);
		output_XNOR_K: out std_logic
	);
end entity XNOR_K;

architecture XNOR_K_arch of XNOR_K is
  --  signal stored_value: std_logic;
	signal intermediate: std_logic_vector(9 downto 0);
	
begin
    XNOR_calculation: for i in 0 to 9 generate
	   intermediate(i) <= (i_k(i) xnor RK(i));
	end generate;
	output_XNOR_K <= '1' when intermediate = "1111111111" else '0';
end XNOR_K_arch;
