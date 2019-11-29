library ieee;
use ieee.std_logic_1164.all;

architecture struct of calc is

    component alu
        port (
            clk_i       : in std_logic;
            reset_i     : in std_logic;
            op1_i       : in std_logic_vector (11 downto 0);
            op2_i       : in std_logic_vector (11 downto 0);
            optype_i    : in std_logic_vector ( 3 downto 0);
            start_i     : in std_logic;
            finished_o  : out std_logic;
            result_o    : out std_logic_vector (15 downto 0);
            sign_o      : out std_logic;
            overflow_o  : out std_logic;
            error_o     : out std_logic
        );
    end component;

    component calc_ctrl
        port (
            clk_i       : in  std_logic;
            reset_i     : in  std_logic;
            swsync_i    : in  std_logic_vector (15 downto 0);
            pbsync_i    : in  std_logic_vector ( 3 downto 0);
            finished_i  : in  std_logic;
            result_i    : in  std_logic_vector (15 downto 0);
            sign_i      : in  std_logic;
            overflow_i  : in  std_logic;
            error_i     : in  std_logic;
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

    component io_ctrl
        port (
            clk_i   : in std_logic;
            reset_i : in std_logic;
            dig0_i  : in std_logic_vector ( 7 downto 0);
            dig1_i  : in std_logic_vector ( 7 downto 0);
            dig2_i  : in std_logic_vector ( 7 downto 0);
            dig3_i  : in std_logic_vector ( 7 downto 0);
            led_i   : in std_logic_vector (15 downto 0);
            sw_i    : in std_logic_vector (15 downto 0);
            pb_i    : in std_logic_vector ( 3 downto 0);

            ss_o        : out std_logic_vector( 7 downto 0);
            ss_sel_o    : out std_logic_vector( 3 downto 0);
            led_o       : out std_logic_vector(15 downto 0);
            swsync_o    : out std_logic_vector(15 downto 0);
            pbsync_o    : out std_logic_vector( 3 downto 0)
        );
    end component;

    signal s_op1       : std_logic_vector (11 downto 0);
    signal s_op2       : std_logic_vector (11 downto 0);
    signal s_optype    : std_logic_vector ( 3 downto 0);
    signal s_start     : std_logic;
    signal s_finished  : std_logic;
    signal s_result    : std_logic_vector (15 downto 0);
    signal s_sign      : std_logic;
    signal s_overflow  : std_logic;
    signal s_error     : std_logic;
    signal s_swsync    : std_logic_vector (15 downto 0);
    signal s_pbsync    : std_logic_vector ( 3 downto 0);
    signal s_dig0      : std_logic_vector ( 7 downto 0);
    signal s_dig1      : std_logic_vector ( 7 downto 0);
    signal s_dig2      : std_logic_vector ( 7 downto 0);
    signal s_dig3      : std_logic_vector ( 7 downto 0);
    signal s_led       : std_logic_vector (15 downto 0);

begin

    u_alu: alu
    port map(
        clk_i      => clk_i,
        reset_i    => reset_i,
        op1_i      => s_op1,
        op2_i      => s_op2,
        optype_i   => s_optype,
        start_i    => s_start,
        finished_o => s_finished,
        result_o   => s_result,
        sign_o     => s_sign,
        overflow_o => s_overflow,
        error_o    => s_error
    );

    u_calc_ctrl: calc_ctrl
    port map(
        clk_i       => clk_i,
        reset_i     => reset_i,
        swsync_i    => s_swsync,
        pbsync_i    => s_pbsync,
        finished_i  => s_finished,
        result_i    => s_result,
        sign_i      => s_sign,
        overflow_i  => s_overflow,
        error_i     => s_error,
        op1_o       => s_op1,
        op2_o       => s_op2,
        optype_o    => s_optype,
        start_o     => s_start,
        dig0_o      => s_dig0,
        dig1_o      => s_dig1,
        dig2_o      => s_dig2,
        dig3_o      => s_dig3,
        led_o       => s_led
    );

    u_io_ctrl: io_ctrl
    port map (
        clk_i    => clk_i,
        reset_i  => reset_i,
        dig0_i   => s_dig0,
        dig1_i   => s_dig1,
        dig2_i   => s_dig2,
        dig3_i   => s_dig3,
        led_i    => s_led,
        sw_i     => sw_i,
        pb_i     => pb_i,
        ss_o     => ss_o,
        ss_sel_o => ss_sel_o,
        led_o    => led_o,
        swsync_o => s_swsync,
        pbsync_o => s_pbsync
    );
end architecture struct;
