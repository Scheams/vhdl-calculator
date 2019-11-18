library ieee;
use ieee.std_logic_1164.all;

entity calc_ctrl is

    port (
        clk_i       : in std_logic;
        reset_i     : in std_logic;
        swsync_i    : in std_logic_vector (15 downto 0);
        pbsync_i    : in std_logic_vector ( 3 downto 0);
        finished_i  : in std_logic;
        result_i    : in std_logic_vector (15 downto 0);
        sign_i      : in std_logic;
        overflow_i  : in std_logic;
        error_i     : in std_logic;

        op1_o       : out std_logic_vector (11 downto 0);
        op2_o       : out std_logic_vector (11 downto 0);
        optype_o    : out std_logic_vector ( 3 downto 0);
        start_o     : out std_logic;
        dig0_o      : out std_logic_vector ( 7 downto 0);
        dig1_o      : out std_logic_vector ( 7 downto 0);
        dig2_o      : out std_logic_vector ( 7 downto 0);
        dig3_o      : out std_logic_vector ( 7 downto 0);
        led_o       : out std_logic_vector (15 downto 0)
    );

end calc_ctrl;
