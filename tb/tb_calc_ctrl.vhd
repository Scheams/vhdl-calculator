library ieee;
use ieee.std_logic_1164.all;

entity tb_calc_ctrl is
end tb_calc_ctrl;

architecture sim of tb_calc_ctrl is
    component calc_ctrl 
        port (
            clk_i       : in std_logic;
            reset_i     : in std_logic;
            swsync_i    : in std_logic_vector (15 downto 0);
            pbsync_i    : in std_logic_vector ( 3 downto 0);
            finished_i  : in std_logic;
            result_i    : in std_logic_vector (15 downto 0);
            sign_i      : in std_logic;
            overflow_i  : in std_logic;
            error_i     : in std_logic;

            op1_o       : out std_logic_vector (11 downto 0);
            op2_o       : out std_logic_vector (11 downto 0);
            optype_o    : out std_logic_vector ( 3 downto 0);
            start_o     : out std_logic;
            dig0_o      : out std_logic_vector ( 7 downto 0);
            dig1_o      : out std_logic_vector ( 7 downto 0);
            dig2_o      : out std_logic_vector ( 7 downto 0);
            dig3_o      : out std_logic_vector ( 7 downto 0);
            led_o       : out std_logic_vector (15 downto 0)
        );
    end component;
    
    signal s_clk_i       : std_logic;
    signal s_reset_i     : std_logic;
    signal s_swsync_i    : std_logic_vector (15 downto 0);
    signal s_pbsync_i    : std_logic_vector ( 3 downto 0);
    signal s_finished_i  : std_logic;
    signal s_result_i    : std_logic_vector (15 downto 0);
    signal s_sign_i      : std_logic;
    signal s_overflow_i  : std_logic;
    signal s_error_i     : std_logic;

    signal s_op1_o       : std_logic_vector (11 downto 0);
    signal s_op2_o       : std_logic_vector (11 downto 0);
    signal s_optype_o    : std_logic_vector ( 3 downto 0);
    signal s_start_o     : std_logic;
    signal s_dig0_o      : std_logic_vector ( 7 downto 0);
    signal s_dig1_o      : std_logic_vector ( 7 downto 0);
    signal s_dig2_o      : std_logic_vector ( 7 downto 0);
    signal s_dig3_o      : std_logic_vector ( 7 downto 0);
    signal s_led_o       : std_logic_vector (15 downto 0);

begin

    u_sim: calc_ctrl
    port map(
        clk_i      => s_clk_i,     
        reset_i    => s_reset_i,   
        swsync_i   => s_swsync_i,  
        pbsync_i   => s_pbsync_i,  
        finished_i => s_finished_i,
        result_i   => s_result_i,  
        sign_i     => s_sign_i,    
        overflow_i => s_overflow_i,
        error_i    => s_error_i,   
        op1_o      => s_op1_o,     
        op2_o      => s_op2_o,     
        optype_o   => s_optype_o,  
        start_o    => s_start_o,   
        dig0_o     => s_dig0_o,    
        dig1_o     => s_dig1_o,    
        dig2_o     => s_dig2_o,    
        dig3_o     => s_dig3_o,    
        led_o      => s_led_o   
    );

    p_reset: process
    begin
        s_reset_i <= '1';
        wait for 50 ns;
        s_reset_i <= '0';
        wait;
    end process p_reset;

    p_clk: process
    begin
        s_clk_i <= '1';
        wait for 5 ns;
        s_clk_i <= '0';
        wait for 5 ns;
    end process p_clk;

    p_sim: process
    begin
        s_finished_i <= '0';
        s_pbsync_i <= (others => '0');
        s_swsync_i <= (others => '0');
        s_result_i <= (others => '0');

        wait for 100 ns;
        s_finished_i <= '1';
        wait for 10 ns;
        s_finished_i <= '0';

        wait for 50 ns;
        s_pbsync_i(0) <= '1';
        wait for 50 ns;
        s_pbsync_i(0) <= '0';
        s_swsync_i(11 downto 0) <= X"400";

        wait for 50 ns;
        s_pbsync_i(1) <= '1';
        wait for 50 ns;
        s_pbsync_i(1) <= '0';

        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "0000";

        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';
        
        wait for 50 ns;
        s_finished_i <= '1';
        wait for 10 ns;
        s_finished_i <= '0';
        s_result_i <= X"0800";
        wait;
    end process p_sim;
end sim;
