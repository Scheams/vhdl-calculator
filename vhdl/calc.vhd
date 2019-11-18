library ieee;
use ieee.std_logic_1164.all;

entity calc is

    port (
        clk_i   : in std_logic;
        reset_i : in std_logic;
        sw_i    : in std_logic_vector (15 downto 0);
        pb_i    : in std_logic_vector ( 3 downto 0);

        ss_o        : out std_logic_vector ( 7 downto 0);
        ss_sel_o    : out std_logic_vector ( 3 downto 0);
        led_o       : out std_logic_vector (15 downto 0)
    );

end calc;
