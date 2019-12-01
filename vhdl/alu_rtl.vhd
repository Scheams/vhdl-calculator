--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     30.11.2019
--
-- Unit:        ALU Unit (Architecture)
--
-- Version:
--      -) Version 1.0.1
--
-- Changelog:
--      -) Version 1.0.0 (30.11.2019)
--         First implementation of ALU architecture.
--      -) Version 1.0.1 (01.12.2019)
--         Add process for error handling that also generates a finished pulse.
--
-- Description:
--      The ALU can perform different kind of operations such as add, square
--      root, NOT and XOR. There are two inputs for the operands and one
--      for the type of operation.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of alu is

    ----------------------------------------------------------------------------
    -- Signals for add operation
    ----------------------------------------------------------------------------
    signal s_add_finished  : std_logic;
    signal s_add_result    : std_logic_vector (15 downto 0);
    signal s_add_sign      : std_logic;
    signal s_add_overflow  : std_logic;
    signal s_add_error     : std_logic;
    signal s_add_running   : std_logic;

    ----------------------------------------------------------------------------
    -- Signals for square root operation
    ----------------------------------------------------------------------------
    signal s_sqr_finished  : std_logic;
    signal s_sqr_result    : std_logic_vector (15 downto 0);
    signal s_sqr_sign      : std_logic;
    signal s_sqr_overflow  : std_logic;
    signal s_sqr_error     : std_logic;
    signal s_sqr_running   : std_logic;

    ----------------------------------------------------------------------------
    -- Signals for NOT operation
    ----------------------------------------------------------------------------
    signal s_not_finished  : std_logic;
    signal s_not_result    : std_logic_vector (15 downto 0);
    signal s_not_sign      : std_logic;
    signal s_not_overflow  : std_logic;
    signal s_not_error     : std_logic;
    signal s_not_running   : std_logic;

    ----------------------------------------------------------------------------
    -- Signals for XOR operation
    ----------------------------------------------------------------------------
    signal s_xor_finished  : std_logic;
    signal s_xor_result    : std_logic_vector (15 downto 0);
    signal s_xor_sign      : std_logic;
    signal s_xor_overflow  : std_logic;
    signal s_xor_error     : std_logic;
    signal s_xor_running   : std_logic;

    ----------------------------------------------------------------------------
    -- Signals for Error handling
    ----------------------------------------------------------------------------
    signal s_err_running  : std_logic;
    signal s_err_finished : std_logic;

begin

    -- MUX for finshed flag
    with optype_i select finished_o <=
        s_add_finished when "0000",
        s_sqr_finished when "0110",
        s_not_finished when "1000",
        s_xor_finished when "1011",
        s_err_finished when others;

    -- MUX for result output
    with optype_i select result_o <=
        s_add_result when "0000",
        s_sqr_result when "0110",
        s_not_result when "1000",
        s_xor_result when "1011",
        (others => '0') when others;

    -- MUX for sign flag
    with optype_i select sign_o <=
        s_add_sign when "0000",
        s_sqr_sign when "0110",
        s_not_sign when "1000",
        s_xor_sign when "1011",
        '0' when others;

    -- MUX for overflow flag
    with optype_i select overflow_o <=
        s_add_overflow when "0000",
        s_sqr_overflow when "0110",
        s_not_overflow when "1000",
        s_xor_overflow when "1011",
        '0' when others;

    -- MUX for error flag
    with optype_i select error_o <=
        s_add_error when "0000",
        s_sqr_error when "0110",
        s_not_error when "1000",
        s_xor_error when "1011",
        '1' when others;

    ----------------------------------------------------------------------------
    -- Process for add operation
    ----------------------------------------------------------------------------
    p_add: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_add_finished <= '0';
            s_add_result <= (others => '0');
            s_add_sign <= '0';
            s_add_overflow <= '0';
            s_add_error <= '0';
            s_add_running <= '0';
        elsif clk_i'event and clk_i = '1' then
            if s_add_running = '1' then
                s_add_finished <= '1';
                s_add_running <= '0';
            elsif start_i = '1' then
                s_add_result <= std_logic_vector(unsigned("0000" & op1_i) +
                    unsigned("0000" & op2_i));
                s_add_sign <= '0';
                s_add_overflow <= '0';
                s_add_error <= '0';
                s_add_finished <= '0';
                s_add_running <= '1';
            else
                s_add_finished <= '0';
            end if;
        end if;
    end process p_add;

    ----------------------------------------------------------------------------
    -- Process for square root operation
    ----------------------------------------------------------------------------
    p_sqr: process(clk_i, reset_i)
        variable value   : integer;
        variable sub     : integer;
        variable counter : natural;
    begin
        if reset_i = '1' then
            s_sqr_finished <= '0';
            s_sqr_result <= (others => '0');
            s_sqr_sign <= '0';
            s_sqr_overflow <= '0';
            s_sqr_error <= '0';
            s_sqr_running <= '0';
            value := 0;
            sub := 0;
            counter := 0;
        elsif clk_i'event and clk_i = '1' then
            if s_sqr_running = '1' then
                value := value - sub;
                if value < 0 then
                    s_sqr_result <= std_logic_vector(to_unsigned(counter, 16));
                    s_sqr_sign <= '0';
                    s_sqr_overflow <= '0';
                    s_sqr_error <= '0';
                    s_sqr_running <= '0';
                    s_sqr_finished <= '1';
                else
                    sub := sub + 2;
                    counter := counter + 1;
                end if;
            elsif start_i = '1' and optype_i = "0110" then
                value := to_integer(unsigned(op1_i));
                sub := 1;
                counter := 0;
                s_sqr_running <= '1';
                s_sqr_finished <= '0';
            else
                s_sqr_finished <= '0';
            end if;
        end if;
    end process p_sqr;

    ----------------------------------------------------------------------------
    -- Process for NOT operation
    ----------------------------------------------------------------------------
    p_not: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_not_finished <= '0';
            s_not_result <= (others => '0');
            s_not_sign <= '0';
            s_not_overflow <= '0';
            s_not_error <= '0';
            s_not_running <= '0';
        elsif clk_i'event and clk_i = '1' then
            if s_not_running = '1' then
                s_not_finished <= '1';
                s_not_running <= '0';
            elsif start_i = '1' then
                s_not_result <= "0000" & (not op1_i);
                s_not_sign <= '0';
                s_not_overflow <= '0';
                s_not_error <= '0';
                s_not_finished <= '0';
                s_not_running <= '1';
            else
                s_not_finished <= '0';
            end if;
        end if;
    end process p_not;

    ----------------------------------------------------------------------------
    -- Process for XOR operation
    ----------------------------------------------------------------------------
    p_xor: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_xor_finished <= '0';
            s_xor_result <= (others => '0');
            s_xor_sign <= '0';
            s_xor_overflow <= '0';
            s_xor_error <= '0';
            s_xor_running <= '0';
        elsif clk_i'event and clk_i = '1' then
            if s_xor_running = '1' then
                s_xor_running <= '0';
                s_xor_finished <= '1';
            elsif start_i = '1' then
                s_xor_result <= "0000" & (op1_i xor op2_i);
                s_xor_sign <= '0';
                s_xor_overflow <= '0';
                s_xor_error <= '0';
                s_xor_finished <= '0';
                s_xor_running <= '1';
            else
                s_xor_finished <= '0';
            end if;
        end if;
    end process p_xor;

    ----------------------------------------------------------------------------
    -- Process for error handling
    ----------------------------------------------------------------------------
    p_err: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_err_running <= '0';
            s_err_finished <= '0';
        elsif clk_i'event and clk_i = '1' then
            if s_err_running = '1' then
                s_err_running <= '0';
                s_err_finished <= '1';
            elsif start_i = '1' then
                s_err_running <= '1';
                s_err_finished <= '0';
            else
                s_err_finished <= '0';
            end if;
        end if;
    end process p_err;
end rtl;
