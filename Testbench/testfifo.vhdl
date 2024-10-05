library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;

ENTITY testfifo IS 
END ENTITY;

ARCHITECTURE BEV OF TESTFIFO IS

Component fifo_72b is
    port(
        
        din : in std_logic_vector(71 downto 0);
        dout : out std_logic_vector(71 downto 0);

        push: in std_logic;
        pop : in std_logic;
      
        
        full : out std_logic;
        empty : out std_logic;

        ck : in std_logic;
        reset_n : in std_logic;
        vdd : in bit;
        vss : in bit
    );
END COMPONENT;

signal din : std_logic_vector(71 downto 0) := ("111100000000000000000000000000000000000000000000000000000000000000000000");
signal dout : std_logic_vector(71 downto 0);

signal push : std_logic :='1';
signal pop : std_logic :='0';

signal full : std_logic := '0';
signal empty : std_logic := '0';

signal ck : std_logic :='0';
signal reset_n : std_logic := '0';

signal vdd : bit := '1';
signal vss : bit:= '0';

begin

fifo_inst : component fifo_72b
port map(
    din => din,
    dout => dout,
    push => push,
    pop => pop,
    full => full,
    empty => empty,
    ck => ck,
    reset_n => reset_n,
    vdd => vdd,
    vss => vss
);

process
begin
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;
    wait for  5 ns;
    ck <= not ck;

    wait;
end process;

end architecture;