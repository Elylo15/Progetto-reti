library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XNOR_K is
	port(
	    i_rst: in std_logic;
		i_k: in std_logic_vector(9 downto 0);
		RK: in std_logic_vector(9 downto 0);
		output_XNOR_K: out std_logic
	);
end entity XNOR_K;

architecture XNOR_K_arch of XNOR_K is
  --  signal stored_value: std_logic;
	signal intermediate: std_logic_vector(9 downto 0);
	
begin
   process(i_k, RK, i_rst)
    begin 
        if i_rst= '1' then
            output_XNOR_K <='0';
        elsif i_k = RK then   
            output_XNOR_K <='1';
        else
            output_XNOR_K <= '0';
        end if; 
   end process;
end XNOR_K_arch;
