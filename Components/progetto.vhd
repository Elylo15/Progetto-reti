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
        o_mem_e: out std_logic

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

    --RC 
    component RC is
        port(
            i_clk : in std_logic;
            i_rst : in std_logic;
            SUB_RC: in std_logic_vector(7 downto 0);
            SUB_EN: in std_logic;
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
            i_rst : in std_logic;
            SUM_RK: in std_logic_vector(9 downto 0);
            K_EN: in std_logic;
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
            ADD_EN, RD_EN, SEL_OUT, RC_RST, RD_RST, SEL_ADD, SUB_EN, O_MEM_E, O_MEM_WE: out std_logic
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


    signal E: std_logic;


    signal rc_rst: std_logic;
    signal reg_cred: std_logic_vector(7 downto 0);
    signal sub_cred : std_logic_vector(7 downto 0);
    signal sub_reg_cred: std_logic_vector (7 downto 0);
    signal check_zero: std_logic;

    signal reg_data: std_logic_vector(7 downto 0);
    signal sel_out : std_logic;
    signal rd_rst: std_logic;

    signal sum_reg_addr: std_logic_vector (15 downto 0);
    signal reg_addr: std_logic_vector (15 downto 0);
    signal sel_add: std_logic;
    signal mux_ra: std_logic_vector (15 downto 0);

    signal reg_k: std_logic_vector(9 downto 0);
    signal sum_reg_k: std_logic_vector(9 downto 0);
    signal inc_en: std_logic;

    signal done: std_logic;

begin

    E <= not(i_mem_data(0))or not(i_mem_data(1)) or not(i_mem_data(2)) or not(i_mem_data(3)) or not(i_mem_data(4)) or not(i_mem_data(5)) or not(i_mem_data(6)) or not(i_mem_data(7));
    check_zero <= not(reg_addr(0)) or not(reg_addr(1)) or not(reg_addr(2)) or not(reg_addr(3)) or not(reg_addr(4)) or not(reg_addr(5)) or not(reg_addr(6)) or not(reg_addr(7))or not(reg_addr(8))or not(reg_addr(9))or not(reg_addr(10))or not(reg_addr(11))or not(reg_addr(12))or not(reg_addr(13))or not(reg_addr(14))or not(reg_addr(15));

    mux_1: multiplexer_o_mem_data port map(
            RC => reg_cred,
            RD => reg_data,
            SEL_OUT => sel_out,
            output_mux_data => o_mem_data
        );
    reg_cred_1: RC port map(
            i_clk => i_clk,
            i_rst => i_rst,
            SUB_RC => sub_cred,
            SUB_EN => sub_en,
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

    sum_reg_addr_1: SUM_RA port map (
            RA=> reg_addr,
            ADD_EN => add_en,
            output_SUM_RA => sum_reg_addr
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
            E => E,
            DONE => done,
            CHECK_ZERO => check_zero,
            clk => i_clk,
            rst => i_rst,
            ADD_EN => add_en,
            RD_EN => rd_en,
            SEL_OUT => sel_out,
            RC_RST => rc_rst,
            RD_RST => rd_rst,
            SUB_EN => sub_en,
            O_MEM_E => o_mem_e,
            O_MEM_WE => o_mem_we
        );

    reg_k_1: RK port map(
            i_clk => i_clk,
            i_rst => i_rst,
            SUM_RK => sum_reg_k,
            K_EN => inc_en,
            output_RK => reg_k
        );

    sum_reg_k_1: SUM_K port map(
            RK => reg_k,
            K_EN => inc_en,
            output_SUM_RK => sum_reg_k
        );

    x_nor_k: XNOR_K port map(
            i_k => i_k,
            RK => reg_k,
            output_XNOR_K => o_done
        );

    FSM_K: FSMK port map(
            ADD_EN => add_en,
            clk => i_clk,
            rst => i_rst,
            INC_EN => inc_en
        );
end Behavioral;
