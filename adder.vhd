library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder is
    generic (
        WIDTH : positive -- Width of the adder 
    );
    Port (
        A     : in  std_logic_vector(WIDTH-1 downto 0);      -- First input
        B     : in  std_logic_vector(WIDTH-1 downto 0);      -- Second input
        Cin   : in  std_logic;                               -- Carry input
        Sum   : out std_logic_vector(WIDTH-1 downto 0);      -- Sum output
        Cout  : out std_logic                                -- Carry output
    );
end Adder;

architecture Behavioral of Adder is
begin

    sum_process: process(A, B, Cin)
    variable temp_carry : std_logic_vector;
    begin
        -- Initial carry input
        temp_carry := Cin; 
        for i in 0 to WIDTH-1 loop

            -- Sum bit calculation
            Sum(i) := A(i) XOR B(i) XOR temp_carry;

            -- Carry calculation for next bit
            temp_carry := (A(i) AND B(i)) OR (temp_carry AND (A(i) XOR B(i))); 
        end loop;

        -- Final carry output
        Cout <= temp_carry; 

    end process sum_process;
end Behavioral;