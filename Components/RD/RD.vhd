library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity RD is 
 port( 
	i_mem_data : in std_logic_vector(7 downto 0);
	i_clk : in std_logic;
	i_rst : in std_logic;
	RD_RST: in std_logic;
	RD_EN: in std_logic;
	output: out std_logic_vector(7 downto 0)
 ); 
end RD;

--il registro si resetta a 0, e si carica con i_mem_data
architecture RD_arch of RD is
signal stored_value: std_logic_vector(7 downto 0);
begin
	process(RD_RST, i_clk, RD_EN, i_mem_data)
	begin
	   
		if RD_RST = '1' then
			stored_value <= (others =>'0');
		--se RD_EN è attivo, carica il valore di i_mem_data
		elsif i_clk' event and i_clk='1' and RD_EN = '1' then
			stored_value <= i_mem_data;
		--altrimenti, RD si mantiene invariato
		elsif i_clk' event and i_clk='1' then
			stored_value <= stored_value;
		end if;
		output <= stored_value;
	end process;
end RD_arch;
