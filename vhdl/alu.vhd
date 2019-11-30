--------------------------------------------------------------------------------
-- Author:      Christoph Amon
--
-- Created:     30.11.2019
--
-- Unit:        ALU Unit (Entity)
--
-- Version:
--      -) Version 1.0.0
--
-- Changelog:
--      -) Version 1.0.0 (30.11.2019)
--         First implementation of ALU entity.
--
-- Description:
--      The ALU can perform different kind of operations such as add, square
--      root, NOT and XOR. There are two inputs for the operands and one
--      for the type of operation.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity alu is

    port (
        ------------------------------------------------------------------------
        -- INPUTS
        -- clk_i: 100MHz system clock signal
        -- reset_i: System reset line
        -- op1_i: 12 bit operand 1 value
        -- op2_i: 12 bit operand 2 value
        -- optype_i: Defines type of operation
        -- start_i: Start flag for operation
        ------------------------------------------------------------------------
        clk_i       : in std_logic;
        reset_i     : in std_logic;
        op1_i       : in std_logic_vector (11 downto 0);
        op2_i       : in std_logic_vector (11 downto 0);
        optype_i    : in std_logic_vector ( 3 downto 0);
        start_i     : in std_logic;

        ------------------------------------------------------------------------
        -- OUTPUTS
        -- finished_o: Flag when operation is finished
        -- result_o: Result of operation
        -- sign_o: '1' if ouput is negative
        -- overflow_o: '1' if overflow occured
        -- error_o: '1' if an error occured
        ------------------------------------------------------------------------
        finished_o  : out std_logic;
        result_o    : out std_logic_vector (15 downto 0);
        sign_o      : out std_logic;
        overflow_o  : out std_logic;
        error_o     : out std_logic
    );

end alu;
