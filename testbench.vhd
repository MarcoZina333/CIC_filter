library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE cic_test OF testbench IS
    component CIC_interpolator_inst is
        generic(
            Bin : positive;	    -- Bit width of the input and output signals
		    N : positive; 	    -- Number of stages    -- Number of stages
            R : positive	    -- Interpolation factor
            );
        port(
            clk_fast    : in  std_logic;
            rst    : in  std_logic;
            en 	   : in  std_logic;
            Cout   : out std_logic_vector(N*2-1 downto 0);
            input  : in  std_logic_vector(Bin-1 downto 0);
            output : out std_logic_vector(Bin-1 downto 0)
            );
    end component;

    component clock_divider is
        generic(
            R : positive
            );
        port(
            rst       : in  std_logic;
            clk       : in  std_logic;
            clock_out : out std_logic
            );
    end component;

    constant Bin     :  INTEGER  := 16;      -- Bus Width
    constant N       :  INTEGER  := 4;       -- Filter order
    constant R       :  INTEGER  := 10;      -- Interpolation factor
    constant Per     :  TIME     := 20 ns;   -- Clk period
    constant TestLen :  INTEGER  := 70;      -- No. of Count (MckPer/2) for test
   

   signal clock_fast : std_logic := '0';
   signal clock_slow : std_logic := '0';
   signal reset : std_logic := '0';
   
   signal input : std_logic_vector(Bin-1 downto 0):= "0000000000000000" ;
   signal output : std_logic_vector(Bin-1 downto 0);
   
   SIGNAL clk_cycle : INTEGER ;
   SIGNAL Testing: Boolean := True;
   
   BEGIN
   clock_fast <= NOT clock_fast AFTER Per/2 WHEN Testing ELSE '0';
  
    I: CIC_interpolator_inst
        generic map (
            N => N,
            Bin => Bin,
            R => R
        )  
        port map (
            clk_fast => clock_fast,
            rst => reset,
            en => '1',
            input => input,
            output => output
        );

    CD: clock_divider
        generic map (R => R)
        port map (
            clk => clock_fast,
            rst => reset,
            clock_out => clock_slow
        );
     
    
    Test_Proc: PROCESS(clock_slow)
        VARIABLE count: INTEGER:= 1;
    BEGIN
     --if rising_edge(clock_slow) then
        clk_cycle <= (count+1)/2;

        CASE count IS
    
            WHEN  1   => input <= "0000000000000000" ; reset <= '1';
            WHEN  3   => input <= "0000000000000001";
            WHEN  5   => input <= "0000000000000010";
            WHEN  7   => input <= "0000000000000101";
            WHEN  9   => input <= "0000000000001010";
            WHEN  11  => input <=  "0000000000000101";
            WHEN  13  => input <= "0000000000001010";
            WHEN  15  => input <= "0000000000001011";
            WHEN  17  => input <= "0000000000001111";
            WHEN  19  => input <= "0000000000001000";
            WHEN  21  => input <=  "0000000000000011";
            WHEN  23  => input <=  "0000000000011110";
            WHEN  25  => input <=  "0000000000000001";  
            
            WHEN  27  => input <= "1111111111111101";
            WHEN  29 => input <= "1111111111101100";
            WHEN  31  => input <= "1111111111111001";
            WHEN  33  => input <= "0000000000001010";
            WHEN  35  => input <=  "1111111111111111";
            WHEN  37  => input <= "1111111111111011";
            WHEN  39  => input <= "1111111111110001";
            WHEN  41  => input <= "1111111111010011";
            WHEN  43  => input <= "1111111111100010";
            WHEN  45  => input <=  "1111111111100011";
            WHEN  47  => input <=  "0000000000000010";
            WHEN  49  => input <=  "0000000000000001";
            
            
            WHEN  51  => input <=  "0000000000000000"; 


            WHEN (TestLen - 1) =>   Testing <= False;
            WHEN OTHERS => NULL;
        END CASE;

     count:= count + 1;
    --end if;
   END PROCESS Test_Proc;
     
   END cic_test;