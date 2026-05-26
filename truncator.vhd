library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity truncator is
    generic(
        WIDTH_IN : positive;
        WIDTH_OUT : positive
        );
    port(
        input  : in  std_logic_vector(WIDTH_IN-1 downto 0);
        output : out std_logic_vector(WIDTH_OUT-1 downto 0)
        );
end truncator;

architecture Dataflow of truncator is
begin
    output <= input(WIDTH_IN-1 downto WIDTH_IN-WIDTH_OUT);
end Dataflow;