library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity char_rom is
    port (
        clk     : in  std_logic;
        char    : in  std_logic_vector(7 downto 0);
        row     : in  std_logic_vector(2 downto 0);
        pixels  : out std_logic_vector(7 downto 0)
    );
end char_rom;

architecture Behavioral of char_rom is
    type rom_type is array(0 to 127, 0 to 7) of std_logic_vector(7 downto 0);
    signal rom : rom_type := (
        -- ASCII 32: ' '
        32 => (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),

        -- ASCII 65: 'A'
        65 => (x"18", x"24", x"42", x"7E", x"42", x"42", x"42", x"00"),
        -- ASCII 69: 'E'
        69 => (x"7E", x"40", x"40", x"7C", x"40", x"40", x"7E", x"00"),
        -- ASCII 72: 'H'
        72 => (x"42", x"42", x"42", x"7E", x"42", x"42", x"42", x"00"),
        -- ASCII 73: 'I'
        73 => (x"7E", x"18", x"18", x"18", x"18", x"18", x"7E", x"00"),
        -- ASCII 75: 'K'
        75 => (x"42", x"44", x"48", x"70", x"48", x"44", x"42", x"00"),
        -- ASCII 76: 'L'
        76 => (x"40", x"40", x"40", x"40", x"40", x"40", x"7E", x"00"),
        -- ASCII 78: 'N'
        78 => (x"42", x"62", x"52", x"4A", x"46", x"42", x"42", x"00"),
        -- ASCII 79: 'O'
        79 => (x"3C", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"),
        -- ASCII 82: 'R'
        82 => (x"7C", x"42", x"42", x"7C", x"48", x"44", x"42", x"00"),
        -- ASCII 83: 'S'
        83 => (x"3C", x"40", x"40", x"3C", x"02", x"02", x"7C", x"00"),
        -- ASCII 84: 'T'
        84 => (x"7E", x"18", x"18", x"18", x"18", x"18", x"18", x"00"),
        -- ASCII 85: 'U'
        85 => (x"42", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"),
        -- ASCII 87: 'W'
        87 => (x"42", x"42", x"42", x"5A", x"5A", x"66", x"42", x"00"),

        -- ASCII 97: 'a'
        97 => (x"00", x"00", x"3C", x"02", x"3E", x"42", x"3E", x"00"),
        -- ASCII 101: 'e'
        101 => (x"00", x"00", x"3C", x"42", x"7E", x"40", x"3C", x"00"),
        -- ASCII 104: 'h'
        104 => (x"40", x"40", x"5C", x"62", x"42", x"42", x"42", x"00"),
        -- ASCII 105: 'i'
        105 => (x"10", x"00", x"30", x"10", x"10", x"10", x"38", x"00"),
        -- ASCII 107: 'k'
        107 => (x"40", x"44", x"48", x"70", x"48", x"44", x"42", x"00"),
        -- ASCII 108: 'l'
        108 => (x"30", x"10", x"10", x"10", x"10", x"10", x"38", x"00"),
        -- ASCII 110: 'n'
        110 => (x"00", x"00", x"5C", x"62", x"42", x"42", x"42", x"00"),
        -- ASCII 111: 'o'
        111 => (x"00", x"00", x"3C", x"42", x"42", x"42", x"3C", x"00"),
        -- ASCII 114: 'r'
        114 => (x"00", x"00", x"5C", x"62", x"40", x"40", x"40", x"00"),
        -- ASCII 115: 's'
        115 => (x"00", x"00", x"3C", x"40", x"3C", x"02", x"7C", x"00"),
        -- ASCII 116: 't'
        116 => (x"10", x"10", x"7C", x"10", x"10", x"12", x"0C", x"00"),
        -- ASCII 117: 'u'
        117 => (x"00", x"00", x"42", x"42", x"42", x"46", x"3A", x"00"),
        -- ASCII 119: 'w'
        119 => (x"00", x"00", x"42", x"42", x"5A", x"5A", x"24", x"00"),

        others => (others => x"00")
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            pixels <= rom(to_integer(unsigned(char)))(to_integer(unsigned(row)));
        end if;
    end process;
end Behavioral;
