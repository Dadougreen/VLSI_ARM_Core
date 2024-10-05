library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testreg is
end entity testreg;

architecture sim of testreg is
    signal ck, reset_n : std_logic;
    signal wdata1, wdata2 : std_logic_vector(31 downto 0);
    signal wen1, wen2, wcry, wzero, wneg, wovr, cspr_wb, inval_czn, inval_ovr, inc_pc, inval1, inval2 : std_logic;
    signal inval_adr1, inval_adr2, wadr1, wadr2, radr1, radr2, radr3 : std_logic_vector(3 downto 0);
    signal reg_rd1, reg_rd2, reg_rd3, reg_pc : std_logic_vector(31 downto 0);
    signal reg_v1, reg_v2, reg_v3, reg_cry, reg_zero, reg_neg, reg_cznv, reg_ovr, reg_vv, reg_pcv : std_logic;
    signal mem_pop : std_logic;
    signal vdd, vss : bit;
    constant CLK_PERIOD   : time := 1 ns;
begin

    -- Instanciation du composant Reg
    uut: entity work.Reg
        port map (
            wdata1 => wdata1,
            wadr1 => wadr1,
            wen1 => wen1,
            wdata2 => wdata2,
            wadr2 => wadr2,
            wen2 => wen2,
            wcry => wcry,
            wzero => wzero,
            wneg => wneg,
            wovr => wovr,
            cspr_wb => cspr_wb,
            reg_rd1 => reg_rd1,
            radr1 => radr1,
            reg_v1 => reg_v1,
            reg_rd2 => reg_rd2,
            radr2 => radr2,
            reg_v2 => reg_v2,
            reg_rd3 => reg_rd3,
            radr3 => radr3, 
            reg_v3 => reg_v3,
            reg_cry => reg_cry,
            reg_zero => reg_zero,
            reg_neg => reg_neg,
            reg_cznv => reg_cznv,
            reg_ovr => reg_ovr,
            reg_vv => reg_vv,
            inval_adr1 => inval_adr1,
            inval1 => inval1,
            inval_adr2 => inval_adr2,
            inval2 => inval2,
            inval_czn => inval_czn,
            inval_ovr => inval_ovr,
            reg_pc => reg_pc,
            reg_pcv => reg_pcv,
            inc_pc => inc_pc,
            ck => ck,
            reset_n => reset_n,
            vdd => vdd,
            vss => vss
        );

    -- Processus de génération de l'horloge
    process
    begin
      while now < 1000 ns loop
        ck <= '0';
        wait for CLK_PERIOD / 2;
        ck <= '1';
        wait for CLK_PERIOD / 2;
      end loop;
      wait;
    end process;

    -- Processus de génération du reset
    process
    begin
        reset_n <= '0';
        wait for 10 ns;  -- Temps de reset arbitraire
        reset_n <= '1' after 5 ns;
        wait;
    end process;

    -- Processus de génération des signaux de test
    process
    begin
        radr1 <=x"0";
        radr2 <=x"1";
        radr3 <="1111";
        vdd <= '1';
        vss <= '0';
        wdata1 <= "10000000000000000000000000000000";
        wadr1 <= "0000";
        wen1 <= '1';
        wdata2 <= "10000000000000000000000000000001";
        wadr2 <= "0001";
        wen2 <= '1';
        wcry <= '1';
        wzero <= '0';
        wneg <= '1';
        wovr <= '0';
        cspr_wb <= '1';
        inval_adr1 <= "0000";
        inval1 <= '1';
        inval_adr2 <= "0001";
        inval2 <= '1';
        inval_czn <= '1';
        inval_ovr <= '1';
        inc_pc <= '1';
        mem_pop <= '0';  -- Peut être ajusté pour tester le port mem_pop
        
        wait;
    end process;

end architecture sim;