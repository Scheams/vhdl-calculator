--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     01.12.2019
--
-- Unit:        Calculator Control Unit (Testbench)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (01.12.2019)
--         First implementation of Calculator Control Unit testbench.
--
-- Description:
--      Step through all different kind of states of the FSM and input
--      some operations. Check if the ALU flags get interpreted the right way.
--------------------------------------------------------------------------------

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

    ----------------------------------------------------------------------------
    -- Generate reset pulse
    ----------------------------------------------------------------------------
    p_reset: process
    begin
        s_reset_i <= '1';
        wait for 50 ns;
        s_reset_i <= '0';
        wait;
    end process p_reset;

    ----------------------------------------------------------------------------
    -- Generate 100MHz clock
    ----------------------------------------------------------------------------
    p_clk: process
    begin
        s_clk_i <= '1';
        wait for 5 ns;
        s_clk_i <= '0';
        wait for 5 ns;
    end process p_clk;

    ----------------------------------------------------------------------------
    -- Simulation process
    ----------------------------------------------------------------------------
    p_sim: process
    begin
        -- Reset all signals
        s_finished_i <= '0';
        s_pbsync_i <= (others => '0');
        s_swsync_i <= (others => '0');
        s_result_i <= (others => '0');
        s_sign_i <= '0';
        s_overflow_i <= '0';
        s_error_i <= '0';

        ------------------------------------------------------------------------
        -- Test all states (Enter OP1, Enter OP2, Enter OP, Calculate) and all
        -- operations (ADD, Square Root, NOT, XOR)
        ------------------------------------------------------------------------

        -- Simulate a finished ALU operation
        wait for 100 ns;
        s_finished_i <= '1';
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTNL press, select operand 1 (0x400)
        wait for 50 ns;
        s_pbsync_i(0) <= '1';
        wait for 50 ns;
        s_pbsync_i(0) <= '0';
        s_swsync_i(11 downto 0) <= X"400";

        -- BTNC press, select operand 2 (0x400)
        wait for 50 ns;
        s_pbsync_i(1) <= '1';
        wait for 50 ns;
        s_pbsync_i(1) <= '0';

        -- BTNR press, select operation (ADD)
        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "0000";

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result
        wait for 50 ns;
        s_finished_i <= '1';
        s_result_i <= X"0800";
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTNR press, select operation (Square Root)
        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "0110";

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result
        wait for 50 ns;
        s_finished_i <= '1';
        s_result_i <= X"0020";
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTNR press, select operation (NOT)
        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "1000";

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result
        wait for 50 ns;
        s_finished_i <= '1';
        s_result_i <= X"0BFF";
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTNR press, select operation (XOR)
        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "1011";

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result
        wait for 50 ns;
        s_finished_i <= '1';
        s_result_i <= X"0000";
        wait for 10 ns;
        s_finished_i <= '0';

        ------------------------------------------------------------------------
        -- Check error, overflow and sign flags
        ------------------------------------------------------------------------

        -- BTNR press, select operation (Undefined)
        wait for 50 ns;
        s_pbsync_i(2) <= '1';
        wait for 50 ns;
        s_pbsync_i(2) <= '0';
        s_swsync_i(15 downto 12) <= "1111";

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result (Error)
        wait for 50 ns;
        s_finished_i <= '1';
        s_error_i <= '1';
        s_result_i <= X"0000";
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result (Overflow)
        -- Notice: This doesn't happen, but we imagine the result would overflow
        wait for 50 ns;
        s_finished_i <= '1';
        s_error_i <= '0';
        s_overflow_i <= '1';
        s_result_i <= X"0000";
        wait for 10 ns;
        s_finished_i <= '0';

        -- BTND press, execute operation
        wait for 50 ns;
        s_pbsync_i(3) <= '1';
        wait for 50 ns;
        s_pbsync_i(3) <= '0';

        -- ALU operation has finished, calculator shows result (Sign)
        -- Notice: This doesn't happen, but we imagine the result is negative
        wait for 50 ns;
        s_finished_i <= '1';
        s_overflow_i <= '0';
        s_sign_i <= '1';
        s_result_i <= X"0FFF";
        wait for 10 ns;
        s_finished_i <= '0';

        wait;
    end process p_sim;
end sim;
