library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
	port(
	-- Write Port 1 prioritaire
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1			: in Std_Logic_Vector(3 downto 0);
		wen1			: in Std_Logic;

	-- Write Port 2 non prioritaire
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2			: in Std_Logic_Vector(3 downto 0);
		wen2			: in Std_Logic;

	-- Write CSPR Port
		wcry			: in Std_Logic;
		wzero			: in Std_Logic;
		wneg			: in Std_Logic;
		wovr			: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv		: out Std_Logic;
		reg_ovr		: out Std_Logic;
		reg_vv		: out Std_Logic;
		
	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck				: in Std_Logic;
		reset_n		: in Std_Logic;
		vdd			: in bit;
		vss			: in bit);
end Reg;


architecture Behavior OF Reg is
    
    type banc is array (0 to 15) of std_logic_vector(31 downto 0);
    type bancV is array (0 to 15) of std_logic;
    signal RegisterFile : banc;
    signal register_valid : bancV;
    signal FlagC_int, ValidFlagC_int, FlagZ_int, ValidFlagZ_int,
           FlagN_int, ValidFlagN_int, FlagV_int, ValidFlagV_int : STD_LOGIC;

begin
   
    process(ck, reset_n)
    begin
        if (reset_n = '0') then
           
            RegisterFile <= (others => (others => '0'));
            register_valid <= (others => '1');  -- Tous les registres valides au reset
            FlagC_int <= '0';
			FlagN_int <= '0';
			FlagZ_int <= '0';
			FlagV_int <= '0';
            ValidFlagC_int <= '1';
			ValidFlagN_int <= '1';
			ValidFlagZ_int <= '1';
			ValidFlagV_int <= '1';
            
        elsif (rising_edge(ck)) then
            -- Gestion de l'écriture dans le registre 1 (prioritaire)
            if (wen1 = '1') then
				if (register_valid(to_integer(unsigned(wadr1))) = '1') then
					RegisterFile(to_integer(unsigned(wadr1))) <= wdata1;
					register_valid(to_integer(unsigned(wadr1))) <= '0';
				end if;
            end if;

            -- Gestion de l'écriture dans le registre 2 (non prioritaire)
            if (wen2 = '1' and wadr1 /= wadr2) then
				if (register_valid(to_integer(unsigned(wadr2))) = '1') then
                	RegisterFile(to_integer(unsigned(wadr2))) <= wdata2;
                	register_valid(to_integer(unsigned(wadr2))) <= '0';
				end if;
            end if;

            -- Gestion de l'écriture dans les flags CSPR
            if (cspr_wb = '1') then
                FlagC_int <= wcry;
                --ValidFlagC_int <= '0';
				FlagN_int <= wneg;
				--ValidFlagN_int <= '0';
				FlagZ_int <= wzero;
				--ValidFlagN_int <= '0';
				FlagV_int <= wovr;
				--ValidFlagN_int <= '0';
 
            end if;

            -- lecture des ports d'invalidations
            if (inval1 = '1') then
				register_valid(to_integer(unsigned(inval_adr1))) <= '0';
			elsif(inval2 = '1') then
				register_valid(to_integer(unsigned(inval_adr2))) <= '0';
			elsif(inval_czn = '1') then
				ValidFlagC_int <= '0';
				ValidFlagN_int <= '0';
				ValidFlagZ_int <= '0';
			elsif(inval_ovr ='1') then
				ValidFlagN_int <= '0';
			end if;

			-- ports de lecture des registres
			
			reg_rd1 <= RegisterFile(to_integer(unsigned(radr1)));
			reg_v1 <= register_valid(to_integer(unsigned(radr1)));
		
			reg_rd2 <= RegisterFile(to_integer(unsigned(radr2)));
			reg_v2 <= register_valid(to_integer(unsigned(radr2)));
		
			reg_rd3 <= RegisterFile(to_integer(unsigned(radr3)));
			reg_v3 <= register_valid(to_integer(unsigned(radr3)));
		

			-- Port de lecture CSPR

			reg_cry <= FlagC_int;
			reg_neg <= FlagN_int;
			reg_zero <= FlagZ_int;
			if( ValidFlagN_int ='1' or ValidFlagC_int ='1' or ValidFlagZ_int ='1' ) then 
				reg_cznv <='1';
			end if;
			reg_ovr <= FlagV_int;
			reg_vv <= ValidFlagV_int;

			
			-- gestion du PC
            if (inc_pc = '1') then
                RegisterFile(15) <= std_logic_vector(unsigned(RegisterFile(15)) + 4);
            end if;

            reg_pc <= RegisterFile(15);
			reg_pcv <= register_valid(15);

        end if;
    end process;
end Behavior;
