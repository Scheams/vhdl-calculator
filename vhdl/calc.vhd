--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     30.11.2019
--
-- Unit:        Calculator/Top Unit (Entity)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (30.11.2019)
--         First implementation of Calculator/Top Unit entity.
--
-- Description:
--      This is the top level unit that combines all other units to the
--      calculator.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity calc is

    port (
        ------------------------------------------------------------------------
        -- INPUTS
        -- clk_i: 100MHz system clock
        -- reset_i: System reset line (Push button on Basys3-Board)
        -- sw_i: Switches on Basys3-Board
        -- pb_i: Push-buttons on Basys3-Board
        ------------------------------------------------------------------------
        clk_i   : in std_logic;
        reset_i : in std_logic;
        sw_i    : in std_logic_vector (15 downto 0);
        pb_i    : in std_logic_vector ( 3 downto 0);

        ------------------------------------------------------------------------
        -- OUTPUTS
        -- ss_o: 7-segment display lines on Basys3-Board
        -- ss_sel_o: 7-segment digit select lines on Basys3-Board
        -- led_o: LEDs on Basys3-Board
        ------------------------------------------------------------------------
        ss_o        : out std_logic_vector ( 7 downto 0);
        ss_sel_o    : out std_logic_vector ( 3 downto 0);
        led_o       : out std_logic_vector (15 downto 0)
    );

end calc;
