library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_RA is
Port ( 
    RA: in std_logic_vector(15 downto 0);
    ADD_EN: in std_logic;
    output: out std_logic_vector(15 downto 0);
);
end SUM_RA;

architecture Behavioral of SUM_RA is
signal stored_value: std_logic_vector(15 downto 0);

component ha 
port(
		a: in std_logic;
		b: in std_logic;
		c: out std_logic;
		s: out std_logic
	);
 end component;
 
begin
   ha0: ha port map((ADD_EN and '1'),RA(0));
   for i in 1 to 15 loop
			
	end loop;
end Behavioral;
