library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_divider is
    generic (
        R : positive -- Division factor 
    );
port ( 
        rst: in std_logic;
        clk: in std_logic;
        clock_out: out std_logic
    );
end clock_divider;
  
architecture Behavioral of clock_divider is
  

signal tmp : std_logic := '0';
  
begin
  
process(clk,rst)
variable count: natural := 0;
begin
    if(rst='0') then
        tmp <= '0';
        count := 0;
    elsif(rising_edge(clk)) then
        if (count = 0) then
            tmp <= NOT tmp;
        end if;        
        count := (count + 1) mod (R/2);
        
    end if;
end process;

clock_out <= tmp;
  
end Behavioral;
