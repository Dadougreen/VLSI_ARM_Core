library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Exec is
	port(
	-- Decode interface synchro
			dec2exe_empty	: in Std_logic;
			exe_pop			: out Std_logic;

	-- Decode interface operands
			dec_op1			: in Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: in Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: in Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: in Std_Logic; -- Rd destination write back
			dec_flag_wb		: in Std_Logic; -- CSPR modifiy

	-- Decode to mem interface 
			dec_mem_data	: in Std_Logic_Vector(31 downto 0); -- data to MEM W
			dec_mem_dest	: in Std_Logic_Vector(3 downto 0); -- Destination MEM R
			dec_pre_index 	: in Std_logic;

			dec_mem_lw		: in Std_Logic;
			dec_mem_lb		: in Std_Logic;
			dec_mem_sw		: in Std_Logic;
			dec_mem_sb		: in Std_Logic;

	-- Shifter command
			dec_shift_lsl	: in Std_Logic;
			dec_shift_lsr	: in Std_Logic;
			dec_shift_asr	: in Std_Logic;
			dec_shift_ror	: in Std_Logic;
			dec_shift_rrx	: in Std_Logic;
			dec_shift_val	: in Std_Logic_Vector(4 downto 0);
			dec_cy			: in Std_Logic;

	-- Alu operand selection
			dec_comp_op1	: in Std_Logic;
			dec_comp_op2	: in Std_Logic;
			dec_alu_cy 		: in Std_Logic;

	-- Alu command
			dec_alu_cmd		: in Std_Logic_Vector(1 downto 0);

	-- Exe bypass to decod
			exe_res			: out Std_Logic_Vector(31 downto 0);

			exe_c				: out Std_Logic;
			exe_v				: out Std_Logic;
			exe_n				: out Std_Logic;
			exe_z				: out Std_Logic;

			exe_dest			: out Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: out Std_Logic; -- Rd destination write back
			exe_flag_wb		: out Std_Logic; -- CSPR modifiy

	-- Mem interface
			exe_mem_adr		: out Std_Logic_Vector(31 downto 0); -- Alu res register
			exe_mem_data	: out Std_Logic_Vector(31 downto 0);
			exe_mem_dest	: out Std_Logic_Vector(3 downto 0);

			exe_mem_lw		: out Std_Logic;
			exe_mem_lb		: out Std_Logic;
			exe_mem_sw		: out Std_Logic;
			exe_mem_sb		: out Std_Logic;

			exe2mem_empty	: out Std_logic;
			mem_pop			: in Std_logic;

	-- global interface
			ck					: in Std_logic;
			reset_n			: in Std_logic;
			vdd				: in bit;
			vss				: in bit);
end Exec;

----------------------------------------------------------------------

architecture Behavior OF Exec is

component Shifter
	port(
		shift_lsl	: in Std_Logic;
		shift_lsr	: in Std_Logic;
		shift_asr	: in Std_Logic;
		shift_ror	: in Std_Logic;
		shift_rrx	: in Std_Logic;
		shift_val		: in Std_Logic_Vector(4 downto 0);

		din			: in Std_Logic_Vector(31 downto 0);
		cin			: in Std_Logic;

		dout			: out Std_Logic_Vector(31 downto 0);
		cout			: out Std_Logic;

		vdd			: in bit;
		vss			: in bit);
end component;

component Alu
	port (
		op1			: in Std_Logic_Vector(31 downto 0);
		op2			: in Std_Logic_Vector(31 downto 0);
		cin			: in Std_Logic;
		
		cmd			: in Std_Logic_Vector(1 downto 0);
		
		res			: out Std_Logic_Vector(31 downto 0);
		cout			: out Std_Logic;
		z				: out Std_Logic;
		n				: out Std_Logic;
		v				: out Std_Logic;
		
		vdd			: in bit;
		vss			: in bit);
end component;

component fifo_72b
	port(
		din			: in std_logic_vector(71 downto 0);
		dout			: out std_logic_vector(71 downto 0);

		-- commands
		push			: in std_logic;
		pop			: in std_logic;

		-- flags
		full			: out std_logic;
		empty			: out std_logic;

		reset_n		: in std_logic;
		ck				: in std_logic;
		vdd			: in bit;
		vss			: in bit);
end component;


signal shift_c 	: std_logic;
signal alu_c 		: std_logic;
signal alu_z	    : std_logic;
signal alu_n  		: std_logic;
signal alu_v		: std_logic;
signal op2			: std_logic_vector(31 downto 0) :="00000000000000000000000000000000";

signal op2_shift	: std_logic_vector(31 downto 0) ;
signal op1			: std_logic_vector(31 downto 0) :="00000000000000000000000000000000";


signal alu_res		: std_logic_vector(31 downto 0);
signal res_reg		: std_logic_vector(31 downto 0);
signal mem_adr		: std_logic_vector(31 downto 0);

signal exe_push 	: std_logic;
signal exe2mem_full	: std_logic;
signal mem_acces	: std_logic;

begin


--  Component instantiation.
	shifter_inst : Shifter
	port map (		shift_lsl	=> dec_shift_lsl,
					shift_lsr	=> dec_shift_lsr,
					shift_asr	=> dec_shift_asr,
               		shift_ror	=> dec_shift_ror,
					shift_rrx	=> dec_shift_rrx,
               		shift_val		=> dec_shift_val,

					din			=> dec_op2,
					cin			=> dec_cy,

					dout			=> op2_shift,
               		cout			=> shift_c,
					vdd			=> vdd,
					vss			=> vss);

	alu_inst : Alu
	port map (		op1		 => op1,
					op2		 => op2,
					cin		 => dec_alu_cy,

					cmd		 => dec_alu_cmd,

					res		 => alu_res,
					cout		 => alu_c,
					z			 => alu_z,
					n			 => alu_n,
					v			 => alu_v,

					vdd		 => vdd,
					vss		 => vss);

	exec2mem : fifo_72b
	port map (	din(71)	 => dec_mem_lw,
					din(70)	 => dec_mem_lb,
					din(69)	 => dec_mem_sw,
					din(68)	 => dec_mem_sb,

					din(67 downto 64) => dec_mem_dest,
					din(63 downto 32) => dec_mem_data,
					din(31 downto 0)	 => mem_adr,

					dout(71)	 => exe_mem_lw,
					dout(70)	 => exe_mem_lb,
					dout(69)	 => exe_mem_sw,
					dout(68)	 => exe_mem_sb,

					dout(67 downto 64) => exe_mem_dest,
					dout(63 downto 32) => exe_mem_data,
					dout(31 downto 0)	 => exe_mem_adr,

					push		 => exe_push,
					pop		 => mem_pop,

					empty		 => exe2mem_empty,
					full		 => exe2mem_full,

					reset_n	 => reset_n,
					ck			 => ck,
					vdd		 => vdd,
					vss		 => vss);

-- synchro

mem_adr <= alu_res when dec_pre_index = '1' else op1;
exe_dest <= dec_exe_dest;
-- cout
exe_c	<= alu_c when dec_alu_cmd = "00" else shift_c;


-- ALU opearandes

op1 <= not(dec_op1) when dec_comp_op1 = '1' else dec_op1;
op2 <= not(op2_shift) when dec_comp_op2 = '1' else op2_shift;


--wb
exe_res <= alu_res when dec_exe_wb ='1' else
	(others =>'0');

exe_flag_wb <='1' when dec_flag_wb ='1' else	
	'0';

exe_wb <= '1' when dec_exe_wb ='1' else
	'0';

exe_v	<= alu_v when dec_exe_wb ='1' else	
	'0';

exe_n	<=alu_n when dec_exe_wb ='1' else	
	'0';	

exe_z	 <= alu_z when dec_exe_wb ='1' else	
	'0';			

exe_pop   <= (not dec2exe_empty) and ((dec_mem_sb or dec_mem_lw or dec_mem_lb or dec_mem_sw) or (not exe2mem_full));
exe_push <= ((dec_mem_sb or dec_mem_lw or dec_mem_lb or dec_mem_sw) and not (dec2exe_empty)) and not exe2mem_full;
	

end Behavior;
