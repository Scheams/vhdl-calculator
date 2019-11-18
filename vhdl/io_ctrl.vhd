library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is

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

end io_ctrl;
