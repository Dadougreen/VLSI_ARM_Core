library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_72b is 
    port(
		din			: in std_logic_vector(71 downto 0);
		dout			: out std_logic_vector(71 downto 0);

		-- commands
		push			: in std_logic;
		pop			: in std_logic;

		-- flags
		full			: out std_logic; 
		empty			: out std_logic; -- si on utilise pas la memoire

		reset_n		: in std_logic;
		ck				: in std_logic;
		vdd			: in bit;
		vss			: in bit);
end fifo_72b;

architecture behav of fifo_72b is
    
    signal temp_dout : std_logic_vector(71 downto 0) := (others => '0');
    signal mem_adr : std_logic_vector(31 downto 0) := din(31 downto 0);
    signal mem_data : std_logic_vector(31 downto 0) := din(63 downto 32);
    signal mem_dest : std_logic_vector(3 downto 0) := din(67 downto 64);
    signal mem_lw : std_logic := din(68);
    signal mem_lb : std_logic := din(69);
    signal mem_sw : std_logic := din(70);
    signal mem_sb : std_logic := din(71);
    begin
    process (ck, reset_n)
    begin
        if reset_n = '1' then
            temp_dout <= (others => '0');
        elsif rising_edge(ck) then
            
            if pop = '1' then
                temp_dout <= temp_dout(70 downto 0) & din(71);

            elsif push = '1' then
                temp_dout <= temp_dout(70 downto 0) & din(71);

            elsif mem_lw = '1' then
                temp_dout(31 downto 0) <= mem_adr;
                temp_dout(63 downto 32) <= mem_data;
                empty <= '1';

            elsif mem_lb = '1' then
                temp_dout(31 downto 0) <= mem_adr;
                temp_dout(63 downto 32) <= mem_data;
                empty <= '1';

            elsif mem_sw = '1' then
                temp_dout(31 downto 0) <= mem_adr;
                temp_dout(63 downto 32) <= mem_data;
                empty <= '1';

            elsif mem_sb = '1' then
                temp_dout(31 downto 0) <= mem_adr;
                temp_dout(63 downto 32) <= mem_data;
                empty <= '1';

            end if;
        end if;   
            

    end process;

    dout <= temp_dout;
    end architecture;