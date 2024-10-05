library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY testshifter is
END testshifter;

architecture Behavioral of testshifter is

    component Shifter IS port(
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
    end component;

    signal sig_shift_lsl : Std_Logic := '0';
    signal sig_shift_lsr : Std_Logic := '0';
    signal sig_shift_asr : Std_Logic := '0';
    signal sig_shift_ror : Std_Logic := '0';
    signal sig_shift_rrx : Std_Logic := '0';
    signal sig_shift_val : Std_Logic_Vector(4 downto 0) := "00000";

    signal sig_din : Std_Logic_Vector(31 downto 0);
    signal sig_cin : Std_Logic :='0';

    signal sig_dout : Std_Logic_Vector(31 downto 0);
    signal sig_cout : Std_Logic;

    signal sig_vdd : bit := '1';
    signal sig_vss : bit := '0';

    begin

    Shifter_inst : component Shifter
        port map(
            shift_lsl => sig_shift_lsl,
            shift_lsr => sig_shift_lsr,
            shift_asr => sig_shift_asr,
            shift_ror => sig_shift_ror,
            shift_rrx => sig_shift_rrx,
            shift_val => sig_shift_val,
            din => sig_din,
            cin => sig_cin,
            dout => sig_dout,
            cout => sig_cout,
            vdd => sig_vdd,
            vss => sig_vss
        );

    process
        begin
            -- LSL
            sig_shift_lsl <= '1';
            sig_din <= "00000000000000000000000000000001";
            sig_shift_val <= "00010";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000000011";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000001111";
            wait for 10 ns;
            sig_din <= "11110000000000000000000000000000";
            wait for 10 ns;
            sig_shift_lsl <= '0';

            -- LSR
            sig_shift_lsr <= '1';
            sig_din <= "00000000000000000000000000000001";
            sig_shift_val <= "00010";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000000011";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000001111";
            wait for 10 ns;
            sig_din <= "11110000000000000000000000000000";
            wait for 10 ns;
            sig_shift_lsr <= '0';

            -- ASR
            sig_shift_asr <= '1';
            sig_din <= "00000000000000000000000000000001";
            sig_shift_val <= "00010";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000000011";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000001111";
            wait for 10 ns;
            sig_din <= "11110000000000000000000000000000";
            wait for 10 ns;
            sig_shift_asr <= '0';

            -- ROR
            sig_shift_ror <= '1';
            sig_din <= "00000000000000000000000000000001";
            sig_shift_val <= "00010";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000000011";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000001111";
            wait for 10 ns;
            sig_din <= "11110000000000000000000000000000";
            wait for 10 ns;
            sig_shift_ror <= '0';

            -- RRX
            sig_shift_rrx <= '1';
            sig_din <= "00000000000000000000000000000001";
            sig_shift_val <= "00010";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000000011";
            wait for 10 ns;
            sig_din <= "00000000000000000000000000001111";
            wait for 10 ns;
            sig_din <= "11110000000000000000000000000000";
            wait for 10 ns;
            sig_shift_rrx <= '0';
            
            wait ;
        end process;

    end Behavioral;