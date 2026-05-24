--! Project : Carry Look-Ahead Adder    
--! <br>               
--! Author : Emiliano Sisinni                   
--! <br>               
--! Date : AY2024/2025                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : testbench.vhd  

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS


constant WIDTH  : positive := 4;

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT integrator
    GENERIC(
        WIDTH : positive
        );
    PORT(
        clk     : IN std_logic;
        rst     : IN std_logic;
        en      : IN std_logic;
        input   : IN std_logic_vector(WIDTH-1 downto 0);
        output  : OUT std_logic_vector(WIDTH-1 downto 0);
        Cout    : OUT std_logic
    );
END COMPONENT;


--Inputs
signal input    : std_logic_vector(WIDTH-1 downto 0) := (others => '0');


signal clk_en   : std_logic := '1';

signal en       : std_logic := '1';
signal clk      : std_logic := '0';
signal rst      : std_logic := '0';

--Outputs
signal output   : std_logic_vector(WIDTH-1 downto 0);
signal Cout     : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: integrator
generic map (WIDTH => WIDTH)
port map (
    clk => clk,
    rst => rst,
    input => input,
    output => output,
    Cout => Cout,
    en => en
);
  -- 50 MHz clock generation
  clk <= not clk and clk_en after 10 ns;

-- Stimulus process
stim_proc: process
begin
  rst   <= '0';
  en    <= '1';
  input <= (others => '0');
  
  wait for 10 ns;
  rst   <= '1';

  input <= "0001";

  wait for 5 ns;
  rst   <= '0';

  wait for 5 ns;
  rst   <= '1';

  wait for 10 ns;
  input <= "0010";

  wait for 20 ns;
  input <= "1001";

  wait for 20 ns;
  input <= "0000";

  wait for 20 ns;
  input <= "1010";
  wait;

end process;

END;
