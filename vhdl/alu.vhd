library ieee;
use ieee.std_logic_1164.all;

entity alu is

    port (
        clk_i       : in std_logic;
        reset_i     : in std_logic;
        op1_i       : in std_logic_vector (11 downto 0);
        op2_i       : in std_logic_vector (11 downto 0);
        optype_i    : in std_logic_vector ( 3 downto 0);
        start_i     : in std_logic;

        finished_o  : out std_logic;
        result_o    : out std_logic_vector (15 downto 0);
        sign_o      : out std_logic;
        overflow_o  : out std_logic;
        error_o     : out std_logic
    );

end alu;
