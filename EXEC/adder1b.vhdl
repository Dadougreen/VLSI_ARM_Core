library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( a, b, cin : in  STD_LOGIC;
           res, cout : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is
begin
    res <= a xor b xor cin;
    cout <= (a and b) or (cin and (a xor b));
end Behavioral;