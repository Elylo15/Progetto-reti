library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
 Port ( 
    i_clk: in std_logic;
    i_rst: in std_logic;
    i_start: in std_logic;
    E: in std_logic;
    
    SUB_EN: out std_logic;
    ADD_EN: out std_logic;
    RD_EN: out std_logic;
    
    RC_RST: out std_logic;
    
    o_mem_en: out std_logic;
    o_mem_we: out std_logic;
    
    SEL_OUT: out std_logic
    
 );
end fsm;

architecture fasm_arch of fsm is

begin


end fasm_arch;
