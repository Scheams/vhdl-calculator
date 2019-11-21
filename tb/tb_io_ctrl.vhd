library ieee;
use ieee.std_logic_1164.all;

entity tb_io_ctrl is
end tb_io_ctrl;

architecture sim of tb_io_ctrl is

    component io_ctrl
        port (
            clk_i   : in std_logic;
            reset_i : in std_logic;
            dig0_i  : in std_logic_vector ( 7 downto 0);
            dig1_i  : in std_logic_vector ( 7 downto 0);
            dig2_i  : in std_logic_vector ( 7 downto 0);
            dig3_i  : in std_logic_vector ( 7 downto 0);
            led_i   : in std_logic_vector (15 downto 0);
            sw_i    : in std_logic_vector (15 downto 0);
            pb_i    : in std_logic_vector ( 3 downto 0);
    
            ss_o        : out std_logic_vector( 7 downto 0);
            ss_sel_o    : out std_logic_vector( 3 downto 0);
            led_o       : out std_logic_vector(15 downto 0);
            swsync_o    : out std_logic_vector(15 downto 0);
            pbsync_o    : out std_logic_vector( 3 downto 0)
        );    
    end component;

    signal s_clk_i   : std_logic;
    signal s_reset_i : std_logic;
    signal s_dig0_i  : std_logic_vector ( 7 downto 0);
    signal s_dig1_i  : std_logic_vector ( 7 downto 0);
    signal s_dig2_i  : std_logic_vector ( 7 downto 0);
    signal s_dig3_i  : std_logic_vector ( 7 downto 0);
    signal s_led_i   : std_logic_vector (15 downto 0);
    signal s_sw_i    : std_logic_vector (15 downto 0);
    signal s_pb_i    : std_logic_vector ( 3 downto 0);
    
    signal s_ss_o        : std_logic_vector( 7 downto 0);
    signal s_ss_sel_o    : std_logic_vector( 3 downto 0);
    signal s_led_o       : std_logic_vector(15 downto 0);
    signal s_swsync_o    : std_logic_vector(15 downto 0);
    signal s_pbsync_o    : std_logic_vector( 3 downto 0);

begin

    u_sim: io_ctrl
    port map (
        clk_i   => s_clk_i,  
        reset_i => s_reset_i,
        dig0_i  => s_dig0_i, 
        dig1_i  => s_dig1_i, 
        dig2_i  => s_dig2_i, 
        dig3_i  => s_dig3_i, 
        led_i   => s_led_i,  
        sw_i    => s_sw_i,   
        pb_i    => s_pb_i,   

        ss_o        => s_ss_o,
        ss_sel_o    => s_ss_sel_o,
        led_o       => s_led_o,   
        swsync_o    => s_swsync_o,
        pbsync_o    => s_pbsync_o
    );

    p_reset: process
    begin
        s_reset_i <= '1';
        wait for 500000 ns;
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
        s_dig0_i <= "11000000";
        s_dig1_i <= "00110000";
        s_dig2_i <= "00001100";
        s_dig3_i <= "00000011";
        s_led_i <= "1000000000000001";
        s_sw_i <= "0100000000000010";
        s_pb_i <= "0110";
        wait;
    end process p_sim;
end sim;
