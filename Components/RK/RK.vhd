library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RK is 
 port( 
	i_clk : in std_logic;
	i_rst : in std_logic;
	SUM_RK: in std_logic_vector(9 downto 0);
	output_RK : out std_logic_vector(9 downto 0)
 ); 
end RK;
architecture RK_arch of RK is 
--signal stored_value: std_logic_vector(9 downto 0);
begin
	process(i_clk, i_rst)
	begin
	--Sequenziale
		if i_rst = '1' then
			output_RK <= (others =>'0');
		--altrimenti, RD si mantiene invariato
		elsif i_clk'event and i_clk='1' then
		  output_RK <= SUM_RK;
		end if;
		--output_RK <= stored_value;
	end process;
end RK_arch;
