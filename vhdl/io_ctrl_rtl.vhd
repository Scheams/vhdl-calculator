library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of io_ctrl is

    constant C_INTERNAL_CLOCK : integer := 1000;
    constant C_COMPARE_VALUE : integer := clk_freq / (2 * C_INTERNAL_CLOCK);

    signal s_prescaler : integer range 0 to C_COMPARE_VALUE;
    signal s_int_clk : std_logic;

    signal s_digit : integer range 0 to 3;

begin

    p_clock_prescaler: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_prescaler <= 0;
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

    p_display_ctrl: process(s_int_clk, reset_i)
    begin
        if reset_i = '1' then
            ss_o <= "11111111";
            ss_sel_o <= "1111";
            s_digit <= 0;
        elsif s_int_clk'event and s_int_clk = '1' then

            case s_digit is
                when 0 =>
                    ss_sel_o <= "1110";
                    ss_o <= dig0_i;
                when 1 =>
                    ss_sel_o <= "1101";
                    ss_o <= dig1_i;
                when 2 =>
                    ss_sel_o <= "1011";
                    ss_o <= dig2_i;
                when 3 =>
                    ss_sel_o <= "0111";
                    ss_o <= dig3_i;
                when others =>
                    ss_sel_o <= "1111";
                    ss_o <= "11111111";
                    s_digit <= 0;
            end case;

            if s_digit = 3 then
                s_digit <= 0;
            else
                s_digit <= s_digit + 1;
            end if;
        end if;
    end process p_display_ctrl;

    led_o <= led_i;

end rtl;
