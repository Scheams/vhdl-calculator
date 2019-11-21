---------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     18.11.2019
--
-- Unit:        IO Control Unit (Architecture)
--
-- Version:
--      -) Version 1.0.0 / 21.11.2019
--
-- Description:
--      The IO Control Unit is part of the VHDL calculator project.
--      It manages the debouncing of the switches and pushbuttons.
--      Furthermore the LEDs and the 7-segment display are 
--      controlled.
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of io_ctrl is

    -- C_INTERNAL_CLOCK: 1kHz internal clock for the processes
    -- C_COMPARE_VALUE: The compare value for the prescaler
    constant C_INTERNAL_CLOCK : integer := 1000;
    constant C_COMPARE_VALUE  : integer := 
                                sys_freq / (2 * C_INTERNAL_CLOCK);

    -- s_prescaler: A counter for the prescaler
    -- s_int_clk: The internal clock
    signal s_prescaler : integer range 0 to C_COMPARE_VALUE;
    signal s_int_clk : std_logic;

    -- s_digit: The digit which is currently selected (round-robin)
    signal s_digit : integer range 0 to 3;

begin

    -----------------------------------------------------------------
    -- The prescaler process for internal unit. Reduce the system
    -- clock down to a useable frequency.
    -----------------------------------------------------------------
    p_clock_prescaler: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_prescaler <= C_COMPARE_VALUE;
            s_int_clk <= '0';
        elsif clk_i'event and clk_i = '1' then
            if s_prescaler = C_COMPARE_VALUE then
                s_prescaler <= 0;
                s_int_clk <= not s_int_clk;
            else
                s_prescaler <= s_prescaler + 1;
            end if;
        end if;
    end process p_clock_prescaler;

    -----------------------------------------------------------------
    -- The debounce process filters out signal noise of a switch
    -- and button press.
    -----------------------------------------------------------------
    p_debounce: process(s_int_clk, reset_i)
    begin
        if reset_i = '1' then
            swsync_o <= (others => '0');
            pbsync_o <= (others => '0');
        elsif s_int_clk'event and s_int_clk = '1' then
            swsync_o <= sw_i;
            pbsync_o <= pb_i;
        end if;
    end process p_debounce;

    -----------------------------------------------------------------
    -- The display control process drives 4 7-segment displays. A
    -- digit control signal selects in a scanning manner one
    -- display after another and the data signals represent a value 
    -- on the 7-segment display.
    -----------------------------------------------------------------
    p_display_ctrl: process(s_int_clk, reset_i)
    begin
        if reset_i = '1' then
            ss_o <= "11111111";
            ss_sel_o <= "1111";
            s_digit <= 0;
        elsif s_int_clk'event and s_int_clk = '1' then

            -- The select signal is active low (common anode)
            case s_digit is
                when 0 =>
                    ss_sel_o <= "1110";
                    ss_o <= dig0_i;
                    s_digit <= 1;
                when 1 =>
                    ss_sel_o <= "1101";
                    ss_o <= dig1_i;
                    s_digit <= 2;
                when 2 =>
                    ss_sel_o <= "1011";
                    ss_o <= dig2_i;
                    s_digit <= 3;
                when 3 =>
                    ss_sel_o <= "0111";
                    ss_o <= dig3_i;
                    s_digit <= 0;
                when others =>
                    ss_sel_o <= "1111";
                    ss_o <= "11111111";
                    s_digit <= 0;
            end case;
        end if;
    end process p_display_ctrl;

    led_o <= led_i;

end rtl;
