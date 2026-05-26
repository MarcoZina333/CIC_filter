library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE cic_test OF testbench IS
    component CIC_decimator_inst is
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
    --constant TestLen :  INTEGER  := 70;      -- No. of Count (MckPer/2) for test
   

   signal clock_fast : std_logic := '0';
   signal clock_slow : std_logic := '0';
   signal reset : std_logic := '0';
   
   signal input : std_logic_vector(Bin-1 downto 0):= "0000000000000000" ;
   signal output : std_logic_vector(Bin-1 downto 0);
   
   SIGNAL Testing: Boolean := True;
   
   BEGIN
   clock_fast <= NOT clock_fast AFTER Per/2 WHEN Testing ELSE '0';
  
    I: CIC_decimator_inst
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
            rst => '1',
            clock_out => clock_slow
        );
     
    
    Test_Proc: PROCESS(clock_fast)
        variable count : integer := 0;
    BEGIN  
    if rising_edge(clock_fast) then
        if count > 7 then
            input <= std_logic_vector( to_signed(integer(sin(2.0*MATH_PI/real(R*5)*real(count))*real(2.0**(Bin-1)-1.0)), Bin));
        elsif count = 1 then
            reset <= '1';
        end if;
        count := count + 1;
    end if;
   END PROCESS Test_Proc;
     
   END cic_test;