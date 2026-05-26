--! Project : CIC_interpolator    
--! <br>               
--! Author : Marco Corazzina                
--! <br>               
--! Date : 2026                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : CIC_decimator_inst.vhd  
--! <br>               
--! Implementation of a not size optimized parametric CIC_decimator 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;



entity CIC_decimator_inst is
    generic(
        Bin : positive 	;	-- Bit width of the input and output signals
		N : positive 	;	-- Number of stages
		R : positive 		-- Interpolation factor


        );
    port(
        clk_fast    : in  std_logic;
        rst    : in  std_logic;
		en 	   : in  std_logic;
		Cout   : out std_logic_vector(N*2-1 downto 0);
        input  : in  std_logic_vector(Bin-1 downto 0);
        output : out std_logic_vector(Bin-1 downto 0)
        );
end CIC_decimator_inst;

architecture Default of CIC_decimator_inst is

	component comb
		generic (WIDTH: integer);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			en     : in  std_logic;
			Cout   : out std_logic;
			input  : in  std_logic_vector(WIDTH-1 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0)
		);
  	end component;

	component integrator
		generic (WIDTH: integer);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			en     : in  std_logic;
			Cout   : out std_logic;
			input  : in  std_logic_vector(WIDTH-1 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0)
		);
  	end component;

	component sign_extender
		generic (
			WIDTH_IN : positive;
			WIDTH_OUT : positive
			);
		port(
			input  : in  std_logic_vector(WIDTH_IN-1 downto 0);
			output : out std_logic_vector(WIDTH_OUT-1 downto 0)
		);
  	end component;

	component truncator
		generic (
			WIDTH_IN : positive;
			WIDTH_OUT : positive);
		port(
			input  : in  std_logic_vector(WIDTH_IN-1 downto 0);
			output : out std_logic_vector(WIDTH_OUT-1 downto 0)
		);
  	end component;

	component clock_divider
		generic (R: integer);
		port(
			rst : in std_logic;
			clk : in std_logic;
			clock_out : out std_logic
		);
	end component;

	component reg_async_rst is
		generic(
			WIDTH : positive
			);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			input  : in  std_logic_vector(WIDTH-1 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0)
        	);
	end component reg_async_rst;


	constant W1 : positive := 30;
	constant W2 : positive := 26;
	constant W3 : positive := 24;
	constant W4 : positive := 22;
	constant W5 : positive := 21;
	constant W6 : positive := 20;
	constant W7 : positive := 19;
	constant W8 : positive := 18;

	signal clock_slow : std_logic;

	signal se_output : std_logic_vector(W1-1 downto 0);
	signal carry_over1 : std_logic_vector(W1-1 downto 0);

	signal trunc_output2 : std_logic_vector(W2-1 downto 0);
	signal carry_over2 : std_logic_vector(W2-1 downto 0);

	signal trunc_output3 : std_logic_vector(W3-1 downto 0);
	signal carry_over3 : std_logic_vector(W3-1 downto 0);
	
	signal trunc_output4 : std_logic_vector(W4-1 downto 0);
	signal carry_over4 : std_logic_vector(W4-1 downto 0);
	
	signal decimator_output : std_logic_vector(W4-1 downto 0);

	signal trunc_output5 : std_logic_vector(W5-1 downto 0);
	signal carry_over5 : std_logic_vector(W5-1 downto 0);

	
	signal trunc_output6 : std_logic_vector(W6-1 downto 0);
	signal carry_over6 : std_logic_vector(W6-1 downto 0);

	
	signal trunc_output7 : std_logic_vector(W7-1 downto 0);
	signal carry_over7 : std_logic_vector(W7-1 downto 0);

	
	signal trunc_output8 : std_logic_vector(W8-1 downto 0);
	signal carry_over8 : std_logic_vector(W8-1 downto 0);
	
	
begin

	clock_div: clock_divider
		generic map (R => R)
		port map (
			rst => rst,
			clk => clk_fast,
			clock_out => clock_slow
		);



	se: sign_extender
		generic map (WIDTH_IN => Bin, WIDTH_OUT => W1)
		port map (
			input => input,
			output => se_output
		);

	integrator1: integrator
		generic map (WIDTH => W1)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			Cout => Cout(0),
			input => se_output,
			output => carry_over1
		);

	trunc2: truncator
		generic map (WIDTH_IN => W1, WIDTH_OUT => W2)
		port map (
			input => carry_over1,
			output => trunc_output2
		);

	integrator2: integrator
		generic map (WIDTH => W2)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			Cout => Cout(1),
			input => trunc_output2,
			output => carry_over2
		);
	
	trunc3: truncator
		generic map (WIDTH_IN => W2, WIDTH_OUT => W3)
		port map (
			input => carry_over2,
			output => trunc_output3
		);

	integrator3: integrator
		generic map (WIDTH => W3)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			Cout => Cout(2),
			input => trunc_output3,
			output => carry_over3
		);

	trunc4: truncator
		generic map (WIDTH_IN => W3, WIDTH_OUT => W4)
		port map (
			input => carry_over3,
			output => trunc_output4
		);

	integrator4: integrator
		generic map (WIDTH => W4)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			Cout => Cout(3),
			input => trunc_output4,
			output => carry_over4
		);
	

	decimator : reg_async_rst
		generic map (WIDTH => W4)
		port map (
			clk => clock_slow,
			rst => rst,
			input => carry_over4,
			output => decimator_output
		);

	trunc5: truncator
		generic map (WIDTH_IN => W4, WIDTH_OUT => W5)
		port map (
			input => decimator_output,
			output => trunc_output5
		);

	comb1: comb
		generic map (WIDTH => W5)
		port map (
			clk => clock_slow,
			rst => rst,
			en => en,
			Cout => Cout(4),
			input => trunc_output5,
			output => carry_over5
		);
		
	trunc6: truncator
		generic map (WIDTH_IN => W5, WIDTH_OUT => W6)
		port map (
			input => carry_over5,
			output => trunc_output6
		);
	
	comb2: comb
		generic map (WIDTH => W6)
		port map (
			clk => clock_slow,
			rst => rst,
			en => en,
			Cout => Cout(5),
			input => trunc_output6,
			output => carry_over6
		);
	
	trunc7: truncator
		generic map (WIDTH_IN => W6, WIDTH_OUT => W7)
		port map (
			input => carry_over6,
			output => trunc_output7
		);
	
	comb3: comb
		generic map (WIDTH => W7)
		port map (
			clk => clock_slow,
			rst => rst,
			en => en,
			Cout => Cout(6),
			input => trunc_output7,
			output => carry_over7
		);

	trunc8: truncator
		generic map (WIDTH_IN => W7, WIDTH_OUT => W8)
		port map (
			input => carry_over7,
			output => trunc_output8
		);
	
	comb4: comb
		generic map (WIDTH => W8)
		port map (
			clk => clock_slow,
			rst => rst,
			en => en,
			Cout => Cout(7),
			input => trunc_output8,
			output => carry_over8
		);	

	final_truncator: truncator
		generic map (WIDTH_IN => W8, WIDTH_OUT => Bin)
		port map (
			input => carry_over8,
			output => output
		);

end Default;