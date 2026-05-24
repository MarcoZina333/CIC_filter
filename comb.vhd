--! Project : comb    
--! <br>               
--! Author : Marco Corazzina                
--! <br>               
--! Date : 2026                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : comb.vhd  
--! <br>               
--! Implementation of an comb to be used inside a CIC filter. 
--! The comb is a simple accumulator that sums the input signal over time. 


library ieee;
use ieee.std_logic_1164.all;

entity comb is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
		en 	   : in  std_logic;
		Cout   : out std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end comb;

architecture Default of comb is

	component reg_en_async_rst
    	generic (WIDTH: integer);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			en     : in  std_logic;
			input  : in  std_logic_vector(WIDTH-1 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0)
		);
  	end component;
  
  	component adder
    	generic (WIDTH: integer);
		port( 
			A     : in  std_logic_vector(WIDTH-1 downto 0);      -- First input
        	B     : in  std_logic_vector(WIDTH-1 downto 0);      -- Second input
        	Cin   : in  std_logic;                               -- Carry input
        	Sum   : out std_logic_vector(WIDTH-1 downto 0);      -- Sum output
        	Cout  : out std_logic   
		);
	end component;

	
	signal temp_output : std_logic_vector(WIDTH-1 downto 0);
	
	signal sum_input : std_logic_vector(WIDTH-1 downto 0);
	signal reg_output : std_logic_vector(WIDTH-1 downto 0);
	
begin

	reg: reg_en_async_rst
		generic map (WIDTH => WIDTH)
		port map (
			clk => clk,
			rst => rst,
			en => en,
			input => input,
			output => reg_output
		);
	
	sum_input <= not reg_output;
	
	add: adder
		generic map (WIDTH => WIDTH)
		port map (
			A => sum_input,
			B => input,
			Cin => '1',			--The carry is used to make the 2 complement of reg_output to obtain subtraction
			Sum => temp_output,
			Cout => Cout 		-- If WIDTH is choosen incorrectly, Cout can be used to detect such an error (Cout = 0)
		);
	
	process(rst, en, temp_output)
	begin
		if rst = '0' then
			output <= (others => '0');
		else
			if en = '1' then
				output <= temp_output;
			end if;
		end if;
	end process;

end Default;