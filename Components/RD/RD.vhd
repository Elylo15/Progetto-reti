library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity RD is 
 port( 
	i_mem_data : in std_logic_vector(7 downto 0);
	i_clk : in std_logic;
	RD_RST: in std_logic;
	RD_EN: in std_logic;
	output_RD: out std_logic_vector(7 downto 0)
 ); 
end RD;

architecture RD_arch of RD is
--signal stored_value: std_logic_vector(7 downto 0);
--Dobbiamo tenere a mente il funzionamento del registro, che ? un registro PIPO, cio? banalmente stiamo considerando una serie di flip flop in parallelo
--quindi per testarlo dobbiamo verificare che al tempo t ci sia un ingresso IN(t) e un uscita OUT(t-1)
begin

	memory : process(RD_RST, i_clk)
	begin 
		if(RD_RST='1') then
			--stored_value <= (others =>'0');
		    output_RD <= (others =>'0');

		elsif(i_clk'event and i_clk='1' and RD_EN='1') then
			--stored_value <= i_mem_data;
			output_RD <= i_mem_data;
		--elsif(i_clk'event and i_clk='1' and RD_EN='0') then
			--stored_value <= stored_value;;
		end if;
		--output_RD <= stored_value;
	end process;
end RD_arch;
