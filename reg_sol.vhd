--! Project : Register    
--! <br>               
--! Author : Emiliano Sisinni                   
--! <br>               
--! Date : AY2024/2025                          
--! <br>               
--! Company : UniBS                             
--! <br>               
--! File : reg.vhd  
--! <br>               
--! This example illustrates a variety of different register entities. To
--! simulate/synthesize a different entity, change the comments in the reg
--! entity at the bottom of this file.

library ieee;
use ieee.std_logic_1164.all;

-- Entity: reg_async_rst
-- Description: Implements a register with an active high, asynchronous reset.

entity reg_async_rst is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end reg_async_rst;

architecture BHV of reg_async_rst is
begin
    -- GUIDELINE 1 FOR SEQUENTIAL LOGIC: The sensitivity list should
    -- only have clock and reset (if there is an asynchronous reset). It
    -- technically shouldn't hurt anything if you include other signals, but
    -- they are not necessary, can slow down a simulation by needlessly
    -- retriggering the process, and might confuse a bad synthesis tool.
    
    process(clk, rst)
    begin
        -- SYNTHESIS GUIDELINE 2 FOR SEQUENTIAL LOGIC: All sequential logic with
        -- async reset should be described using the following basic structure:
        --
        -- if reset
        --   handle reset 
        -- elsif rising clock edge
        --   specify all non-reset functionality
        -- end if
        --
        -- Do not try to come up with another way of specifying equivalent
        -- behavior. Synthesis tools often require this template.
        --
        -- There are other techniques that will work with some tools, but since
        -- this template works for any form of sequential logic, there is no
        -- need to change it.
        
        if (rst = '1') then
            -- Reset the output to all 0s. The others statement sets all the
            -- bits equal to the specified value. It is part of a more general
            -- aggregation construct that will be discussed in other examples.
            output <= (others => '0');
            
        elsif (rising_edge(clk)) then

            -- SYNTHESIS RULE: Any assignment to a signal on a rising clock
            -- edge will be synthesized as a register, where the LHS is the
            -- output of the register, and the RHS is the input. This might
            -- seem obvious for this simple example, but it is critically
            -- important to remember this rule for bigger examples because
            -- adding or omitting a register is a very common source of bugs.
            -- When we "design the circuit" before writing the code, a huge
            -- part of that design is determining the number of registers.
            -- To ensure that the synthesized circuit has the same number of
            -- registers as our design circuit, we need to understand how
            -- registers get created during synthesis.
            --
            -- Note that variables can be synthesized as either wires or
            -- registers depending on the usage, which will be explained in
            -- later examples.
            output <= input;
        end if;
    end process;
end BHV;


library ieee;
use ieee.std_logic_1164.all;

-- Entity: reg_sync_rst
-- Description: Implements a register with an active high, synchronous reset.

entity reg_sync_rst is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end reg_sync_rst;

architecture BHV of reg_sync_rst is
begin
    -- For a synchronous reset, we only need the clock in the sensitivity list.
    -- However, it doesn't really hurt to include reset because a simulation is
    -- unlikely to be frequently resetting a register, so it probably won't
    -- slow down the simulation much. Also, it won't affect synthesis. 
    process(clk)
    begin
        if (rising_edge(clk)) then
            -- For the synchronous reset, we check the reset on the rising
            -- clock edge.
            if (rst = '1') then
                output <= (others => '0');
            else
                output <= input;
            end if;
        end if;
    end process;
end BHV;


library ieee;
use ieee.std_logic_1164.all;

-- Entity: reg_en_async_rst
-- Description: Implements a register with an enable, and an active high,
-- asynchronous reset. The register holds its value when enable isn't asserted.

entity reg_en_async_rst is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end reg_en_async_rst;

architecture BHV of reg_en_async_rst is
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            output <= (others => '0');
            
        elsif (rising_edge(clk)) then
            -- Here we simply add an if statement to check if enable is
            -- asserted. Note that to comply with my coding guideline,
            -- this has to be done on the rising clock edge since it isn't
            -- related to reset.
            if (en = '1') then
                output <= input;
            end if;
        end if;
    end process;
end BHV;


library ieee;
use ieee.std_logic_1164.all;

-- Entity: reg_en_sync_rst
-- Description: Implements a register with an enable, and an active high,
-- synchronous reset. The register holds its value when enable isn't asserted.

entity reg_en_sync_rst is
    generic(
        WIDTH : positive
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end reg_en_sync_rst;


architecture BHV of reg_en_sync_rst is
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            -- Here we move the reset on the clock edge to make it synchronous
            -- and then have an elsif for the enable. Note that we have to
            -- check the conditions in this order since reset has priority
            -- over the enable.
            if (rst = '1') then
                output <= (others => '0');
            elsif (en = '1') then
                output <= input;
            end if;
        end if;
    end process;
end BHV;





library ieee;
use ieee.std_logic_1164.all;

-- Entity: reg
-- Description: Provides a top-level reigster entity for evaluating all the
-- implementations shown above.

entity reg is
    generic(
        WIDTH : positive := 8
        );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
        );
end reg;

architecture default_arch of reg is
begin

    -- INSTRUCTIONS: Uncomment the architecture/entity that you want to
    -- evaluate.

    --U_REG : entity work.reg_async_rst
    U_REG : entity work.reg_sync_rst
        generic map (WIDTH => WIDTH)
        port map (clk    => clk,
                  rst    => rst,
                  input  => input,
                  output => output);



    --U_REG : entity work.reg_en_async_rst
    --U_REG : entity work.reg_en_sync_rst
    --    generic map (WIDTH => WIDTH)
    --    port map (clk    => clk,
    --              rst    => rst,
    --              en     => en,
    --              input  => input,
    --              output => output);



    
end default_arch;
