--! Project : Integrator    
--! <br>               
--! Author : Marco Corazzina                
--! <br>               
--! Date : 2026                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : integrator.vhd  
--! <br>               
--! Implementation of an integrator to be used inside a CIC filter. 
--! The integrator is a simple accumulator that sums the input signal over time. 


library ieee;
use ieee.std_logic_1164.all;

entity integrator is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
		Cin	: in  std_logic;
		Cout	: out std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end integrator;

architecture Structural of integrator is

	component reg_async_rst
    	generic (WIDTH: integer);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
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

	
	signal reg_input : std_logic_vector(WIDTH-1 downto 0);
	signal reg_output : std_logic_vector(WIDTH-1 downto 0);

	REGISTER: reg_async_rst
		generic map (WIDTH => WIDTH)
		port map (
			clk => clk,
			rst => rst,
			input => reg_input,
			output => reg_output
		);
	
	ADDER: adder
		generic map (WIDTH => WIDTH)
		port map (
			A => reg_output,
			B => input,
			Cin => Cin,
			Sum => reg_input,
			Cout => Cout
		);
	
	output <= reg_input;

end Structural;