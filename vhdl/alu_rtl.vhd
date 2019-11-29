library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of alu is

    signal s_add_finished  : std_logic;
    signal s_add_result    : std_logic_vector (15 downto 0);
    signal s_add_sign      : std_logic;
    signal s_add_overflow  : std_logic;
    signal s_add_error     : std_logic;
    signal s_add_running   : std_logic;

    signal s_sqr_finished  : std_logic;
    signal s_sqr_result    : std_logic_vector (15 downto 0);
    signal s_sqr_sign      : std_logic;
    signal s_sqr_overflow  : std_logic;
    signal s_sqr_error     : std_logic;
    signal s_sqr_running   : std_logic;

    signal s_not_finished  : std_logic;
    signal s_not_result    : std_logic_vector (15 downto 0);
    signal s_not_sign      : std_logic;
    signal s_not_overflow  : std_logic;
    signal s_not_error     : std_logic;
    signal s_not_running   : std_logic;

    signal s_xor_finished  : std_logic;
    signal s_xor_result    : std_logic_vector (15 downto 0);
    signal s_xor_sign      : std_logic;
    signal s_xor_overflow  : std_logic;
    signal s_xor_error     : std_logic;
    signal s_xor_running   : std_logic;

    -- signal s_optype : std_logic_vector(3 downto 0);

begin

    -- p_mux: process(clk_i, reset_i)
    -- begin
    --     if reset_i = '1' then
    --         s_optype <= "0000";
    --         finished_o <= '0';
    --         result_o <= (others => '0');
    --         sign_o <= '0';
    --         overflow_o <= '0';
    --         error_o <= '0';
    --     elsif rising_edge(clk_i) then
    --         case optype_i is
    --             when "0000" =>
    --                 finished_o <= s_add_finished;
    --                 result_o   <= s_add_result;
    --                 sign_o     <= s_add_sign;
    --                 overflow_o <= s_add_overflow;
    --                 error_o    <= s_add_error;

    --             when "0110" =>
    --                 finished_o <= s_sqr_finished;
    --                 result_o   <= s_sqr_result;
    --                 sign_o     <= s_sqr_sign;
    --                 overflow_o <= s_sqr_overflow;
    --                 error_o    <= s_sqr_error;

    --             when "1000" =>
    --                 finished_o <= s_not_finished;
    --                 result_o   <= s_not_result;
    --                 sign_o     <= s_not_sign;
    --                 overflow_o <= s_not_overflow;
    --                 error_o    <= s_not_error;

    --             when "1011" =>
    --                 finished_o <= s_xor_finished;
    --                 result_o   <= s_xor_result;
    --                 sign_o     <= s_xor_sign;
    --                 overflow_o <= s_xor_overflow;
    --                 error_o    <= s_xor_error;

    --             when others =>
    --                 finished_o <= '0';
    --                 result_o   <= (others => '0');
    --                 sign_o     <= '0';
    --                 overflow_o <= '0';
    --                 error_o    <= '0';
    --         end case;
    --     end if;
    -- end process p_mux;

    with optype_i select finished_o <=
        s_add_finished when "0000",
        s_sqr_finished when "0110",
        s_not_finished when "1000",
        s_xor_finished when "1011",
        '0' when others;

    with optype_i select result_o <=
        s_add_result when "0000",
        s_sqr_result when "0110",
        s_not_result when "1000",
        s_xor_result when "1011",
        (others => '0') when others;

    with optype_i select sign_o <=
        s_add_sign when "0000",
        s_sqr_sign when "0110",
        s_not_sign when "1000",
        s_xor_sign when "1011",
        '0' when others;

    with optype_i select overflow_o <=
        s_add_overflow when "0000",
        s_sqr_overflow when "0110",
        s_not_overflow when "1000",
        s_xor_overflow when "1011",
        '0' when others;

    with optype_i select error_o <=
        s_add_error when "0000",
        s_sqr_error when "0110",
        s_not_error when "1000",
        s_xor_error when "1011",
        '1' when others;

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
                s_add_result <= std_logic_vector(unsigned("0000" & op1_i) + unsigned("0000" & op2_i));
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

end rtl;
