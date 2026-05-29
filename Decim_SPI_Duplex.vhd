
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Filter_SPI_Duplex IS
Generic(
			DATA_W 	: integer	:= 16;				-- data width in bits
			Nbit 	  : integer	:= 4 				    -- log2(data width)
			);
    Port ( 	SS 		    : in STD_LOGIC;
           	SCK 		  : in STD_LOGIC;
           	MOSI 		  : in STD_LOGIC;
           	MISO 		  : out STD_LOGIC := '0');
END Filter_SPI_Duplex;
 
ARCHITECTURE Structural OF Filter_SPI_Duplex IS 


  COMPONENT spi
  Generic(
    DATA_W 	: integer	:= 16;				-- data width in bits
    Nbit 	: integer	:= 4 				-- log2(data width)
    );
  PORT(
        clk      : IN  std_logic;
        reset    : IN  std_logic;
        data_in  : IN  std_logic_vector(DATA_W-1 downto 0);
        data_out : OUT  std_logic_vector(DATA_W-1 downto 0);
        SCK      : IN  std_logic;
        MOSI     : IN  std_logic;
        MISO     : OUT  std_logic
      );
  END COMPONENT;

  component CIC_decimator_inst is
  generic(
      Bin : positive := 16;	-- Bit width of the input and output signals
      N : positive := 4;	  -- Number of stages
      R : positive := 10	  -- Decimation factor
      );
  port(
      clk_fast    : in  std_logic;
      rst    : in  std_logic;
      en 	   : in  std_logic;
      Cout   : out std_logic_vector(N*2-1 downto 0);
      input  : in  std_logic_vector(Bin-1 downto 0);
      output : out std_logic_vector(Bin-1 downto 0)
      );
  end component CIC_decimator_inst;

  signal clk : std_logic := FPGA_CLK1_50;
  signal data_in : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_out : std_logic_vector(DATA_W-1 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
    SPI_int: spi 
    GENERIC MAP (
      DATA_W => DATA_W,
      Nbit => Nbit
      )
    PORT MAP (
      clk => clk,
      reset => SS,
      data_in => data_in,
      data_out => data_out,
      SCK => SCK,
      MOSI => MOSI,
      MISO => MISO
      );
    

    CIC_int: CIC_decimator_inst 
    GENERIC MAP (
      Bin => DATA_W,
      N => 4,
      R => 10
      )
    PORT MAP (
      clk_fast => clk,
      rst => SS,
      en => SS,            
      Cout => open,      
      input => data_out,
      output => data_in
      );

    

   

END;
