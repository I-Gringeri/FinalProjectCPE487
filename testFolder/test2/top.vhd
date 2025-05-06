library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk     : in  std_logic;
        hsync   : out std_logic;
        vsync   : out std_logic;
        red     : out std_logic_vector(3 downto 0);
        green   : out std_logic_vector(3 downto 0);
        blue    : out std_logic_vector(3 downto 0)
    );
end top;

architecture Behavioral of top is
    signal pixel_x, pixel_y : integer range 0 to 639;
    signal video_on         : std_logic;
    signal line_index       : integer range 0 to 7;
    signal row, col         : integer range 0 to 29;
    signal char_code        : std_logic_vector(7 downto 0);
    signal font_row         : std_logic_vector(2 downto 0);
    signal pixels           : std_logic_vector(7 downto 0);
    signal pixel_bit        : std_logic;

    constant CHAR_WIDTH  : integer := 8;
    constant CHAR_HEIGHT : integer := 8;
begin
    -- VGA sync
    vga_inst : entity work.vga_sync
        port map (
            clk       => clk,
            hsync     => hsync,
            vsync     => vsync,
            video_on  => video_on,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y
        );

    -- FSM for lyric line control
    fsm_inst : entity work.twinkle_fsm
        port map (
            clk        => clk,
            reset      => '0',
            line_index => line_index
        );

    -- Character position
    row <= pixel_y / CHAR_HEIGHT;
    col <= pixel_x / CHAR_WIDTH;
    font_row <= std_logic_vector(to_unsigned(pixel_y mod CHAR_HEIGHT, 3));

    -- Character ROM access
    text_gen : entity work.text_display
        port map (
            line_index => line_index,
            row        => row,
            col        => col,
            char_out   => char_code
        );

    rom_inst : entity work.char_rom
        port map (
            clk    => clk,
            char   => char_code,
            row    => font_row,
            pixels => pixels
        );

    pixel_bit <= pixels(to_integer(unsigned(std_logic_vector(to_unsigned(pixel_x mod 8, 3)))));

    -- VGA color output
    red   <= (others => pixel_bit and video_on);
    green <= (others => pixel_bit and video_on);
    blue  <= (others => pixel_bit and video_on);
end Behavioral;
