library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity adder32 is
    Port (  A : in std_logic_vector(31 downto 0);
            B : in std_logic_vector(31 downto 0);
            Cin : in std_logic;
            res : out std_logic_vector(31 downto 0);
            Cout : out std_logic);
end adder32;

architecture Behavioral of adder32 is
    signal c : std_logic_vector(9 downto 0);
    
    component Adder4b
        Port(   a, b : in std_logic_vector(3 downto 0);
                cin : in std_logic;
                res : out std_logic_vector(3 downto 0);
                cout : out std_logic);
    end component;
    
begin

    FA0: Adder4b port map(A(3 downto 0), B(3 downto 0), Cin, res(3 downto 0), c(1));
    FA1: Adder4b port map(A(7 downto 4), B(7 downto 4), c(1), res(7 downto 4), c(2));
    FA2: Adder4b port map(A(11 downto 8), B(11 downto 8), c(2), res(11 downto 8), c(3));
    FA3: Adder4b port map(A(15 downto 12), B(15 downto 12), c(3), res(15 downto 12), c(4));
    FA4: Adder4b port map(A(19 downto 16), B(19 downto 16), c(4), res(19 downto 16), c(5));
    FA5: Adder4b port map(A(23 downto 20), B(23 downto 20), c(5), res(23 downto 20), c(6));
    FA6: Adder4b port map(A(27 downto 24), B(27 downto 24), c(6), res(27 downto 24), c(7));
    FA7: Adder4b port map(A(31 downto 28), B(31 downto 28), c(7), res(31 downto 28), c(8));
    Cout <= c(8);
    
end Behavioral;
