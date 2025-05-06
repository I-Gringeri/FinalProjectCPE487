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
        -- Only some characters shown here for brevity (e.g. space, A-Z, a-z)
        32 => (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"), -- ' '
        65 => (x"18", x"24", x"42", x"7E", x"42", x"42", x"42", x"00"), -- 'A'
        66 => (x"7C", x"42", x"42", x"7C", x"42", x"42", x"7C", x"00"), -- 'B'
        -- Add rest as needed
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
