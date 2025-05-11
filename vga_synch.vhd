library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_sync is
    port (
        clk       : in  std_logic;
        hsync     : out std_logic;
        vsync     : out std_logic;
        video_on  : out std_logic;
        pixel_x   : out integer range 0 to 799;  -- Updated for 800 pixels width
        pixel_y   : out integer range 0 to 599   -- Updated for 600 pixels height
    );
end vga_sync;
architecture Behavioral of vga_sync is
    -- VGA 800x600 @ 60Hz timing parameters
    -- These values are for a 40MHz pixel clock
    constant H_DISPLAY  : integer := 800;  -- Horizontal display area
    constant H_FRONT    : integer := 40;   -- Horizontal front porch
    constant H_SYNC     : integer := 128;  -- Horizontal sync pulse
    constant H_BACK     : integer := 88;   -- Horizontal back porch
    constant H_MAX      : integer := H_DISPLAY + H_FRONT + H_SYNC + H_BACK;
    
    constant V_DISPLAY  : integer := 600;  -- Vertical display area
    constant V_FRONT    : integer := 1;    -- Vertical front porch
    constant V_SYNC     : integer := 4;    -- Vertical sync pulse
    constant V_BACK     : integer := 23;   -- Vertical back porch
    constant V_MAX      : integer := V_DISPLAY + V_FRONT + V_SYNC + V_BACK;
    
    signal h_count : integer range 0 to H_MAX := 0;
    signal v_count : integer range 0 to V_MAX := 0;
begin
    -- Horizontal and vertical counters
    process(clk)
    begin
        if rising_edge(clk) then
            if h_count = H_MAX - 1 then
                h_count <= 0;
                if v_count = V_MAX - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;
    
    -- Horizontal sync: active low pulse
    hsync    <= '0' when (h_count >= H_DISPLAY + H_FRONT and h_count < H_DISPLAY + H_FRONT + H_SYNC) else '1';
    
    -- Vertical sync: active low pulse
    vsync    <= '0' when (v_count >= V_DISPLAY + V_FRONT and v_count < V_DISPLAY + V_FRONT + V_SYNC) else '1';
    
    -- Video on/off
    video_on <= '1' when (h_count < H_DISPLAY and v_count < V_DISPLAY) else '0';
    
    -- Pixel position
    pixel_x  <= h_count when h_count < H_DISPLAY else 0;
    pixel_y  <= v_count when v_count < V_DISPLAY else 0;
end Behavioral;
