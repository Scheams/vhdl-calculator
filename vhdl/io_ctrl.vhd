---------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     18.11.2019
--
-- Unit:        IO Control Unit (Entity)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (21.11.2019)
--         First implementation of IO Control entity.
--
-- Description:
--      The IO Control Unit is part of the VHDL calculator project.
--      It manages the debouncing of the switches and pushbuttons.
--      Furthermore the LEDs and the 7-segment display are 
--      controlled.
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is

    generic (
        -- sys_freq: The frequency of system clock (100MHz)
        sys_freq : integer := 100_000_000
    );

    port (
        -- clk_i: Clock input
        -- reset_i: Reset input (active HIGH)
        -- dig0_i - dig3_i: Values to show on the 4 7-segment displays
        -- led_i: Input of LEDs
        -- sw_i: Input of switches
        -- pb_i: Input of push-buttons
        clk_i   : in std_logic;
        reset_i : in std_logic;
        dig0_i  : in std_logic_vector ( 7 downto 0);
        dig1_i  : in std_logic_vector ( 7 downto 0);
        dig2_i  : in std_logic_vector ( 7 downto 0);
        dig3_i  : in std_logic_vector ( 7 downto 0);
        led_i   : in std_logic_vector (15 downto 0);
        sw_i    : in std_logic_vector (15 downto 0);
        pb_i    : in std_logic_vector ( 3 downto 0);

        -- ss_o: 7-segment output (common anode)
        -- ss_sel_o: 7-segment display select (kathode)
        -- led_o: Output of LEDs
        -- swsync_o: Debounced switch ouputs
        -- pbsync_o: Debounced push-buttons outputs
        ss_o        : out std_logic_vector( 7 downto 0);
        ss_sel_o    : out std_logic_vector( 3 downto 0);
        led_o       : out std_logic_vector(15 downto 0);
        swsync_o    : out std_logic_vector(15 downto 0);
        pbsync_o    : out std_logic_vector( 3 downto 0)
    );

end io_ctrl;
