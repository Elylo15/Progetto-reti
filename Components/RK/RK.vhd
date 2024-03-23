library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RK is 
 port( 
	i_clk : in std_logic;
	i_rst : in std_logic;
	RK: in std_logic_vector(9 downto 0);
	K_EN: in std_logic;
	output : out std_logic_vector(9 downto 0)
 ); 
end RK;
architecture RK_arch of RK is
signal stored_value: std_logic_vector(9 downto 0);

   component SUM_K is
    Port (
        RK: in std_logic_vector(9 downto 0);
        K_EN: in std_logic;
        output: out std_logic_vector(9 downto 0)
    );
    end component;
    
begin
    SUM_K_1: SUM_K port map (RK, K_EN,stored_value);
	process(i_clk, i_rst)
	begin
	--Sequenziale
		if i_rst = '1' then
			stored_value <= (others =>'0');
		--altrimenti, RD si mantiene invariato
		elsif i_clk' event and i_clk='1' then
		  stored_value <= stored_value;
		end if;
		output <= stored_value;
	end process;
end RK_arch;
