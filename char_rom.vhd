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
        -- ASCII 32: ' ' (space)
        32 => (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
        -- ASCII 44: ',' (comma)
        44 => (x"00", x"00", x"00", x"00", x"00", x"18", x"18", x"10"),
        -- ASCII 46: '.' (period)
        46 => (x"00", x"00", x"00", x"00", x"00", x"18", x"18", x"00"),
        -- ASCII 63: '?' (question mark)
        63 => (x"3C", x"42", x"02", x"04", x"08", x"00", x"08", x"00"),
        -- Uppercase
        65 => (x"18", x"24", x"42", x"7E", x"42", x"42", x"42", x"00"), -- A
        66 => (x"7C", x"42", x"42", x"7C", x"42", x"42", x"7C", x"00"), -- B
        69 => (x"7E", x"40", x"40", x"7C", x"40", x"40", x"7E", x"00"), -- E
        72 => (x"42", x"42", x"42", x"7E", x"42", x"42", x"42", x"00"), -- H
        73 => (x"7E", x"18", x"18", x"18", x"18", x"18", x"7E", x"00"), -- I
        75 => (x"42", x"44", x"48", x"70", x"48", x"44", x"42", x"00"), -- K
        76 => (x"40", x"40", x"40", x"40", x"40", x"40", x"7E", x"00"), -- L
        78 => (x"42", x"62", x"52", x"4A", x"46", x"42", x"42", x"00"), -- N
        79 => (x"3C", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"), -- O
        82 => (x"7C", x"42", x"42", x"7C", x"48", x"44", x"42", x"00"), -- R
        83 => (x"3C", x"40", x"40", x"3C", x"02", x"02", x"7C", x"00"), -- S
        84 => (x"7E", x"18", x"18", x"18", x"18", x"18", x"18", x"00"), -- T
        85 => (x"42", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"), -- U
        87 => (x"42", x"42", x"42", x"5A", x"5A", x"66", x"42", x"00"), -- W
        89 => (x"42", x"42", x"24", x"18", x"18", x"18", x"18", x"00"), -- Y
        -- Lowercase
        97 => (x"00", x"00", x"3C", x"02", x"3E", x"42", x"3E", x"00"), -- a
        98 => (x"40", x"40", x"5C", x"62", x"42", x"62", x"5C", x"00"), -- b
        99 => (x"00", x"00", x"3C", x"40", x"40", x"40", x"3C", x"00"), -- c
        100 => (x"02", x"02", x"3A", x"46", x"42", x"46", x"3A", x"00"), -- d (fixed ASCII value)
        101 => (x"00", x"00", x"3C", x"42", x"7E", x"40", x"3C", x"00"), -- e
        103 => (x"00", x"00", x"3E", x"42", x"42", x"3E", x"02", x"3C"), -- g
        104 => (x"40", x"40", x"5C", x"62", x"42", x"42", x"42", x"00"), -- h
        105 => (x"10", x"00", x"30", x"10", x"10", x"10", x"38", x"00"), -- i
        107 => (x"40", x"44", x"48", x"70", x"48", x"44", x"42", x"00"), -- k
        108 => (x"30", x"10", x"10", x"10", x"10", x"10", x"38", x"00"), -- l
        109 => (x"00", x"00", x"54", x"6A", x"4A", x"4A", x"4A", x"00"), -- m
        110 => (x"00", x"00", x"5C", x"62", x"42", x"42", x"42", x"00"), -- n
        111 => (x"00", x"00", x"3C", x"42", x"42", x"42", x"3C", x"00"), -- o
        112 => (x"00", x"00", x"5C", x"62", x"62", x"5C", x"40", x"40"), -- p
        114 => (x"00", x"00", x"5C", x"62", x"40", x"40", x"40", x"00"), -- r
        115 => (x"00", x"00", x"3C", x"40", x"3C", x"02", x"7C", x"00"), -- s
        116 => (x"10", x"10", x"7C", x"10", x"10", x"12", x"0C", x"00"), -- t
        117 => (x"00", x"00", x"42", x"42", x"42", x"46", x"3A", x"00"), -- u
        118 => (x"00", x"00", x"42", x"42", x"42", x"24", x"18", x"00"), -- v
        119 => (x"00", x"00", x"42", x"42", x"5A", x"5A", x"24", x"00"), -- w
        121 => (x"00", x"00", x"42", x"42", x"3E", x"02", x"3C", x"00"), -- y
        others => (others => x"00")
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            pixels <= rom(to_integer(unsigned(char)), to_integer(unsigned(row)));
        end if;
    end process;
end Behavioral;
