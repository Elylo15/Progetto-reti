library ieee;
use ieee.std_logic_1164.all;

constant ZERO: std_logic_vector(0 to 7) := "00000000";
constant ONE: std_logic := '1';
constant TWENTY_ONE: std_logic_vector(7 downto 0) := "00011111";

--dichiarazione delle variabili
signal E: std_logic;

signal ADD_EN: std_logic;
signal SUB_EN: std_logic;
signal RD_EN: std_logic;
signal K_EN: std_logic;

signal SEL_OUT: std_logic;

signal RC_RST: std_logic;
signal RD_RST: std_logic;

signal SUM_RA: std_logic_vector(15 downto 0);
signal SUM_K: std_logic_vector(9 downto 0);

signal DIFF_RC: std_logic_vector(7 downto 0);
signal RD: std_logic_vector(7 downto 0);


--INGRESSI
entity project_reti_logiche is
 port (
 i_clk : in std_logic;
 i_rst : in std_logic;
 i_start : in std_logic;
 i_add : in std_logic_vector(15 downto 0);
 i_k : in std_logic_vector(9 downto 0);
 o_done : out std_logic;
 o_mem_addr : out std_logic_vector(15 downto 0);
 i_mem_data : in std_logic_vector(7 downto 0);
 o_mem_data : out std_logic_vector(7 downto 0);
 o_mem_we : out std_logic;
 o_mem_en : out std_logic
 );
end project_reti_logiche;

 

--MULTIPLEXER O_MEM_DATA
entity mux_O_MEM_DATA is
	port(
		DIFF_RC: in std_logic_vector(7 downto 0);
        RD: in std_logic_vector(7 downto 0);
		SEL_OUT: in std_logic;
		o_mem_data:	out std_logic_vector(7 downto 0);
	);
end mux_O_MEM_DATA;  

architecture mux_O_MEM_DATA_dataflow of mux_O_MEM_DATA is
begin
	--quando sel =0, O_MEM_DATA = RC
	--quando sel =1, O_MEM_DATA = RD
	o_mem_data <= RC when SEL_OUT = '0' else RD;
end mux_O_MEM_DATA_dataflow;





--OR
entity OR is
	port(
		i_mem_data: in std_logic_vector(7 downto 0);
		E: out std_logic
	);
end entity OR;

architecture OR_dataflow of OR is

begin
	E <= '1' when not(i_mem_data) = (other=> '0') else '0';
end OR_dataflow;






--HALF ADDER
entity half_adder is
	port(
		a: in std_logic;
		b: in std_logic;
		c: out std_logic;
		s: out std_logic;
	);
end entity;

architecture half_adder_dataflow of half_adder is
begin
	s <= a xor b;
	c <= a and b
end half_adder_dataflow;





--REGISTER ADDRESS
entity RA is 
 port( 
	i_clk : in std_logic;
	i_rst : in std_logic; 
	i_add : in std_logic_vector(15 downto 0);
	ADD_EN: in std_logic;
	E : in std_logic;
	SUM_RA : out std_logic_vector(15 downto 0);
 ); 
end RA;

architecture RA_arch of RA is
signal AND_ADDRESS : std_logic = ADD_EN and E;
begin 
signal RA: std_logic_vector(15 downto 0);
signal x: std_logic = '1';
begin
	process(i_rst, i_clk, i_add, i_start)

	variable Sum: std_logic_vector(1 downto 0);
    variable Carry: std_logic := '0';
	begin
		-- serve per settare solo all'inizio il valore di RA = i_add
		if x = '1' then
			RA <= i_add;
			x <= '0';
		end if;
		if i_rst = '1' then
			RA <=  (others => '0');
		elsif rising_edge(i_clk) then
			Sum := RA(0) xor AND_ADDRESS;
			RA(0) <= Sum(0) xor Carry;
			Carry := (RA(0) and AND_ADDRESS) or (Carry and (RA(0) xor AND_ADDRESS));
		for i in 1 to 15 loop
			Sum := RA(i) xor RA(i-1);
			RA(i) <= Sum(0) xor Carry;
			Carry := (RA(i) and RA(i-1)) or (Carry and (RA(i) xor RA(i-1)));
		end loop;
		SUM_RA <= RA;
		end if;
	end process;
end RA_arch;




--HALF SUBTRACTOR
entity half_subtractor is
	port(
		a: in std_logic;
		b: in std_logic;
		borrow: out std_logic; 
		diff: out std_logic;
	);
end entity;

architecture half_subtractor_dataflow of half_subtractor is
begin
	diff <= a xor b;
	borrow <= (not a) and b;
end half_subtractor_dataflow;




--REGISTER CREDIBILITY
entity RC is 
 port( 
	i_clk : in std_logic;
	RC_RST: in std_logic;
	SUB_EN: in std_logic;
	DIFF_RC: out std_logic_vector(7 downto 0);
	
 ); 
end RC;

--il registro si resetta a 31 e si carica con il risultato del half subtractor
architecture RC_arch of RC is
signal RC: std_logic_vector(7 downto 0);
signal x: std_logic := '1';
signal AND_CREDIBILITY: std_logic = SUB_EN, ONE;
begin
	process(RC_RST, i_clk)
	variable DIFF_RC: std_logic;
	variable BORROW_RC: std_logic := '0';
	begin
		-- serve per settare solo all'inizio il valore di RC = 31
		if x = '1' then
			RC <= TWENTY_ONE;
			x <= '0';
		end if;
		if RC_RST = '1' then
			RC <= TWENTY_ONE;
		elsif rising_edge(i_clk) then
			DIFF_RC(0) := RC(0) xor AND_CREDIBILITY;
			RC(0) <= DIFF_RC(0);
			BORROW_RC(0) := (not RC(0)) and AND_CREDIBILITY;
			for i in 1 to 7 loop
				DIFF_RC(i) := RC(i) xor RC(i-1);
				RC(i) <= DIFF_RC(i);
				BORROW_RC(i) := (not RC(i)) and RC(i-1);
			end loop;
			DIFF_RC <= RC;
		end if;
	end process;
end RC_arch;




--REGISTER DATA
entity RD is 
 port( 
	i_mem_data : in std_logic_vector(7 downto 0);
	i_clk : in std_logic;
	i_rst : in std_logic;
	RD_RST: in std_logic;
	RD_EN: in std_logic;
	RD: out std_logic_vector(7 downto 0);
 ); 
end RD;

--il registro si resetta a 0, e si carica con i_mem_data
architecture RD_arch of RD is
begin
	process(RD_RST, i_clk, RD_EN, i_mem_data)
	begin
		if RD_RST = '1' then
			RD <= ZERO;
		--se RD_EN è attivo, carica il valore di i_mem_data
		elsif rising_edge(i_clk) and RD_EN = '1' then
			RD <= i_mem_data;
		--altrimenti, RD si mantiene invariato
		elsif rising_edge(i_clk) then
			RD <= RD;
		end if;
	end process;
end RD_arch;




--REGISTER K
entity RK is 
 port( 
	i_clk : in std_logic;
	i_rst : in std_logic;
	K_EN: in std_logic;
	SUM_K : out std_logic_vector(9 downto 0);
 ); 
end RK;

architecture RK_arch of RK is
signal RK: std_logic_vector(9 downto 0);
signal x: std_logic = '1';
signal AND_K: std_logic = K_EN and ONE;
begin
	process(i_rst, i_clk, i_add, i_start)

	variable Sum: std_logic_vector(1 downto 0);
    variable Carry: std_logic := '0';
	begin
		-- serve per settare solo all'inizio il valore di RK = 0
		if x = '1' then
			RK <=  (others => '0');
			x <= '0';
		end if;
		if i_rst = '1' then
			RK <=  (others => '0');
		elsif rising_edge(i_clk) then
			Sum := RK(0) xor AND_K;
			RK(0) <= Sum(0) xor Carry;
			Carry := (RK(0) and AND_K) or (Carry and (RK(0) xor AND_K));
		for i in 1 to 9 loop
			Sum := RK(i) xor RK(i-1);
			RK(i) <= Sum(0) xor Carry;
			Carry := (RK(i) and RK(i-1)) or (Carry and (RK(i) xor RK(i-1)));
		end loop;
		SUM_RK <= RK;
		end if;
	end process;
end RK_arch;





--xnor
entity XNOR_K is
	port(
		i_k: in std_logic_vector(9 downto 0);
		SUM_K: in std_logic_vector(9 downto 0);
		x: out std_logic
	);
end entity XNOR_K;

architecture XNOR_K_dataflow of XNOR_K is
	signal intermediate: std_logic_vector(9 downto 0);
begin
	process(i_k, SUM_K)
	begin
		for i in 0 to 9 loop
			intermediate(i) <= not (i_k(i) xnor SUM_K(i));
		end loop;
		x <= '1' when intermediate = (other=> '1') else '0';
	end process;
end XNOR_K_dataflow;



--FSM
entity FSM is
 port(
	
 );
end FSM;

architecture FSM_arch of FSM is
	type S is (S0,S1,S2,S3,S4,S5,S6,S7,S9);
	signal cur_state, next_state : S;
	
end architecture;

--FSM k
entity FSM_k is
 port(
	
 );
end FSM_k;

architecture FSM_k_arch of FSM_k is
	type S is (S0,S1);
	signal cur_state, next_state : S;
	
end architecture;







