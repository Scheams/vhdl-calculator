--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     29.11.2019
--
-- Unit:        Calculator Control Unit (Entity)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (29.11.2019)
--         First implementation of Calculator Control entity.
--
-- Description:
--      The Calculator Control Unit is the brain of the calculator project.
--      It connects the IO with the ALU and decides what to do at which state.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity calc_ctrl is

    port (
        ------------------------------------------------------------------------
        -- INPUTS
        -- clk_i: This is the system clock
        -- reset_i: This is the system reset
        -- swsync_i: Debounced inputs of the switches
        -- pbsync_i: Debounced inputs of the push-buttons
        -- finished_i: Operation finished flag of the ALU
        -- result_i: Calculated result of the ALU
        -- sign_i: Result is negative ('1') or positive ('0')
        -- overflow_i: Flag if an overflow occured
        -- error_i: Flag if an error occured
        ------------------------------------------------------------------------
        clk_i       : in std_logic;
        reset_i     : in std_logic;
        swsync_i    : in std_logic_vector (15 downto 0);
        pbsync_i    : in std_logic_vector ( 3 downto 0);
        finished_i  : in std_logic;
        result_i    : in std_logic_vector (15 downto 0);
        sign_i      : in std_logic;
        overflow_i  : in std_logic;
        error_i     : in std_logic;

        ------------------------------------------------------------------------
        -- OUTPUTS
        -- op1_o: 12 bit value of operand 1
        -- op2_o: 12 bit value of operand 2
        -- optype_o: Type of operation (ADD, SQR, NOT, XOR)
        -- start_o: Start ALU operation
        -- dig0_o: Output of digit 0
        -- dig1_o: Output of digit 1
        -- dig2_o: Output of digit 2
        -- dig3_o: Output of digit 3
        -- led_o: Output of LEDs
        ------------------------------------------------------------------------
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
