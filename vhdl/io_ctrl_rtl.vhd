---------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     18.11.2019
--
-- Unit:        IO Control Unit (Architecture)
--
-- Version:
--      -) Version 1.0.1
--
-- Changelog:
--    -) Version 1.0.0 (21.11.2019)
--       First implementation of IO Control architecture.
--    -) Version 1.0.1 (25.11.2019)
--       Enable signal shall only be one system clock cycle and
--       sequential process use clk_i as clock line.
--       Use a decreasing counter so the counter compares against
--       zero (uses less resources).
--       Debounce buttons with a 2-stage Flip-Flop machine.
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

    -- C_EN_FREQ: 1kHz internal enable signal
    -- C_COUNTER_PRELOAD: Preload value for the counter
    constant C_EN_FREQ : integer := 1000;
    constant C_COUNTER_PRELOAD  : integer := 
                                sys_freq / C_EN_FREQ - 1;

    -- s_en_counter: Counter for the enable signal
    -- s_int_en: Internal enable signal
    signal s_en_counter : integer range 0 to C_COUNTER_PRELOAD;
    signal s_int_en : std_logic;

    -- s_digit: The digit which is currently selected (round-robin)
    signal s_digit : integer range 0 to 3;

begin

    -----------------------------------------------------------------
    -- Create a enable signal with a lower frequency for other
    -- internal units.
    -----------------------------------------------------------------
    p_en_signal: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_en_counter <= 0;
            s_int_en <= '0';
        elsif clk_i'event and clk_i = '1' then
            -- If decreasing counter reaches zero, set enable signal
            -- for one clock cylce and reload counter
            if s_en_counter = 0 then
                s_en_counter <= C_COUNTER_PRELOAD;
                s_int_en <= '1';

            -- Count down and set enable signal to LOW
            else
                s_en_counter <= s_en_counter - 1;
                s_int_en <= '0';
            end if;
        end if;
    end process p_en_signal;

    -----------------------------------------------------------------
    -- The debounce process filters out signal noise of a switch
    -- and button press.
    -----------------------------------------------------------------
    p_debounce: process(clk_i, reset_i)
        variable v_ff0 : std_logic_vector (19 downto 0);
        variable v_ff1 : std_logic_vector (19 downto 0);
        variable v_set : std_logic_vector (19 downto 0);
        variable v_clear : std_logic_vector (19 downto 0);
        variable v_sync : std_logic_vector (19 downto 0);
    begin
        if reset_i = '1' then
            swsync_o <= (others => '0');
            pbsync_o <= (others => '0');

            v_ff0 := (others => '0');
            v_ff1 := (others => '0');
            v_set := (others => '0');
            v_clear := (others => '0');
            v_sync := (others => '0');
        elsif clk_i'event and clk_i = '1' then
            if s_int_en = '1' then
                -- Guide buttons and switches through a 2-stage
                -- Flip-Flop machine (if value stays constant for
                -- 2 cycles they are transfered to the output)
                v_ff1 := v_ff0;
                v_ff0 (15 downto 0) := sw_i;
                v_ff0 (19 downto 16) := pb_i;

                -- Take values of the two stage Flip-Flop
                -- machine to generate a set and a clear mask
                v_set := v_ff0 and v_ff1;
                v_clear := (not v_ff0) and (not v_ff1);

                -- Set and clear bits on the result stage
                v_sync := (v_sync and (not v_clear)) or v_set;

                -- Assign results to the synchronized outputs
                swsync_o <= v_sync (15 downto 0);
                pbsync_o <= v_sync (19 downto 16);
            end if;
        end if;
    end process p_debounce;

    -----------------------------------------------------------------
    -- The display control process drives 4 7-segment displays. A
    -- digit control signal selects in a scanning manner one
    -- display after another and the data signals represent a value 
    -- on the 7-segment display.
    -----------------------------------------------------------------
    p_display_ctrl: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            ss_o <= "11111111";
            ss_sel_o <= "1111";
            s_digit <= 0;
        elsif clk_i'event and clk_i = '1' then
            if s_int_en = '1' then
                -- Select one segment by setting common anode low
                -- Set according digit values to 7-segment output
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
        end if;
    end process p_display_ctrl;

    led_o <= led_i;

end rtl;
