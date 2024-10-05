library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decod_tb is
end Decod_tb;

architecture testbench of Decod_tb is
    -- Constantes
    constant CLK_PERIOD : time := 10 ns;

    -- Signaux
    signal clk, reset_n : std_logic := '0';
    signal vdd, vss : bit := '1';

    -- Signaux d'entrée
    signal exe_res : std_logic_vector(31 downto 0);
    signal exe_dest : std_logic_vector(3 downto 0);
    signal exe_wb, exe_c, exe_v, exe_n, exe_z, exe_flag_wb : std_logic;

    -- Signaux de sortie
    signal dec_pc : std_logic_vector(31 downto 0);
    signal if_ir : std_logic_vector(31 downto 0);

    -- Initialisation des composants
    component Decod
        port(
            -- Les ports de votre entité Decod
        );
    end component;

    -- Génération des impulsions d'horloge
    procedure clock_generator(
        signal clk : out std_logic;
        constant period : time
    ) is
    begin
        clk <= '0', '1' after period / 2 when now mod period < period / 2;
    end procedure;

    -- Processus de test
    begin
        -- Instanciation du composant Decod
        UUT : Decod
        port map(
            -- Connectez les ports de votre entité Decod ici
        );

        -- Processus de simulation
        simulation: process
        begin
            -- Initialisation
            reset_n <= '0';
            wait for 10 ns;
            reset_n <= '1';

            -- Exemple d'instructions d'addition (peut être ajusté selon votre instruction d'addition)
            if_ir <= "00010001000000000000000000000010"; -- ADD R1, R2, R3

            -- Génération d'impulsions d'horloge
            clock_generator(clk, CLK_PERIOD);

            -- Attendre quelques cycles d'horloge
            wait for 20 ns;

            -- Charger le résultat de l'addition dans exe_res (peut être ajusté selon votre architecture)
            exe_res <= (others => '0');
            exe_res(31 downto 0) <= std_logic_vector(unsigned(exe_res(31 downto 0)) + unsigned("00000001000000100000000000000000"));

            -- Affichage du résultat
            report "Résultat de l'addition : " & integer'image(to_integer(unsigned(exe_res)));

            -- Attendre la fin de la simulation
            wait for 10 ns;
            report "Simulation terminée";

            wait;
        end process simulation;

    end testbench;
