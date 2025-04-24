library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ToneGenerator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tone_out : out STD_LOGIC);
end ToneGenerator;

architecture Behavioral of ToneGenerator is
    signal counter : INTEGER := 0;
    signal tone : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            tone <= '0';
        elsif rising_edge(clk) then
            if counter = 500000 then -- Adjust for desired frequency
                tone <= not tone;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    tone_out <= tone;
end Behavioral;
