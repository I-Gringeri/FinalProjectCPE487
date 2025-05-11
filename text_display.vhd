library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity text_display is
    port (
        line_index : in integer range 0 to 7;
        row        : in integer range 0 to 37;  -- Increased for 600 pixels (600/16 = 37.5)
        col        : in integer range 0 to 99;  -- Increased for 800 pixels (800/8 = 100)
        char_out   : out std_logic_vector(7 downto 0)
    );
end text_display;

architecture Behavioral of text_display is
    type string_array is array (0 to 7) of string(1 to 50);  -- Increased string length
    
    constant lyrics : string_array := (
        "Twinkle twinkle little star                       ",
        "How I wonder what you are                         ",
        "Up above the world so high                        ",
        "Like a diamond in the sky                         ",
        "Twinkle twinkle little star                       ",
        "How I wonder what you are                         ",
        "                                                  ",
        "                                                  "
    );
    
    -- Calculate center position 
    constant center_row : integer := 18;  -- Center row for 600 pixels (37/2 ≈ 18)
    constant center_col : integer := 25;  -- Starting column for centering text
    
begin
    process(line_index, row, col)
    begin
        -- Display lyrics centered on screen
        if row = center_row and col >= center_col and col < center_col + 50 then
            char_out <= std_logic_vector(to_unsigned(character'pos(lyrics(line_index)(col - center_col - 1)), 8));
        else
            char_out <= std_logic_vector(to_unsigned(character'pos(' '), 8));  -- Space character
        end if;
    end process;
end Behavioral;
