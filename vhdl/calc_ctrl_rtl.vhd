library ieee;
use ieee.std_logic_1164.all;

architecture rtl of calc_ctrl is

    constant C_DIGIT_0 : std_logic_vector (7 downto 0) := "00000011";
    constant C_DIGIT_1 : std_logic_vector (7 downto 0) := "10011111";
    constant C_DIGIT_2 : std_logic_vector (7 downto 0) := "00100101";
    constant C_DIGIT_3 : std_logic_vector (7 downto 0) := "00001101";
    constant C_DIGIT_4 : std_logic_vector (7 downto 0) := "10011001";
    constant C_DIGIT_5 : std_logic_vector (7 downto 0) := "01001001";
    constant C_DIGIT_6 : std_logic_vector (7 downto 0) := "11000001";
    constant C_DIGIT_7 : std_logic_vector (7 downto 0) := "00011111";
    constant C_DIGIT_8 : std_logic_vector (7 downto 0) := "00000001";
    constant C_DIGIT_9 : std_logic_vector (7 downto 0) := "00001001";
    constant C_DIGIT_A : std_logic_vector (7 downto 0) := "00010001";
    constant C_DIGIT_B : std_logic_vector (7 downto 0) := "11000001";
    constant C_DIGIT_C : std_logic_vector (7 downto 0) := "10011101";
    constant C_DIGIT_D : std_logic_vector (7 downto 0) := "10000101";
    constant C_DIGIT_E : std_logic_vector (7 downto 0) := "01100001";
    constant C_DIGIT_F : std_logic_vector (7 downto 0) := "01110001";

    constant C_DIGIT_S : std_logic_vector (7 downto 0) := "01001001";
    constant C_DIGIT_Q : std_logic_vector (7 downto 0) := "00001001";
    constant C_DIGIT_R : std_logic_vector (7 downto 0) := "11110101";
    constant C_DIGIT_N : std_logic_vector (7 downto 0) := "11010101";
    constant C_DIGIT_O : std_logic_vector (7 downto 0) := "11000101";

    constant C_DIGIT_O_DP  : std_logic_vector (7 downto 0) := "11000100";
    constant C_DIGIT_MINUS : std_logic_vector (7 downto 0) := "11111101";
    constant C_DIGIT_DARK  : std_logic_vector (7 downto 0) := "11111111";

    constant C_OP_ADD           : std_logic_vector (3 downto 0) := "0000";
    constant C_OP_SQUARE_ROOT   : std_logic_vector (3 downto 0) := "0110";
    constant C_OP_NOT           : std_logic_vector (3 downto 0) := "1000";
    constant c_OP_XOR           : std_logic_vector (3 downto 0) := "1011";

    type t_digits is (
        SS_0,
        SS_1,
        SS_2,
        SS_3,
        SS_4,
        SS_5,
        SS_6,
        SS_7,
        SS_8,
        SS_9,
        SS_A,
        SS_B,
        SS_C,
        SS_D,
        SS_E,
        SS_F,
        SS_S,
        SS_Q,
        SS_R,
        SS_N,
        SS_O,
        SS_O_DP,
        SS_MINUS,
        SS_DARK
    );

    type t_state is (
        S_RESET,
        S_ENTER_OP_1,
        S_ENTER_OP_2,
        S_ENTER_OPERATION,
        S_CALCULATE,
        S_DISPLAY
    );

    function f_raw_to_dig (
        p_raw : std_logic_vector (7 downto 0) := C_DIGIT_DARK;
        p_alternative : std_logic := '0')
    return t_digits is
    begin
        case p_raw is
            when C_DIGIT_0 => return SS_0;
            when C_DIGIT_1 => return SS_1;
            when C_DIGIT_2 => return SS_2;
            when C_DIGIT_3 => return SS_3;
            when C_DIGIT_4 => return SS_4;
            when C_DIGIT_5 => -- Same as C_DIGIT_S
                if p_alternative = '0' then return SS_5;
                else return SS_S;
                end if;
            when C_DIGIT_6 => -- Same as C_DIGIT_B
                if p_alternative = '0' then return SS_6;
                else return SS_B;
                end if;
            when C_DIGIT_7 => return SS_7;
            when C_DIGIT_8 => return SS_8;
            when C_DIGIT_9 => -- Same as C_DIGIT_Q
                if p_alternative = '0' then return SS_9;
                else return SS_Q;
                end if;
            when C_DIGIT_A => return SS_A;
            when C_DIGIT_C => return SS_C;
            when C_DIGIT_D => return SS_D;
            when C_DIGIT_E => return SS_E;
            when C_DIGIT_F => return SS_F;
            when C_DIGIT_R => return SS_R;
            when C_DIGIT_N => return SS_N;
            when C_DIGIT_O => return SS_O;
            when C_DIGIT_O_DP => return SS_O_DP;
            when C_DIGIT_MINUS => return SS_MINUS;
            when others     => return SS_DARK;
        end case;
    end function;

    function f_hex_to_digit (p_hex : std_logic_vector (3 downto 0) := "0000") 
    return std_logic_vector is
    begin
        case p_hex is
            when "0000" => return C_DIGIT_0;
            when "0001" => return C_DIGIT_1;
            when "0010" => return C_DIGIT_2;
            when "0011" => return C_DIGIT_3;
            when "0100" => return C_DIGIT_4;
            when "0101" => return C_DIGIT_5;
            when "0110" => return C_DIGIT_6;
            when "0111" => return C_DIGIT_7;
            when "1000" => return C_DIGIT_8;
            when "1001" => return C_DIGIT_9;
            when "1010" => return C_DIGIT_A;
            when "1011" => return C_DIGIT_B;
            when "1100" => return C_DIGIT_C;
            when "1101" => return C_DIGIT_D;
            when "1110" => return C_DIGIT_E;
            when "1111" => return C_DIGIT_F;
            when others => return C_DIGIT_DARK;
        end case;
    end function;

    procedure p_op_to_digit(
        signal s_optype_o : in std_logic_vector (3 downto 0);
        signal s_dig0 : out std_logic_vector (7 downto 0);
        signal s_dig1 : out std_logic_vector (7 downto 0);
        signal s_dig2 : out std_logic_vector (7 downto 0)
    ) is
    begin
        case s_optype_o is 
            when C_OP_ADD =>
                s_dig0 <= C_DIGIT_D;
                s_dig1 <= C_DIGIT_D;
                s_dig2 <= C_DIGIT_A;

            when C_OP_SQUARE_ROOT =>
                s_dig0 <= C_DIGIT_S;
                s_dig1 <= C_DIGIT_R;
                s_dig2 <= C_DIGIT_O;

            when C_OP_NOT =>
                s_dig0 <= C_DIGIT_DARK;
                s_dig1 <= C_DIGIT_N;
                s_dig2 <= C_DIGIT_O;

            when c_OP_XOR =>
                s_dig0 <= C_DIGIT_E;
                s_dig1 <= C_DIGIT_O;
                s_dig2 <= C_DIGIT_R;

            when others =>
                s_dig0 <= C_DIGIT_DARK;
                s_dig1 <= C_DIGIT_DARK;
                s_dig2 <= C_DIGIT_DARK;
        end case;
    end procedure;

    signal s_state : t_state;
    signal s_op1_o : std_logic_vector (11 downto 0);
    signal s_op2_o : std_logic_vector (11 downto 0);
    signal s_optype_o : std_logic_vector (3 downto 0);

    signal s_dig0_o : std_logic_vector (7 downto 0);
    signal s_dig1_o : std_logic_vector (7 downto 0);
    signal s_dig2_o : std_logic_vector (7 downto 0);
    signal s_dig3_o : std_logic_vector (7 downto 0);

    signal s_dig0 : t_digits;
    signal s_dig1 : t_digits;
    signal s_dig2 : t_digits;
    signal s_dig3 : t_digits;

begin

    s_dig0 <= f_raw_to_dig(s_dig0_o);
    s_dig1 <= f_raw_to_dig(s_dig1_o);
    s_dig2 <= f_raw_to_dig(s_dig2_o);
    s_dig3 <= f_raw_to_dig(s_dig3_o);

    p_fsm_comb: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_state <= S_RESET;
            s_op1_o <= (others => '0');
            s_op2_o <= (others => '0');
            s_optype_o <= C_OP_ADD;
            start_o <= '0';

        elsif clk_i'event and clk_i = '1' then
            -- BTNL pressed
            if pbsync_i(0)'event and pbsync_i(0) = '1' then
                s_state <= S_ENTER_OP_1;
    
            -- BTNC pressed
            elsif pbsync_i(1)'event and pbsync_i(1) = '1' then
                s_state <= S_ENTER_OP_2;
    
            -- BTNR pressed
            elsif pbsync_i(2)'event and pbsync_i(2) = '1' then
                s_state <= S_ENTER_OPERATION;
    
            -- BTND pressed
            elsif pbsync_i(3)'event and pbsync_i(3) = '1' then
                s_state <= S_RESET;
            end if;

            case s_state is
                when S_ENTER_OP_1 =>
                    s_op1_o <= swsync_i(11 downto 0);

                when S_ENTER_OP_2 =>
                    s_op2_o <= swsync_i(11 downto 0);

                when S_ENTER_OPERATION =>
                    s_optype_o <= swsync_i(15 downto 12);

                when S_CALCULATE =>
                    start_o <= '0';
                    s_state <= S_CALCULATE;
                    if finished_i = '1' then
                        s_state <= S_DISPLAY;
                    end if;

                when S_DISPLAY =>

                -- S_RESET
                when others =>
                    s_state <= S_CALCULATE;
                    start_o <= '1';
            end case;
        end if;
    end process p_fsm_comb;

    op1_o <= s_op1_o;
    op2_o <= s_op2_o;
    optype_o <= s_optype_o;
    dig0_o <= s_dig0_o;
    dig1_o <= s_dig1_o;
    dig2_o <= s_dig2_o;
    dig3_o <= s_dig3_o;

    p_fsm_ss: process(s_state, s_op1_o, s_op2_o, s_optype_o, result_i, error_i, overflow_i, sign_i)
    begin
        case s_state is
            when S_ENTER_OP_1 =>
                s_dig0_o <= f_hex_to_digit(s_op1_o( 3 downto 0));
                s_dig1_o <= f_hex_to_digit(s_op1_o( 7 downto 4));
                s_dig2_o <= f_hex_to_digit(s_op1_o(11 downto 8));
                s_dig3_o <= C_DIGIT_1;

            when S_ENTER_OP_2 =>
                s_dig0_o <= f_hex_to_digit(s_op2_o( 3 downto 0));
                s_dig1_o <= f_hex_to_digit(s_op2_o( 7 downto 4));
                s_dig2_o <= f_hex_to_digit(s_op2_o(11 downto 8));
                s_dig3_o <= C_DIGIT_2;

            when S_ENTER_OPERATION =>
                p_op_to_digit(s_optype_o, s_dig0_o, s_dig1_o, s_dig3_o);
                s_dig3_o <= C_DIGIT_O_DP;

            when S_CALCULATE =>
                s_dig0_o <= C_DIGIT_DARK;
                s_dig1_o <= C_DIGIT_DARK;
                s_dig2_o <= C_DIGIT_DARK;
                s_dig3_o <= C_DIGIT_DARK;

            when S_DISPLAY =>
                if error_i = '1' then
                    s_dig0_o <= C_DIGIT_DARK;
                    s_dig1_o <= C_DIGIT_R;
                    s_dig2_o <= C_DIGIT_R;
                    s_dig3_o <= C_DIGIT_E;
                elsif overflow_i = '1' then
                    s_dig0_o <= C_DIGIT_O;
                    s_dig1_o <= C_DIGIT_O;
                    s_dig2_o <= C_DIGIT_O;
                    s_dig3_o <= C_DIGIT_O;
                elsif sign_i = '1' then
                    s_dig0_o <= f_hex_to_digit(result_i( 3 downto 0));
                    s_dig1_o <= f_hex_to_digit(result_i( 7 downto 4));
                    s_dig2_o <= f_hex_to_digit(result_i(11 downto 8));
                    s_dig3_o <= C_DIGIT_MINUS;
                else
                    s_dig0_o <= f_hex_to_digit(result_i( 3 downto 0));
                    s_dig1_o <= f_hex_to_digit(result_i( 7 downto 4));
                    s_dig2_o <= f_hex_to_digit(result_i(11 downto 8));
                    s_dig3_o <= f_hex_to_digit(result_i(15 downto 12));
                end if;

            -- S_RESET
            when others =>
                s_dig0_o <= C_DIGIT_DARK;
                s_dig1_o <= C_DIGIT_DARK;
                s_dig2_o <= C_DIGIT_DARK;
                s_dig3_o <= C_DIGIT_DARK;
        end case;
    end process p_fsm_ss;

    p_fsm_led: process(s_state)
    begin
        case s_state is
            when S_ENTER_OP_1 =>       led_o <= (others => '0');
            when S_ENTER_OP_2 =>       led_o <= (others => '0');
            when S_ENTER_OPERATION =>  led_o <= (others => '0');
            when S_CALCULATE =>        led_o <= (others => '0');
            when S_DISPLAY =>          led_o <= (15 => '1', others => '0');
            when others =>             led_o <= (others => '0');
        end case;
    end process p_fsm_led;
end rtl;
