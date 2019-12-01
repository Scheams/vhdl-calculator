--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     01.12.2019
--
-- Unit:        ALU Unit (Testbench)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (01.12.2019)
--         First implementation of ALU testbench.
--
-- Description:
--      Test all operations of the ALU with min, max and random values. Also
--      check if the result flags work (error, overflow, sign).
--------------------------------------------------------------------------------

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
        -- Reset state
        s_op1_i <= X"000";
        s_op2_i <= X"000";
        s_optype_i <= "0000";
        s_start_i <= '0';
        wait for 100 ns;

        ------------------------------------------------------------------------
        -- Go Through all operations with random values
        ------------------------------------------------------------------------

        -- Operation ADD
        -- 0xFFF + 0xAFC = 0x1AFB
        -- 4095 + 2812 = 6907
        s_op1_i <= X"FFF";
        s_op2_i <= X"AFC";
        s_optype_i <= "0000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation square root
        -- sqrt(0x019) = 0x005
        -- sqrt(25) = 5
        s_op1_i <= X"019";
        s_op2_i <= X"000";
        s_optype_i <= "0110";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation NOT
        -- not(0x550) = 0xAAF
        -- not(1360) = 2735
        s_op1_i <= X"550";
        s_op2_i <= X"000";
        s_optype_i <= "1000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation XOR
        -- 0xCCC xor 0xF0A = 0x3C6
        -- 3276 xor 3850 = 966
        s_op1_i <= X"CCC";
        s_op2_i <= X"F0A";
        s_optype_i <= "1011";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Undefined operation (error)
        s_op1_i <= X"000";
        s_op2_i <= X"000";
        s_optype_i <= "1111";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        ------------------------------------------------------------------------
        -- Go through all operations with min values
        ------------------------------------------------------------------------
        s_op1_i <= X"000";
        s_op2_i <= X"000";

        -- Operation ADD
        s_optype_i <= "0000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation Square Root
        s_optype_i <= "0110";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation NOT
        s_optype_i <= "1000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation XOR
        s_optype_i <= "1011";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        ------------------------------------------------------------------------
        -- Go through all operations with max values
        ------------------------------------------------------------------------
        s_op1_i <= X"FFF";
        s_op2_i <= X"FFF";

        -- Operation ADD
        s_optype_i <= "0000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation Square Root
        s_optype_i <= "0110";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation NOT
        s_optype_i <= "1000";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        -- Operation XOR
        s_optype_i <= "1011";
        s_start_i <= '1';
        wait for 10 ns;
        s_start_i <= '0';
        wait for 90 ns;

        wait;
    end process p_sim;
end sim;
