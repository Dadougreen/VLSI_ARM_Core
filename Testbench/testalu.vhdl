library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY testbench2 IS 
END ENTITY;

ARCHITECTURE BEV OF TESTBENCH2 IS

component ALU is 
port (
    op1 : in Std_Logic_Vector(31 downto 0);
    op2 : in Std_Logic_Vector(31 downto 0);
    cin : in Std_Logic;

    cmd : in Std_Logic_Vector(1 downto 0);

    res : out Std_Logic_Vector(31 downto 0);
    cout : out Std_Logic;
    z : out Std_Logic; -- res = 0
    n : out Std_Logic; -- res < 0
    v : out Std_Logic; -- overflow

    vdd : in bit;
    vss : in bit
);
end component;

signal sig_op1 : STD_LOGIC_VECTOR (31 downto 0) := "00010000000000000000000000000000"; 
signal sig_op2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
signal sig_cin : STD_LOGIC := '0';
signal sig_cmd : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal res_out : STD_LOGIC_VECTOR (31 downto 0); 
signal sig_cout : STD_LOGIC;
signal sig_z : STD_LOGIC;
signal sig_n : STD_LOGIC;
signal sig_v : STD_LOGIC;

signal sig_vdd : bit := '1';
signal sig_vss : bit := '0';

BEGIN

Alu_inst : component ALU
    port map (sig_op1, sig_op2, sig_cin, sig_cmd, res_out, sig_cout, sig_z, sig_n, sig_v, sig_vdd, sig_vss);

PROCESS
BEGIN
wait for 10 ns;
sig_op1 <= "11111111111111111111111111111111";
wait for 10 ns;
sig_op2 <= "00000000000000000000000000000000";
wait for 10 ns;
sig_cmd <= "10";
wait for 10 ns;
sig_cmd <= "01";
wait for 10 ns;
sig_op2 <= "00010000000000000000000100000000";
sig_cmd <= "11";
wait for 10 ns;
sig_op1 <= "00000000000000000000000000000000";
wait for 10 ns;
sig_op1 <= "11111111111111111111111111111111";
wait for 10 ns;
sig_op1 <= "00000000000000000000000000000000";
wait;
END PROCESS;

END ARCHITECTURE;