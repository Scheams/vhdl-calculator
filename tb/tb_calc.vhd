library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_calc is
end entity tb_calc;

architecture sim of tb_calc is

    component calc
        port (
            clk_i   : in std_logic;
            reset_i : in std_logic;
            sw_i    : in std_logic_vector (15 downto 0);
            pb_i    : in std_logic_vector ( 3 downto 0);

            ss_o        : out std_logic_vector ( 7 downto 0);
            ss_sel_o    : out std_logic_vector ( 3 downto 0);
            led_o       : out std_logic_vector (15 downto 0)
        );
    end component;

    signal s_clk_i    : std_logic;
    signal s_reset_i  : std_logic;
    signal s_sw_i     : std_logic_vector (15 downto 0);
    signal s_pb_i     : std_logic_vector ( 3 downto 0);
    signal s_ss_o     : std_logic_vector ( 7 downto 0);
    signal s_ss_sel_o : std_logic_vector ( 3 downto 0);
    signal s_led_o    : std_logic_vector (15 downto 0);

    signal s_sw_op        : natural range 0 to 4095;
    signal s_sw_operation : std_logic_vector(3 downto 0);

begin

    u_dut: calc
    port map(
        clk_i    => s_clk_i,
        reset_i  => s_reset_i,
        sw_i     => s_sw_i,
        pb_i     => s_pb_i,
        ss_o     => s_ss_o,
        ss_sel_o => s_ss_sel_o,
        led_o    => s_led_o
    );

    s_sw_i(11 downto  0) <= std_logic_vector(to_unsigned(s_sw_op, 12));
    s_sw_i(15 downto 12) <= s_sw_operation;

    p_reset: process
    begin
        s_reset_i <= '1';
        wait for 10 ns;
        s_reset_i <= '0';
        wait;
    end process p_reset;

    p_clk: process
    begin
        s_clk_i <= '1';
        wait for 5 ns;
        s_clk_i <= '0';
        wait for 5 ns;
    end process p_clk;

    p_sim: process
    begin
        s_sw_op <= 0;
        s_sw_operation <= "0000";
        s_pb_i <= (others => '0');
        wait for 1 ms;

        -- Enter operand 1
        wait for 3 ms;
        s_pb_i(0) <= '1';
        wait for 3 ms;
        s_pb_i(0) <= '0';
        wait for 1 ms;
        s_sw_op <= 15;

        -- Enter operand 2
        wait for 3 ms;
        s_pb_i(1) <= '1';
        wait for 3 ms;
        s_pb_i(1) <= '0';
        wait for 1 ms;
        s_sw_op <= 31;

        -- Enter operation
        wait for 3 ms;
        s_pb_i(2) <= '1';
        wait for 3 ms;
        s_pb_i(2) <= '0';
        wait for 1 ms;
        s_sw_operation <= "0000"; -- ADD

        -- Calculate and display
        wait for 3 ms;
        s_pb_i(3) <= '1';
        wait for 3 ms;
        s_pb_i(3) <= '0';

        -- Enter operand 1
        s_sw_op <= 2500;
        wait for 3 ms;
        s_pb_i(0) <= '1';
        wait for 3 ms;
        s_pb_i(0) <= '0';

        -- Enter operation
        wait for 3 ms;
        s_pb_i(2) <= '1';
        wait for 3 ms;
        s_pb_i(2) <= '0';
        wait for 1 ms;
        s_sw_operation <= "0110"; -- SQR

        -- Calculate and display
        wait for 3 ms;
        s_pb_i(3) <= '1';
        wait for 3 ms;
        s_pb_i(3) <= '0';

        -- Enter operation
        wait for 3 ms;
        s_pb_i(2) <= '1';
        wait for 3 ms;
        s_pb_i(2) <= '0';
        wait for 1 ms;
        s_sw_operation <= "1011"; -- XOR

        -- Enter operand 1
        s_sw_op <= 4095;
        wait for 3 ms;
        s_pb_i(0) <= '1';
        wait for 3 ms;
        s_pb_i(0) <= '0';

        -- Enter operand 2
        wait for 3 ms;
        s_pb_i(1) <= '1';
        wait for 3 ms;
        s_pb_i(1) <= '0';
        wait for 1 ms;
        s_sw_op <= 1365;

        -- Calculate and display
        wait for 3 ms;
        s_pb_i(3) <= '1';
        wait for 3 ms;
        s_pb_i(3) <= '0';

        -- Enter operand 1
        s_sw_op <= 1365;
        wait for 3 ms;
        s_pb_i(0) <= '1';
        wait for 3 ms;
        s_pb_i(0) <= '0';

        -- Enter operation
        wait for 3 ms;
        s_pb_i(2) <= '1';
        wait for 3 ms;
        s_pb_i(2) <= '0';
        wait for 1 ms;
        s_sw_operation <= "1000"; -- NOT

        -- Calculate and display
        wait for 3 ms;
        s_pb_i(3) <= '1';
        wait for 3 ms;
        s_pb_i(3) <= '0';
        wait;
    end process p_sim;

end architecture sim;
