library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk_in  : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        clk_out : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal clk_divider : unsigned(1 downto 0) := (others => '0');
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            clk_divider <= (others => '0');
        elsif rising_edge(clk_in) then
            clk_divider <= clk_divider + 1;
        end if;
    end process;
    
    -- Divide 100MHz to 25MHz (divide by 4)
    clk_out <= clk_divider(1);
end Behavioral;
