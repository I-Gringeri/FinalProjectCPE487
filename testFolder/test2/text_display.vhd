library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity text_display is
    port (
        line_index : in integer range 0 to 7;
        row        : in integer range 0 to 29;
        col        : in integer range 0 to 79;
        char_out   : out std_logic_vector(7 downto 0)
    );
end text_display;

architecture Behavioral of text_display is
    type string_array is array (0 to 7) of string(1 to 40);
    constant lyrics : string_array := (
        "Twinkle twinkle little star      ",
        "How I wonder what you are        ",
        "Up above the world so high       ",
        "Like a diamond in the sky        ",
        "Twinkle twinkle little star      ",
        "How I wonder what you are        ",
        "                                ",
        "                                "
    );
begin
    process(line_index, row, col)
    begin
        if row = 15 and col < 40 then
            char_out <= std_logic_vector(to_unsigned(character'pos(lyrics(line_index)(col + 1)), 8));
        else
            char_out <= (others => '0');
        end if;
    end process;
end Behavioral;
