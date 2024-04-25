--COMPONENTI DI BASE: componenti basilari-------------------------------------------------------------------------------------------------------------------------------------------------------

--Half-Subtractor-----------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity half_subtractor is
    Port (
        a: in std_logic;
        b: in std_logic;
        borrow: out std_logic;
        res: out std_logic
    );
end half_subtractor;

architecture half_subtractor_arch of half_subtractor is
begin
    res <= a xor b;
	borrow <= (not a) and b;
end half_subtractor_arch;
---------------------------------------------------------------------------------------------------------------------------------------

--Half Adder---------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port(
		a: in std_logic;
		b: in std_logic;
		c: out std_logic;
		s: out std_logic
	);
end half_adder;

architecture half_adder_arch of half_adder is

begin
        s <= a xor b;
        c <= a and b;
end half_adder_arch;
---------------------------------------------------------------------------------------------------------------------------------------

--XNOR---------------------------------------------------------------------------------------------------------------------------------
--Usato per calcolare il segnale di DONE
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
---------------------------------------------------------------------------------------------------------------------------------------

--MUX_RA---------------------------------------------------------------------------------------------------------------------------------
--Necessario per alternare il salvataggio in memoria e la lettura da RAM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_RA is
    Port ( 
        i_add: in std_logic_vector(15 downto 0);
        sum_ra: in std_logic_vector(15 downto 0);
        SEL_ADD: in std_logic;
        output_mux_RA:	out std_logic_vector(15 downto 0)
    );
end multiplexer_RA;

architecture multiplexer_RA_arch of multiplexer_RA is
begin
     process (SEL_ADD, i_add, sum_ra)
    begin
        if SEL_ADD = '0' then
            output_mux_RA<= i_add;
        elsif SEL_ADD = '1' then
            output_mux_RA <= sum_ra;
        end if;
    end process;

end multiplexer_RA_arch;
---------------------------------------------------------------------------------------------------------------------------------------

--MUX_O_MEM_DATA-----------------------------------------------------------------------------------------------------------------------
--Seleziona se far uscire il valore di credibilità o l'ultimo valore valido
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_o_mem_data is
    port(
        RC: in std_logic_vector(7 downto 0);
        RD: in std_logic_vector(7 downto 0);
        SEL_OUT: in std_logic;
        output_mux_data: out std_logic_vector(7 downto 0)
    );
end multiplexer_o_mem_data;

architecture multiplexer_o_mem_data_arch of multiplexer_o_mem_data is

begin
    --quando sel =0, O_MEM_DATA = RC
    --quando sel =1, O_MEM_DATA = RD
    process (SEL_OUT, RC, RD)
    begin
        if SEL_OUT = '0' then
            output_mux_data <= RC;
        elsif SEL_OUT = '1' then
            output_mux_data <= RD;
        else
            -- Default case if SEL_OUT is not 0 or 1
            output_mux_data <= (others => 'X'); -- Output undetermined
        end if;
    end process;
end multiplexer_o_mem_data_arch;
---------------------------------------------------------------------------------------------------------------------------------------

--MUX_RK----------------------------------------------------------------------------------------------------------------------
--Impone che il DONE rimanga basso nelle fasi di non elaborazione
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_RK is
 Port ( 
    xnor_input: in std_logic;
    DONE_MUX: in std_logic;
    output_mux_K: out std_logic
 );
end mux_RK;

architecture mux_RK_arch of mux_RK is

begin
 process (DONE_MUX, xnor_input)
    begin
        if DONE_MUX= '0' then
            output_mux_K <= '0';
        elsif DONE_MUX = '1' then
            output_mux_K <= xnor_input;
        end if;
    end process;

end mux_RK_arch;
---------------------------------------------------------------------------------------------------------------------------------------




--REGISTRI: elementi di memoria dinamica a cui si appoggia la logica del circuito------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Registro RC--------------------------------------------------------------------------------------------------------------------------
--Gestisce dinamicamente il valore di credibilità attraverso un sottrattore
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RC is
    port(
        i_clk : in std_logic;
        RC_RST : in std_logic;
        SUB_RC: in std_logic_vector(7 downto 0);
        output_RC : out std_logic_vector(7 downto 0)
    );
end RC;

architecture RC_arch of RC is
begin
    process(RC_RST,i_clk)
    begin
        if RC_RST = '1' then
            output_RC <= "00011111"; --Il reset è fissato a 31
        elsif i_clk'event and i_clk='1' then
            output_RC <= SUB_RC;
        end if;
    end process;
end RC_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--Registro RA------------------------------------------------------------------------------------------------------------------------------
--Necessario per il calcolo degli indirizzi
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RA is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        mux_RA : in std_logic_vector(15 downto 0);
        output_RA : out std_logic_vector(15 downto 0)
    );
end RA;

architecture RA_arch of RA is
begin  
    process(i_rst,i_clk)
    begin
        if (i_rst = '1') then
            output_RA <= (others =>'0');
        elsif (i_clk'event and i_clk='1') then
            output_RA <= mux_RA;
        end if;
    end process;
    
end RA_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--Registro RD------------------------------------------------------------------------------------------------------------------------------
--Salva l'ultimo valore letto diverso da zero
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
begin

	memory : process(RD_RST, i_clk)
	begin 
		if(RD_RST='1') then
		    output_RD <= (others =>'0');
		elsif(i_clk'event and i_clk='1' and RD_EN='1') then
			output_RD <= i_mem_data;
		end if;
	end process;
end RD_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--Registro RK------------------------------------------------------------------------------------------------------------------------------
--Necessario per il calcolo di K
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RK is 
 port( 
	i_clk : in std_logic;
	RK_RST : in std_logic;
	SUM_RK: in std_logic_vector(9 downto 0);
	output_RK : out std_logic_vector(9 downto 0)
 ); 
end RK;
architecture RK_arch of RK is 
begin
	process(i_clk, RK_RST)
	begin
		if RK_RST = '1' then
			output_RK <= (others =>'0');
		elsif i_clk'event and i_clk='1' then
		  output_RK <= SUM_RK;
		end if;
	end process;
end RK_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--SOMMATORI E SOTTRATTORI: componenti che si occupano dell'incremento e decremento di determinati valori nel circuito
--SUB_RC-----------------------------------------------------------------------------------------------------------------------------------
--Il componente si occupa di decrementare di 1 il valore di credibilità quando riceve il segnale di enable corrispondente
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SUB_RC is
    Port (
        RC: in std_logic_vector(7 downto 0);
        SUB_EN: in std_logic;
        output_SUM_RC: out std_logic_vector(7 downto 0)
    );
end SUB_RC;

architecture SUB_RC_arch of SUB_RC is
   signal s_borrow : std_logic_vector(7 downto 0); 
begin
  SUB0: entity work.half_subtractor
        port map (
            a => RC(0),
            b => SUB_EN,
            borrow => s_borrow(0),
            res => output_SUM_RC(0)
        );
       GEN_HALF_SUB: for i in 1 to 7 generate 
                HA_i: entity work.half_subtractor
                    port map(
                       a => RC(i),
                       b => s_borrow(i-1),
                       borrow => s_borrow(i),
                       res => output_SUM_RC(i)
            );
            end generate GEN_HALF_SUB;

end SUB_RC_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--SUM_RA-----------------------------------------------------------------------------------------------------------------------------------
--Calcola l'indirizzo di memoria successivo
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_RA is
    Port (
        RA: in std_logic_vector(15 downto 0);
        ADD_EN: in std_logic;
        output_SUM_RA: out std_logic_vector(15 downto 0)
    );
end SUM_RA;


architecture SUM_RA_arch of SUM_RA is

   signal carry: std_logic_vector(15 downto 0);
 begin   
    HA0: entity work.half_adder
        port map(
            a => RA(0),
		    b => ADD_EN,
		    c => carry(0),
		    s => output_SUM_RA(0)
    );
    
    GEN_HALF_ADDERS: for i in 1 to 15 generate 
        HA_i: entity work.half_adder
            port map(
               a => RA(i),
		       b => carry(i-1),
		       c => carry(i),
		       s => output_SUM_RA(i)
    );
    end generate GEN_HALF_ADDERS;
end SUM_RA_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--SUM_RK-----------------------------------------------------------------------------------------------------------------------------------
--Incrementa di 1 il valore K
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM_K is
    Port (
        RK: in std_logic_vector(9 downto 0);
        K_EN: in std_logic;
        output_SUM_RK: out std_logic_vector(9 downto 0)
    );
end SUM_K;

architecture SUM_K_arch of SUM_K is
 signal carry: std_logic_vector(9 downto 0);
 
begin
     HA0: entity work.half_adder
        port map(
            a => RK(0),
		    b => K_EN,
		    c => carry(0),
		    s => output_SUM_RK(0)
    );
    
     GEN_HALF_ADDERS: for i in 1 to 9 generate 
        HA_i: entity work.half_adder
            port map(
               a => RK(i),
		       b => carry(i-1),
		       c => carry(i),
		       s => output_SUM_RK(i)
    );
    end generate GEN_HALF_ADDERS;
    
end SUM_K_arch;
-------------------------------------------------------------------------------------------------------------------------------------------





--MACCHINE A STATI FINITI---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--FSM--------------------------------------------------------------------------------------------------------------------------------------
--La macchina gestisce la logica principale del circuito
library ieee;
use ieee.std_logic_1164.all;
entity FSM is
    port(
        START: in std_logic;
        E: in std_logic;
        DONE: in std_logic;
        CHECK_ZERO: in std_logic;
        clk: in std_logic;
        rst: in std_logic;


        ADD_EN: out std_logic;
        RD_EN: out std_logic;
        SEL_OUT: out std_logic;
        RC_RST: out std_logic;
        RD_RST: out std_logic;
        RK_RST: out std_logic;
        SEL_ADD: out std_logic;
        SUB_EN: out std_logic;
        O_MEM_EN: out std_logic;
        O_MEM_WE: out std_logic;
        DONE_MUX_SEL: out std_logic
    );
end entity;

architecture FSM_arch of FSM is
    type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, SF);
    signal curr_state: S;

begin
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= S0;
        elsif clk'event and clk='1' then
            case curr_state is

                when S0 =>
                    if START='0' then
                        curr_state <= S0;
                    elsif START='1' then
                        curr_state <= S1;
                    end if;
                when S1 =>
                    if DONE='0' then
                        curr_state <= S2;
                    elsif DONE='1' then
                        curr_state <=SF;
                    end if;
                when S2 =>
                    if DONE='0' then
                        curr_state <= S3;
                    elsif DONE='1' then
                        curr_state <= SF;
                    end if;
                when S3 =>
                    if E='0' then
                        curr_state<= S4;
                    elsif E='1' then
                        curr_state <= S5;
                    end if;
                when S4 =>
                    if DONE='0' then
                        curr_state <= S6;
                    elsif DONE='1' then
                        curr_state <= SF;
                    end if;
                when S5 =>
                        curr_state <= S2;
                when S6 =>
                    if DONE='0' then
                        curr_state <= S7;
                    elsif DONE='1' then
                        curr_state <= SF;
                    end if;
                
                    --curr_state <=S7;
                when S7 =>
                    if E='0' then
                       curr_state <=S10;
                    elsif E='1' then
                        curr_state <= S8;
                    end if;
                when S8 =>
                    curr_state <=S9;
                when S9 =>
                    if CHECK_ZERO ='1' then
                        curr_state <= S12;
                    elsif CHECK_ZERO ='0' then
                        curr_state <=S6;
                    end if;
                when S10 =>
                    curr_state <=S11;
                when S11 =>
                     curr_state <=S6;
                when S12 => 
                    if DONE='0' then
                        curr_state <= S7;
                    elsif DONE='1' then
                        curr_state <= SF;
                    end if;
                when SF =>
                    if START='1' and DONE='1' then
                        curr_state <= SF;
                    elsif START='0' and DONE='1' then
                        curr_state <= S0;
                    end if;
            end case;
        end if;
    end process;

    process(curr_state)
    begin
        ADD_EN<='0';
        RD_EN <='0';
        SEL_OUT <='0';
        RC_RST <='0';
        RD_RST <='0';
        RK_RST <='0';
        SEL_ADD <='0';
        SUB_EN <='0';
        O_MEM_EN <='0';
        O_MEM_WE <='0';
        DONE_MUX_SEL <= '1';

        if curr_state = S0 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '1';
            RD_RST <= '1';
            RK_RST <='1';
            SUB_EN <= '0';
            O_MEM_EN <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='0';
            DONE_MUX_SEL <= '0';

        elsif curr_state = S1 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='0';

        elsif curr_state = S2 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S3 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S4 then
            ADD_EN <='1';
            RD_EN <= '1';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S5 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S6 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '1';
            O_MEM_EN <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S7 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';

        elsif curr_state = S8 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '1';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';

        elsif curr_state = S9 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';
            
        elsif curr_state = S10 then
            ADD_EN <='1';
            RD_EN <= '1';
            SEL_OUT <= '0';
            RC_RST <= '1';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='1';
            
        elsif curr_state = S11 then
            ADD_EN <='1';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '1';
            SEL_ADD <='1';
            
        elsif curr_state = S12 then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '1';
            O_MEM_WE <= '0';
            SEL_ADD <='1';
            
        elsif curr_state = SF then
            ADD_EN <='0';
            RD_EN <= '0';
            SEL_OUT <= '0';
            RC_RST <= '0';
            RD_RST <= '0';
            RK_RST <='0';
            SUB_EN <= '0';
            O_MEM_EN <= '0';
            O_MEM_WE <= '0';
            SEL_ADD <='0';
        end if;
    end process;

end FSM_arch;
-------------------------------------------------------------------------------------------------------------------------------------------

--FSM_K------------------------------------------------------------------------------------------------------------------------------------
--Una macchina secondaria che gestisce l'incremento di k
library ieee;
use ieee.std_logic_1164.all;

entity FSMK is
    port(
        ADD_EN: in std_logic;
        clk: in std_logic;
        rst: in std_logic;
        INC_EN: out std_logic
    );
end entity;

architecture FSMK_arch of FSMK is
    type S is (S0, S1, S2);
    signal curr_state: S;

begin
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= S0;
        elsif clk'event and clk='1' then
            case curr_state is
                when S0 =>
                    if ADD_EN='0' then
                        curr_state <= S0;
                    elsif ADD_EN='1' then
                        curr_state <= S1;
                    end if;
                when S1 =>
                    if ADD_EN='0' then
                        curr_state <= S1;
                    elsif ADD_EN='1' then
                        curr_state <= S2;
                    end if;
                when S2=>
                    if ADD_EN='0' then
                        curr_state <= S0;
                    elsif ADD_EN='1' then
                        curr_state <= S1;
                    end if;
            end case;
        end if;
    end process;

    process(curr_state)
    begin
        INC_EN <='0';

        if curr_state = S0 then
            INC_EN <= '0';
        elsif curr_state = S1 then
            INC_EN <= '0';
        elsif curr_state = S2 then
            INC_EN <= '1';
        end if;
    end process;
end FSMK_arch;
-------------------------------------------------------------------------------------------------------------------------------------------





--PROGETTO: il componente vero e proprio con la relativa interfaccia verso l'esterno-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port (
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_start: in std_logic;
        i_add: in std_logic_vector(15 downto 0);
        i_k: in std_logic_vector(9 downto 0);

        o_done: out std_logic;

        o_mem_addr: out std_logic_vector(15 downto 0);
        i_mem_data: in std_logic_vector(7 downto 0);
        o_mem_data: out std_logic_vector(7 downto 0);
        o_mem_we: out std_logic;
        o_mem_en: out std_logic

    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

    --multiplexer_o_mem_data
    component multiplexer_o_mem_data is
        port(
            RC: in std_logic_vector(7 downto 0);
            RD: in std_logic_vector(7 downto 0);
            SEL_OUT: in std_logic;
            output_mux_data: out std_logic_vector(7 downto 0)
        );
    end component;

    --multiplexer RA 
    component multiplexer_RA is
        Port (
             i_add: in std_logic_vector(15 downto 0);
             sum_ra: in std_logic_vector(15 downto 0);
             SEL_ADD: in std_logic;
             output_mux_RA:	out std_logic_vector(15 downto 0)
        );
    end component;
    
    --multiplexer K 
    component mux_RK is
             Port ( 
                xnor_input: in std_logic;
                DONE_MUX: in std_logic;
                output_mux_K: out std_logic
             );
    end component;

    
    --RC 
    component RC is
        port(
            i_clk : in std_logic;
            RC_RST : in std_logic;
            SUB_RC: in std_logic_vector(7 downto 0);
            output_RC : out std_logic_vector(7 downto 0)
        );
    end component;

    --RA 
    component RA is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            mux_RA : in std_logic_vector(15 downto 0);
            output_RA : out std_logic_vector(15 downto 0)
        );
    end component;

    --RK 
    component RK is
        port(
            i_clk : in std_logic;
            RK_RST : in std_logic;
            SUM_RK: in std_logic_vector(9 downto 0);
            output_RK : out std_logic_vector(9 downto 0)
        );
    end component;

    --RD 
    component RD is
        port(
            i_mem_data : in std_logic_vector(7 downto 0);
            i_clk : in std_logic;
	        RD_RST: in std_logic;
	        RD_EN: in std_logic;
	        output_RD: out std_logic_vector(7 downto 0)
        );
    end component;

    --XNOR 
    component XNOR_K is
        port(
            i_rst: in std_logic;
            i_k: in std_logic_vector(9 downto 0);
            RK: in std_logic_vector(9 downto 0);
            output_XNOR_K: out std_logic
        );
    end component;

    --SUM RA 
    component SUM_RA is
        Port (
            RA: in std_logic_vector(15 downto 0);
            ADD_EN: in std_logic;
            output_SUM_RA: out std_logic_vector(15 downto 0)
        );
    end component;

    --SUB RC
    component SUB_RC is
        Port (
            RC: in std_logic_vector(7 downto 0);
            SUB_EN: in std_logic;
            output_SUM_RC: out std_logic_vector(7 downto 0)
        );
    end component;

    --SUM RK
    component SUM_K is
        Port (
            RK: in std_logic_vector(9 downto 0);
            K_EN: in std_logic;
            output_SUM_RK: out std_logic_vector(9 downto 0)
        );
    end component;

    --FSM 
    component FSM is
        port(
            START, E, DONE, CHECK_ZERO, clk, rst: in std_logic;
            ADD_EN, RD_EN, SEL_OUT, RC_RST, RD_RST, RK_RST, SEL_ADD, SUB_EN, O_MEM_EN, O_MEM_WE: out std_logic;
            DONE_MUX_SEL: out std_logic
        );
    end component;

    --FSM_K
    component FSMK is
        port(
            ADD_EN, clk, rst: in std_logic;
            INC_EN: out std_logic
        );
    end component;

    signal add_en: std_logic;
    signal rd_en: std_logic;
    signal sub_en: std_logic;


    signal s_E: std_logic;


    signal rc_rst: std_logic;
    signal reg_cred: std_logic_vector(7 downto 0);
    signal sub_cred : std_logic_vector(7 downto 0);
    signal sub_reg_cred: std_logic_vector (7 downto 0);
    signal s_check_zero: std_logic;

    signal reg_data: std_logic_vector(7 downto 0);
    signal sel_out : std_logic;
    signal rd_rst: std_logic;
    signal rk_rst: std_logic;

    signal sum_reg_addr: std_logic_vector (15 downto 0);
    signal reg_addr: std_logic_vector (15 downto 0);
    signal sel_add: std_logic;
    signal mux_ra: std_logic_vector (15 downto 0);

    signal reg_k: std_logic_vector(9 downto 0);
    signal sum_reg_k: std_logic_vector(9 downto 0);
    signal inc_en: std_logic;
    signal done_mux_sel: std_logic;
    

    signal done: std_logic;

begin

    s_E<='1' when i_mem_data=("00000000") else '0';
    s_check_zero <= '1' when reg_cred=("00000000") else '0';

    
    reg_cred_1: RC port map(
            i_clk => i_clk,
            RC_RST => rc_rst,
            SUB_RC => sub_cred,
            output_RC => reg_cred
        );

    sub_reg_cred_1: SUB_RC port map(
            RC => reg_cred,
            SUB_EN => sub_en,
            output_SUM_RC => sub_cred
        );
        
    mux_2: multiplexer_RA port map(
            i_add=> i_add,
            sum_ra => sum_reg_addr,
            SEL_ADD => sel_add,
            output_mux_RA => mux_ra
        );
    reg_addr_1: RA port map(
            i_clk => i_clk,
            i_rst => i_rst,
            mux_RA => mux_ra,
            output_RA => reg_addr
        );
        o_mem_addr <= reg_addr;
    
    sum_reg_addr_1: SUM_RA port map (
            RA=> reg_addr,
            ADD_EN => add_en,
            output_SUM_RA => sum_reg_addr
        );
    
    mux_1: multiplexer_o_mem_data port map(
            RC => reg_cred,
            RD => reg_data,
            SEL_OUT => sel_out,
            output_mux_data => o_mem_data
    );

    reg_data_1: RD port map(
            i_mem_data => i_mem_data,
            i_clk => i_clk,
            RD_RST => rd_rst,
            RD_EN => rd_en,
            output_RD => reg_data
        );

    FSM_1 : FSM port map(
            START => i_start,
            E => s_E,
            DONE => done,
            CHECK_ZERO => s_check_zero,
            clk => i_clk,
            rst => i_rst,
            ADD_EN => add_en,
            RD_EN => rd_en,
            SEL_OUT => sel_out,
            RC_RST => rc_rst,
            RD_RST => rd_rst,
            RK_RST => rk_rst,
            SUB_EN => sub_en,
            O_MEM_EN => o_mem_en,
            O_MEM_WE => o_mem_we,
            DONE_MUX_SEL => done_mux_sel,
            SEL_ADD => SEL_ADD
        );

    reg_k_1: RK port map(
            i_clk => i_clk,
            RK_RST => rk_rst,
            SUM_RK => sum_reg_k,
            output_RK => reg_k
        );

    sum_reg_k_1: SUM_K port map(
            RK => reg_k,
            K_EN => inc_en,
            output_SUM_RK => sum_reg_k
        );

    x_nor_k: XNOR_K port map(
            i_rst => i_rst,
            i_k => i_k,
            RK => sum_reg_k,
            output_XNOR_K => done
        );
   --  o_done <= done;
    
   mux_3: mux_RK port map(
         xnor_input => done,
        DONE_MUX => done_mux_sel,
        output_mux_K => o_done
      );

    FSM_K: FSMK port map(
            ADD_EN => add_en,
            clk => i_clk,
            rst => i_rst,
            INC_EN => inc_en
        );
end Behavioral;
-------------------------------------------------------------------------------------------------------------------------------------------