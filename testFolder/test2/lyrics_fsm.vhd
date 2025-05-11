library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lyrics_fsm is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        play        : in std_logic;
        line_index  : out integer range 0 to 7
    );
end lyrics_fsm;

architecture Behavioral of lyrics_fsm is
    signal counter      : integer := 0;
    signal current_line : integer range 0 to 7 := 0;
    constant MAX_COUNT  : integer := 400_000_000; -- Change line every ~4s at 100MHz
begin
    process(clk)
    begin
        if play = '1' then
        if rising_edge(clk) then
            if reset = '1' then
                counter      <= 0;
                current_line <= 0;
            else
                if counter >= MAX_COUNT then
                    counter <= 0;
                    if current_line = 7 then
                        current_line <= 0;
                    else
                        current_line <= current_line + 1;
                    end if;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
        end if;
    end process;

    line_index <= current_line;
end Behavioral;
