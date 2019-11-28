library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_alu is
end tb_alu;

architecture sim of tb_alu is

    component alu is
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
    end component alu;

    signal s_clk_i      : std_logic;
    signal s_reset_i    : std_logic;
    signal s_op1_i      : std_logic_vector (11 downto 0);
    signal s_op2_i      : std_logic_vector (11 downto 0);
    signal s_optype_i   : std_logic_vector ( 3 downto 0);
    signal s_start_i    : std_logic;
    signal s_finished_o : std_logic;
    signal s_result_o   : std_logic_vector (15 downto 0);
    signal s_sign_o     : std_logic;
    signal s_overflow_o : std_logic;
    signal s_error_o    : std_logic;

begin

    u_dut: alu
    port map(
        clk_i      => s_clk_i,
        reset_i    => s_reset_i,
        op1_i      => s_op1_i,
        op2_i      => s_op2_i,
        optype_i   => s_optype_i,
        start_i    => s_start_i,
        finished_o => s_finished_o,
        result_o   => s_result_o,
        sign_o     => s_sign_o,
        overflow_o => s_overflow_o,
        error_o    => s_error_o
    );

    ------------------------------------------------------------------
    -- Generate reset pulse
    ------------------------------------------------------------------
    p_reset: process
    begin
        s_reset_i <= '1';
        wait for 10 ns;
        s_reset_i <= '0';
        wait;
    end process p_reset;

    ------------------------------------------------------------------
    -- Generate 100MHz clock
    ------------------------------------------------------------------
    p_clk: process
    begin
        s_clk_i <= '1';
        wait for 5 ns;
        s_clk_i <= '0';
        wait for 5 ns;
    end process p_clk;

    p_sim: process
    begin
        s_op1_i <= X"000";
        s_op2_i <= X"000";
        s_optype_i <= "0000";
        s_start_i <= '0';
        wait for 100 ns;

        -- Operation ADD
        s_op1_i <= X"FFF";
        s_op2_i <= X"AFC";
        s_optype_i <= "0000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation square root
        s_op1_i <= X"019";
        s_op2_i <= X"000";
        s_optype_i <= "0110";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation NOT
        s_op1_i <= X"550";
        s_op2_i <= X"000";
        s_optype_i <= "1000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation XOR
        s_op1_i <= X"CCC";
        s_op2_i <= X"F0A";
        s_optype_i <= "1011";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;
    end process p_sim;

end sim;
