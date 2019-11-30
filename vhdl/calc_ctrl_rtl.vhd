--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     29.11.2019
--
-- Unit:        Calculator Control Unit (Architecture)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (29.11.2019)
--         First implementation of Calculator Control architecture.
--
-- Description:
--      The Calculator Control Unit is the brain of the calculator project.
--      It connects the IO with the ALU and decides what to do at which state.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture rtl of calc_ctrl is

    ----------------------------------------------------------------------------
    -- Constants that represent one 7-segment digit
    -- The 8 bit value is written to the outputs of the cathode
    ----------------------------------------------------------------------------
    constant C_DIGIT_0 : std_logic_vector (7 downto 0) := "11000000";
    constant C_DIGIT_1 : std_logic_vector (7 downto 0) := "11111001";
    constant C_DIGIT_2 : std_logic_vector (7 downto 0) := "10100100";
    constant C_DIGIT_3 : std_logic_vector (7 downto 0) := "10110000";
    constant C_DIGIT_4 : std_logic_vector (7 downto 0) := "10011001";
    constant C_DIGIT_5 : std_logic_vector (7 downto 0) := "10010010";
    constant C_DIGIT_6 : std_logic_vector (7 downto 0) := "10000011";
    constant C_DIGIT_7 : std_logic_vector (7 downto 0) := "11111000";
    constant C_DIGIT_8 : std_logic_vector (7 downto 0) := "10000000";
    constant C_DIGIT_9 : std_logic_vector (7 downto 0) := "10010000";

    constant C_DIGIT_A : std_logic_vector (7 downto 0) := "10001000";
    constant C_DIGIT_B : std_logic_vector (7 downto 0) := "10000011";
    constant C_DIGIT_C : std_logic_vector (7 downto 0) := "11000110";
    constant C_DIGIT_D : std_logic_vector (7 downto 0) := "10100001";
    constant C_DIGIT_E : std_logic_vector (7 downto 0) := "10000110";
    constant C_DIGIT_F : std_logic_vector (7 downto 0) := "10001110";
    constant C_DIGIT_N : std_logic_vector (7 downto 0) := "10101011";
    constant C_DIGIT_O : std_logic_vector (7 downto 0) := "10100011";
    constant C_DIGIT_Q : std_logic_vector (7 downto 0) := "10011000";
    constant C_DIGIT_R : std_logic_vector (7 downto 0) := "10101111";
    constant C_DIGIT_S : std_logic_vector (7 downto 0) := "10010010";

    constant C_DIGIT_O_DP  : std_logic_vector (7 downto 0) := "00100011";
    constant C_DIGIT_MINUS : std_logic_vector (7 downto 0) := "10111111";
    constant C_DIGIT_DARK  : std_logic_vector (7 downto 0) := "11111111";

    ----------------------------------------------------------------------------
    -- Enumeration type for better readability during simulation
    ----------------------------------------------------------------------------
    type t_digits is (
        SS_0, SS_1, SS_2, SS_3, SS_4, SS_5, SS_6, SS_7, SS_8, SS_9,
        SS_A, SS_B, SS_C, SS_D, SS_E, SS_F, SS_N, SS_O, SS_Q, SS_R, SS_S,
        SS_5_OR_S, SS_6_OR_B
        SS_O_DP, SS_MINUS, SS_DARK,
        SS_UNDEF
    );

    ----------------------------------------------------------------------------
    -- Function that converts a constant C_DIGIT_* to a enum of type t_digits
    -- p_raw: The raw bits of type C_DIGIT_*
    -- return: Enumerated type of digit
    ----------------------------------------------------------------------------
    function f_raw_to_dig (
        p_raw : std_logic_vector (7 downto 0) := C_DIGIT_DARK)
    return t_digits is
    begin
        case p_raw is
            when C_DIGIT_0 => return SS_0;
            when C_DIGIT_1 => return SS_1;
            when C_DIGIT_2 => return SS_2;
            when C_DIGIT_3 => return SS_3;
            when C_DIGIT_4 => return SS_4;
            when C_DIGIT_5 => return SS_5_OR_S;
            when C_DIGIT_6 => return SS_6_OR_B;
            when C_DIGIT_7 => return SS_7;
            when C_DIGIT_8 => return SS_8;
            when C_DIGIT_9 => return SS_9;
            when C_DIGIT_A => return SS_A;
            when C_DIGIT_C => return SS_C;
            when C_DIGIT_D => return SS_D;
            when C_DIGIT_E => return SS_E;
            when C_DIGIT_F => return SS_F;
            when C_DIGIT_Q => return SS_Q;
            when C_DIGIT_R => return SS_R;
            when C_DIGIT_N => return SS_N;
            when C_DIGIT_O => return SS_O;
            when C_DIGIT_O_DP  => return SS_O_DP;
            when C_DIGIT_MINUS => return SS_MINUS;
            when C_DIGIT_DARK  => return SS_DARK;
            when others => return SS_UNDEF;
        end case;
    end function;

    ----------------------------------------------------------------------------
    -- Constants for decoding the mathematical operations
    ----------------------------------------------------------------------------
    constant C_OP_ADD           : std_logic_vector (3 downto 0) := "0000";
    constant C_OP_SQUARE_ROOT   : std_logic_vector (3 downto 0) := "0110";
    constant C_OP_NOT           : std_logic_vector (3 downto 0) := "1000";
    constant C_OP_XOR           : std_logic_vector (3 downto 0) := "1011";

    ----------------------------------------------------------------------------
    -- Enumeration type for easier readability of the operations
    ----------------------------------------------------------------------------
    type t_operation is (
        OP_ADD, OP_SQUARE_ROOT, OP_NOT, OP_XOR, OP_UNDEF
    );

    ----------------------------------------------------------------------------
    -- Function to convert the constants C_OP_* to a enum of type t_operation
    -- p_raw: Raw value of constant C_OP_*
    -- return: Enumerated type of operation
    ----------------------------------------------------------------------------
    function f_raw_to_operation (
        p_raw : std_logic_vector (3 downto 0) := "0000")
    return t_operation is
    begin
        case p_raw is
            when C_OP_ADD => return OP_ADD;
            when C_OP_SQUARE_ROOT => return OP_SQUARE_ROOT;
            when C_OP_NOT => return OP_NOT;
            when C_OP_XOR => return OP_XOR;
            when others => return OP_UNDEF;
        end case;
    end function;

    ----------------------------------------------------------------------------
    -- Function to convert a hexadecimal value (4 bit) into a single digit
    -- p_hex: Hexadecimal value (0 to 15)
    -- return: Logic vector that represent the hex value
    ----------------------------------------------------------------------------
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

    ----------------------------------------------------------------------------
    -- Procedure to convert the operation type to a 3-digit word on the
    -- seven segment display
    -- p_s_optype: Type of operation
    -- p_s_dig0: Signal to digit 0
    -- p_s_dig1: Signal to digit 1
    -- p_s_dig2: Signal to digit 2
    ----------------------------------------------------------------------------
    procedure p_op_to_digit(
        signal p_s_optype : in std_logic_vector (3 downto 0);
        signal p_s_dig0 : out std_logic_vector (7 downto 0);
        signal p_s_dig1 : out std_logic_vector (7 downto 0);
        signal p_s_dig2 : out std_logic_vector (7 downto 0)
    ) is
    begin
        case p_s_optype is
            when C_OP_ADD =>
                p_s_dig2 <= C_DIGIT_A;
                p_s_dig1 <= C_DIGIT_D;
                p_s_dig0 <= C_DIGIT_D;

            when C_OP_SQUARE_ROOT =>
                p_s_dig2 <= C_DIGIT_S;
                p_s_dig1 <= C_DIGIT_Q;
                p_s_dig0 <= C_DIGIT_R;

            when C_OP_NOT =>
                p_s_dig2 <= C_DIGIT_N;
                p_s_dig1 <= C_DIGIT_O;
                p_s_dig0 <= C_DIGIT_DARK;

            when c_OP_XOR =>
                p_s_dig2 <= C_DIGIT_E;
                p_s_dig1 <= C_DIGIT_O;
                p_s_dig0 <= C_DIGIT_R;

            when others =>
                p_s_dig2 <= C_DIGIT_DARK;
                p_s_dig1 <= C_DIGIT_DARK;
                p_s_dig0 <= C_DIGIT_DARK;
        end case;
    end procedure;

    ----------------------------------------------------------------------------
    -- Enumeration type for the internal FSM state
    ----------------------------------------------------------------------------
    type t_state is (
        S_RESET,
        S_ENTER_OP_1,
        S_ENTER_OP_2,
        S_ENTER_OPERATION,
        S_CALCULATE,
        S_DISPLAY
    );

    -- State of FSM
    signal s_state : t_state;

    -- Edge detection of pushbuttons
    signal s_pbedge : std_logic_vector (3 downto 0);
    signal s_pbff0  : std_logic_vector (3 downto 0);
    signal s_pbff1  : std_logic_vector (3 downto 0);

    -- Internal signals for storage elements
    signal s_op1_o    : std_logic_vector (11 downto 0);
    signal s_op2_o    : std_logic_vector (11 downto 0);
    signal s_optype_o : std_logic_vector ( 3 downto 0);
    signal s_dig0_o   : std_logic_vector ( 7 downto 0);
    signal s_dig1_o   : std_logic_vector ( 7 downto 0);
    signal s_dig2_o   : std_logic_vector ( 7 downto 0);
    signal s_dig3_o   : std_logic_vector ( 7 downto 0);

    -- Signals that are just for debug purposes
    signal s_dig0 : t_digits;
    signal s_dig1 : t_digits;
    signal s_dig2 : t_digits;
    signal s_dig3 : t_digits;
    signal s_optype : t_operation;

begin

    -- Convert raw outputs to enum types for simulation
    s_dig0 <= f_raw_to_dig(s_dig0_o);
    s_dig1 <= f_raw_to_dig(s_dig1_o);
    s_dig2 <= f_raw_to_dig(s_dig2_o);
    s_dig3 <= f_raw_to_dig(s_dig3_o);
    s_optype <= f_raw_to_operation(s_optype_o);

    -- Convert 2 stage Flop-Flop into edge detection
    s_pbedge <= not s_pbff1 and s_pbff0;

    ----------------------------------------------------------------------------
    -- This process controls the stages of the calculator FSM. The user is able
    -- to switch between the states "Enter Operand 1", "Enter Operand 2" and
    -- "Enter Operation" and "Display Calculation" at any time by a button
    -- press of BTNL, BTNC, BTNR or BTND
    ----------------------------------------------------------------------------
    p_fsm_seq: process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_state <= S_RESET;
            s_op1_o <= (others => '0');
            s_op2_o <= (others => '0');
            s_optype_o <= C_OP_ADD;
            start_o <= '0';
            s_pbff0 <= (others => '0');
            s_pbff1 <= (others => '0');

        elsif clk_i'event and clk_i = '1' then

            -- Two stage flipflop
            s_pbff0 <= pbsync_i;
            s_pbff1 <= s_pbff0;

            -- BTNL pressed
            if s_pbedge(0) = '1' then
                s_state <= S_ENTER_OP_1;

            -- BTNC pressed
            elsif s_pbedge(1) = '1' then
                s_state <= S_ENTER_OP_2;

            -- BTNR pressed
            elsif s_pbedge(2) = '1' then
                s_state <= S_ENTER_OPERATION;

            -- BTND pressed
            elsif s_pbedge(3) = '1' then
                s_state <= S_RESET;
            end if;

            case s_state is
                -- Stage any value given by switches into operand 1
                when S_ENTER_OP_1 =>
                    s_op1_o <= swsync_i(11 downto 0);

                -- Stage any value given by switches into operand 2
                when S_ENTER_OP_2 =>
                    s_op2_o <= swsync_i(11 downto 0);

                -- Stage any value given by switches into operation
                when S_ENTER_OPERATION =>
                    s_optype_o <= swsync_i(15 downto 12);

                -- Wait for ALU to finish its job
                when S_CALCULATE =>
                    start_o <= '0';
                    s_state <= S_CALCULATE;
                    if finished_i = '1' then
                        s_state <= S_DISPLAY;
                    end if;

                -- Do nothing at this state
                when S_DISPLAY =>

                -- Start calculation by start impuls (state S_RESET)
                when others =>
                    s_state <= S_CALCULATE;
                    start_o <= '1';
            end case;
        end if;
    end process p_fsm_seq;

    op1_o <= s_op1_o;
    op2_o <= s_op2_o;
    optype_o <= s_optype_o;
    dig0_o <= s_dig0_o;
    dig1_o <= s_dig1_o;
    dig2_o <= s_dig2_o;
    dig3_o <= s_dig3_o;

    ----------------------------------------------------------------------------
    -- This process controls the 7-segment display according to the current
    -- state of the FSM.
    ----------------------------------------------------------------------------
    p_fsm_ss: process(s_state, s_op1_o, s_op2_o, s_optype_o, result_i,
        error_i, overflow_i, sign_i)
    begin
        case s_state is
            -- Show: "1hhh"
            -- Where 1 is the indication for the state and hhh is the hex
            -- value controlled by the switches SW0 to SW11
            when S_ENTER_OP_1 =>
                s_dig0_o <= f_hex_to_digit(s_op1_o( 3 downto 0));
                s_dig1_o <= f_hex_to_digit(s_op1_o( 7 downto 4));
                s_dig2_o <= f_hex_to_digit(s_op1_o(11 downto 8));
                s_dig3_o <= C_DIGIT_1;

            -- Show: "2hhh"
            -- Where 2 is the indication for the state and hhh is the hex
            -- value controlled by the switches SW0 to SW11
            when S_ENTER_OP_2 =>
                s_dig0_o <= f_hex_to_digit(s_op2_o( 3 downto 0));
                s_dig1_o <= f_hex_to_digit(s_op2_o( 7 downto 4));
                s_dig2_o <= f_hex_to_digit(s_op2_o(11 downto 8));
                s_dig3_o <= C_DIGIT_2;

            -- Show: "o.XXX"
            -- Where o. is the indication for the state and XXX is a string
            -- that represents the operation
            when S_ENTER_OPERATION =>
                p_op_to_digit(s_optype_o, s_dig0_o, s_dig1_o, s_dig2_o);
                s_dig3_o <= C_DIGIT_O_DP;

            -- During calculation the display is turned off
            when S_CALCULATE =>
                s_dig0_o <= C_DIGIT_DARK;
                s_dig1_o <= C_DIGIT_DARK;
                s_dig2_o <= C_DIGIT_DARK;
                s_dig3_o <= C_DIGIT_DARK;

            -- After the calculation is finished, the result is displayed if
            -- no error occured. If the error flag is set, the display shows
            -- "Err ", if an overflow occured the display shows "oooo". If the
            -- sign flag is set a minus will show up "-hhh".
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

            -- During the reset state (S_RESET) all digits are dark
            when others =>
                s_dig0_o <= C_DIGIT_DARK;
                s_dig1_o <= C_DIGIT_DARK;
                s_dig2_o <= C_DIGIT_DARK;
                s_dig3_o <= C_DIGIT_DARK;
        end case;
    end process p_fsm_ss;

    ----------------------------------------------------------------------------
    -- This process turns the 16 LEDs on or off. Only during the display state
    -- the first LED is turned on.
    ----------------------------------------------------------------------------
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
