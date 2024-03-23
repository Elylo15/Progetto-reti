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

    --multiplexer
    component multiplexer_o_mem_data is
        port(
            RC: in std_logic_vector(7 downto 0);
            RD: in std_logic_vector(7 downto 0);
            SEL_OUT: in std_logic;
            o_mem_data:	out std_logic_vector(7 downto 0)
        );
    end component;

    --RC 
    component RC is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            RC: in std_logic_vector(15 downto 0);
            SUB_EN: in std_logic;
            output : out std_logic_vector(15 downto 0)
        );
    end component;

    --RA 
    component RA is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            i_add : in std_logic_vector(15 downto 0);
            RA: in std_logic_vector(15 downto 0);
            ADD_EN: in std_logic;
            output : out std_logic_vector(15 downto 0)
        );
    end component;

    --RK 
    component RK is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            RK: in std_logic_vector(9 downto 0);
            K_EN: in std_logic;
            output : out std_logic_vector(9 downto 0)
        );
    end component;

    --RD 
    component RD is
        port(
            i_mem_data : in std_logic_vector(7 downto 0);
            i_clk : in std_logic;
            i_rst : in std_logic;
            RD_RST: in std_logic;
            RD_EN: in std_logic;
            output: out std_logic_vector(7 downto 0)
        );
    end component;


    --OR
    component or_i_mem_data is
        port(
            i_mem_data: in std_logic_vector(7 downto 0);
            E: out std_logic
        );
    end component;


    --XNOR 
    component XNOR_K is
        port(
            i_k: in std_logic_vector(9 downto 0);
            RK: in std_logic_vector(9 downto 0);
            output: out std_logic
        );
    end component;

    --SUM RA 
    component SUM_RA is
        Port (
            RA: in std_logic_vector(15 downto 0);
            ADD_EN: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
    end component;

    --SUB RC
    component SUB_RC is
        Port (
            RC: in std_logic_vector(15 downto 0);
            SUB_EN: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
    end component;

    --SUM RK
    component SUM_K is
        Port (
            RK: in std_logic_vector(9 downto 0);
            K_EN: in std_logic;
            output: out std_logic_vector(9 downto 0)
        );
    end component;

    --half adder 
    --component half_adder is
    --    port(
    --		a: in std_logic;
    --		b: in std_logic;
    --		c: out std_logic;
    --		s: out std_logic
    --	);
    --end component;

    --half subtractor 
    --component half_subtractor is
    --    Port (
    --        a: in std_logic;
    --        b: in std_logic;
    --        borrow: out std_logic;
    --        diff: out std_logic
    --    );
    --end component;

    --FSM 
    component FSM is
        port(
            START, E, DONE, clk, rst: in std_logic;
            ADD_EN, RD_EN, SEL_OUT, RC_RST, RD_RST, SUB_EN, O_MEM_EN, O_MEM_WE: out std_logic
        );
    end component;

    --FSM_K
    component FSMK is
    port(
        ADD_EN, ck, rst: in std_logic;
        INC_EN: out std_logic
    );
    end component;

    signal add_en: std_logic;
    signal rd_en: std_logic;
    signal sub_en: std_logic;
  
    signal sel_out : std_logic;
    signal E: std_logic;

    signal rc_rst: std_logic;
    signal rd_rst: std_logic;

    signal reg_cred: std_logic_vector(7 downto 0);
    signal sub_cred : std_logic_vector(7 downto 0);
    signal sub_reg_cred: std_logic_vector (7 downto 0);
   
    signal reg_data: std_logic_vector(7 downto 0);
    
    signal sum_reg_addr: std_logic_vector (15 downto 0);
    signal reg_addr: std_logic_vector (15 downto 0);
    
    signal reg_k: std_logic_vector(9 downto 0);
    signal sum_reg_k: std_logic_vector(9 downto 0);
    signal inc_en: std_logic;
    
    signal done: std_logic; 
    
begin

    mux: multiplexer_o_mem_data port map(
            RC => reg_cred,
            RD => reg_data,
            SEL_OUT => sel_out,
            o_mem_data => o_mem_data
    );

    reg_cred_1: RC port map(
        i_clk => i_clk,
        i_rst => i_rst,
        RC => sub_cred,
        SUB_EN => sub_en,
        output => reg_cred
   );
   
   sum_reg_cred: SUB_RC port map(
         RC => reg_cred,
         SUB_EN => sub_en,
         output => sub_cred
   );
   
   reg_addr_1: RA port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_add => i_add,
        RA => sum_reg_addr,
        ADD_EN => add_en,
        output => reg_addr 
   );
   
   sum_reg_addr_1: SUM_RA port map (
       RA=> reg_addr,
       ADD_EN => add_en,
       output => sum_reg_addr 
   );
   
   or_start: or_i_mem_data port map(
            i_mem_data => i_mem_data,
            E => E
   ); 
   
   reg_data_1: RD port map(
        i_mem_data => i_mem_data,
        i_clk => i_clk,
        i_rst => i_rst,
        RD_RST => rd_rst,
        RD_EN => rd_en,
        output => reg_data
   );
   
   FSM_1 : FSM port map(
        START => i_start,
        E => E,
        DONE => done,
        clk => i_clk,
        rst => i_rst,
        ADD_EN => add_en,
        RD_EN => rd_en,
        SEL_OUT => sel_out,
        RC_RST => rc_rst,
        RD_RST => rd_rst,
        SUB_EN => sub_en,
        O_MEM_EN => o_mem_en,
        O_MEM_WE => o_mem_we
   );
   
   reg_k_1: RK port map(
         i_clk => i_clk,
         i_rst => i_rst,
         RK => sum_reg_k,
         K_EN => inc_en,
         output => reg_k
   );
   
   sum_reg_k_1: SUM_K port map(
         RK => reg_k,
         K_EN => inc_en,
         output => sum_reg_k
   );
   
   x_nor_k: XNOR_K port map(
        i_k => i_k,
        RK => reg_k,
        output => o_done
   );
   
   FSM_K: FSMK port map(
        ADD_EN => add_en,
        ck => i_clk,
        rst => i_rst,
        INC_EN => inc_en
   );
end Behavioral;


