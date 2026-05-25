library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extender is
    generic(
        WIDTH_IN : positive;
        WIDTH_OUT : positive
        );
    port(
        input  : in  std_logic_vector(WIDTH_IN-1 downto 0);
        output : out std_logic_vector(WIDTH_OUT-1 downto 0)
        );
end sign_extender;

architecture Behavioral of sign_extender is
begin
    output <= std_logic_vector(resize(signed(input), WIDTH_OUT));
end Behavioral;