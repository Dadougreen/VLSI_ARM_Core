library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY testbench IS 
END ENTITY;

ARCHITECTURE BEV OF TESTBENCH IS

component Adder32 is 
port(   A : in  STD_LOGIC_VECTOR (31 downto 0); 
        B : in  STD_LOGIC_VECTOR (31 downto 0); 
        Cin : in  STD_LOGIC; 
        res : out  STD_LOGIC_VECTOR (31 downto 0); 
        cout : out std_logic);
end component;

signal sig_a : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000"; 
signal sig_b : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
signal sig_c : STD_LOGIC := '0';
signal res_out : STD_LOGIC_VECTOR (31 downto 0); 
signal sig_cout : STD_LOGIC;

BEGIN

Adder32_inst : component Adder32
    port map (A => sig_a,
              B => sig_b,
              Cin => sig_c,
              res => res_out,
              cout => sig_cout);

PROCESS
BEGIN
wait for 10 ns;
sig_b <= "00000000000000000000000000000001";
sig_c <= '1';
wait for 10 ns;
sig_b <= "10000000000000000000000000000000";
sig_c <= '0';
wait for 10 ns;
sig_a <= "00000000000000000000000000000001";
wait for 10 ns;
sig_a <= "11111111111111111111111111111111";
wait for 10 ns;
sig_b <= "11111111111111111111111111111111";
wait for 10 ns;
sig_b <= "00000000000000000000000000000000";

wait;
END PROCESS;

END ARCHITECTURE;