
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Song_ROM is
    Port (
        clk : in STD_LOGIC;
        addr : in INTEGER range 0 to 15;
        frequency : out INTEGER;
        duration : out INTEGER
    );
end Song_ROM;

architecture Behavioral of Song_ROM is
    type Song_Array is array (0 to 15) of INTEGER;
    constant Notes : Song_Array := (261, 261, 392, 392, 440, 440, 392, -- "Twinkle"
                                    349, 349, 330, 330, 294, 294, 261); -- "Little Star"
    constant Durations : Song_Array := (500, 500, 500, 500, 500, 500, 1000, -- Note durations in ms
                                        500, 500, 500, 500, 500, 500, 1000);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            frequency <= Notes(addr);
            duration <= Durations(addr);
        end if;
    end process;
end Behavioral;
