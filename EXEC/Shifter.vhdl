library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shifter is
    port(
    shift_lsl : in Std_Logic;
    shift_lsr : in Std_Logic;
    shift_asr : in Std_Logic;
    shift_ror : in Std_Logic;
    shift_rrx : in Std_Logic;
    shift_val : in Std_Logic_Vector(4 downto 0);

    din : in Std_Logic_Vector(31 downto 0);
    cin : in Std_Logic;

    dout : out Std_Logic_Vector(31 downto 0);
    cout : out Std_Logic;

    -- global interface
    vdd : in bit;
    vss : in bit);
end Shifter;

architecture archi_shifter of Shifter is
    --signal sig_din : Std_Logic_Vector(31 downto 0);
    --signal sig_cin : Std_Logic;
    --signal sig_shift_val : Std_Logic_Vector(4 downto 0);

    signal sig_dout : Std_Logic_Vector(31 downto 0);
    signal sig_cout : Std_Logic;

    begin
        process (shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, shift_val, din, cin)
        variable temp : Std_Logic_Vector(32 downto 0); -- 33 bits pour la carry
        variable ub : Std_Logic;
        begin
            temp := '0' & din;
            if shift_lsl = '1' then
                for i in 0 to shift_val'length loop
                    temp := din & '0'; -- concaténation 0 à la fin du vect
                    sig_cout <= temp(32); -- récupération de la carry (CF)
                    sig_dout <= temp(31 downto 0); -- on met les 32 autres bits dans sig_dout
                end loop;

                -- if sig_shift_val > "00000" then
                --     sig_din <= sig_din & '0';
                --     sig_shift_val <= std_logic_vector(unsigned(sig_shift_val) - 1);
                -- end if;

                -- shift left logical of shift_val bits
                -- for i in unsigned(0) to unsigned(shift_val) loop
                --     sig_din <= sig_din & '0';
                -- end loop;
                
            elsif shift_lsr = '1' then
                for i in 0 to shift_val'length loop
                    temp := '0' & din; -- concaténation 0 à la fin du vect
                    sig_cout <= temp(0); -- récupération de la carry (CF)
                    sig_dout <= temp(32 downto 1); -- on met les 32 autres bits dans sig_dout
                end loop;

            elsif shift_asr = '1' then
                ub := din(31); -- récupération du bit de poids fort
                for i in 0 to shift_val'length loop
                    temp := ub & din; -- concaténation ub au début du vect
                    temp(32) := ub; -- on copie le bit de poids fort initial
                    sig_cout <= temp(0); -- récupération de la carry (CF)
                    sig_dout <= temp(32 downto 1); -- on met les 32 autres bits dans sig_dout
                end loop;

            elsif shift_ror = '1' then
                for i in 0 to shift_val'length loop
                    temp := sig_cout & din;
                    sig_cout <= temp(0); -- récupération de la carry (CF)
                    sig_dout <= temp(32 downto 1);
                end loop;

            elsif shift_rrx = '1' then
                temp := sig_cout & din;
                sig_cout <= temp(0); -- récupération de la carry (CF)
                sig_dout <= temp(32 downto 1);

            end if;

        end process;
        dout <= sig_dout;
        cout <= sig_cout;
            

    end archi_shifter;