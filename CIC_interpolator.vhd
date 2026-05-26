--! Project : CIC_interpolator    
--! <br>               
--! Author : Marco Corazzina                
--! <br>               
--! Date : 2026                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : CIC_interpolator.vhd  
--! <br>               
--! Implementation of a not size optimized parametric CIC_interpolator 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;



entity CIC_interpolator is
    generic(
        Bin : positive ;	-- Bit width of the input and output signals
		N : positive ;		-- Number of stages
		R : positive		-- Interpolation factor


        );
    port(
        clk_fast    : in  std_logic;
        rst    		: in  std_logic;
		en 	   		: in  std_logic;
		Cout   		: out std_logic_vector(N*2-1 downto 0);
        input  		: in  std_logic_vector(Bin-1 downto 0);
        output 		: out std_logic_vector(Bin-1 downto 0)
        );
end CIC_interpolator;

architecture Default of CIC_interpolator is

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

	component zero_insertion
		generic (WIDTH: integer; R: integer);
		port(
			clk : in std_logic;
			rst : in std_logic;
			en : in std_logic;
			input : in std_logic_vector(WIDTH-1 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0)
		);
	end component;


	signal clock_slow : std_logic;
	constant MAX_WIDTH : positive := Bin+(N-1)*positive(ceil(log2(real(R))));

	type signed_array is array (natural range <>) of std_logic_vector(MAX_WIDTH-1 downto 0);

	signal carry_over : signed_array(N*2 downto 0);
	signal se_output  : std_logic_vector(MAX_WIDTH-1 downto 0);
	
	
begin

	clock_div: clock_divider
		generic map (R => R)
		port map (
			rst => rst,
			clk => clk_fast,
			clock_out => clock_slow
		);

	first_se: sign_extender
		generic map (WIDTH_IN => Bin, WIDTH_OUT => MAX_WIDTH)
		port map (
			input => input,
			output => se_output
		);

	first_comb: comb
		generic map (WIDTH => MAX_WIDTH)
		port map (
			clk => clock_slow,
			rst => rst,
			en => en,
			Cout => Cout(0),
			input => se_output,
			output => carry_over(0)
		);
	
	gen_comb: for i in 1 to N-1 generate
		
		comb_inst: comb
			generic map (WIDTH => MAX_WIDTH)
			port map (
				clk => clock_slow,
				rst => rst,
				en => en,
				Cout => Cout(i),
				input => carry_over(i-1), 
				output => carry_over(i) 
			);
	end generate;

	interpolator : zero_insertion
		generic map (WIDTH => MAX_WIDTH, R => R)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			input => carry_over(N-1),
			output => carry_over(N) 
		);
	
	first_integrator: integrator
		generic map (WIDTH => MAX_WIDTH)
		port map (
			clk => clk_fast,
			rst => rst,
			en => en,
			Cout => Cout(N),
			input => carry_over(N),
			output => carry_over(N+1)
		);
	

	-- generate the remaining integrator stages using the formula present in the Hogenauer's paper for register growth
	gen_integrator: for i in 1 to N-1 generate

		integrator_inst: integrator
			generic map (WIDTH => MAX_WIDTH)
			port map (
				clk => clk_fast,
				rst => rst,
				en => en,
				Cout => Cout(N+i),
				input => carry_over(N+i),
				output => carry_over(N+i+1)
			);
	end generate;

	final_truncator: truncator
		generic map (WIDTH_IN => MAX_WIDTH, WIDTH_OUT => Bin)
		port map (
			input => carry_over(2*N),
			output => output
		);

end Default;