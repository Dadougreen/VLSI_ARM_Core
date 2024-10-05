
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder4b is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           res : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end Adder4b;

architecture adder of Adder4b is
    signal c : STD_LOGIC_VECTOR (4 downto 0);  -- Carry intermédiaire

    component full_adder
        Port ( a, b, cin : in  STD_LOGIC;
               res, cout : out STD_LOGIC);
    end component;
begin
    FA0: full_adder port map(A(0), B(0), Cin, res(0), c(1));
    FA1: full_adder port map(A(1), B(1), c(1), res(1), c(2));
    FA2: full_adder port map(A(2), B(2), c(2), res(2), c(3));
    FA3: full_adder port map(A(3), B(3), c(3), res(3), c(4));
    
    Cout <= c(4);


end adder;

