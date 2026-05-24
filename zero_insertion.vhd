--! Project : zero insertion    
--! <br>               
--! Author : Marco Corazzina                   
--! <br>               
--! Date : 2026                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : zero_insertion.vhd  
--! <br>               
--! This block can insert R-1 zeros between each input sample to upsample the signal. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- Entity: zero_insertion
-- Description: Implements a register with an enable, and an active high,
-- asynchronous reset. The register holds its value when enable isn't asserted.

entity zero_insertion is
    generic(
        WIDTH : positive;
        R : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end zero_insertion;

architecture Behavioral of zero_insertion is

constant COUNTER_WIDTH : integer := integer(ceil(log2(real(R))));

begin
    process(clk, rst)
    -- 2 bit counter to keep track of the number of clock cycles since the last reset
    variable count : unsigned(COUNTER_WIDTH-1 downto 0) := (others => '0');
    begin
        if (rst = '0') then
            output <= (others => '0');
            
        elsif (rising_edge(clk) and en = '1') then
            if (count = 0) then
                output <= input;
            else
                output <= (others => '0');
            end if;
            count := count + 1;

        end if;
    end process;
end Behavioral;





