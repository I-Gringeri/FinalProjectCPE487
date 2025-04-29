library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg_display_controller is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        current_lyric : in  STD_LOGIC_VECTOR(2 downto 0);
        CA1, CB1, CC1, CD1, CE1, CF1, CG1, DP1 : out STD_LOGIC;
        disp          : out STD_LOGIC_VECTOR(7 downto 0)
    );
end seg_display_controller;

architecture Behavioral of seg_display_controller is
    -- Seven-segment display scanning
    signal seg_counter : unsigned(19 downto 0) := (others => '0');
    signal seg_digit : unsigned(2 downto 0) := (others => '0');
    signal seg_pattern : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');
    
    -- Lyrics display data (segment patterns for 7-segment display)
    type lyrics_segment_array is array(0 to 5) of STD_LOGIC_VECTOR(31 downto 0);
    constant LYRICS_SEGMENTS : lyrics_segment_array := (
        X"ABCDEF12", -- Line 1
        X"34567890", -- Line 2
        X"98765432", -- Line 3
        X"FEDCBA01", -- Line 4
        X"13579BDF", -- Line 5
        X"2468ACE0"  -- Line 6
    );
    
    -- Character definitions for 7-segment display (active low)
    -- Segment mapping: [CG,CF,CE,CD,CC,CB,CA]
    type char_map is array(0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
    constant CHAR_SEGMENTS : char_map := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000", -- 9
        "0001000", -- A
        "0000011", -- b
        "1000110", -- C
        "0100001", -- d
        "0000110", -- E
        "0001110"  -- F
    );
    
    -- Signals for display data
    signal current_segments : STD_LOGIC_VECTOR(31 downto 0);
    signal digit_value : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    -- Select the appropriate lyrics segments based on current_lyric
    current_segments <= LYRICS_SEGMENTS(to_integer(unsigned(current_lyric))) when to_integer(unsigned(current_lyric)) < 6 else X"00000000";
    
    -- Process for scanning the 7-segment display
    process(clk, reset)
    begin
        if reset = '1' then
            seg_counter <= (others => '0');
            seg_digit <= (others => '0');
        elsif rising_edge(clk) then
            -- Counter for display refresh
            seg_counter <= seg_counter + 1;
            
            -- Update display digit every 2^17 clock cycles
            if seg_counter(16 downto 0) = (16 downto 0 => '1') then
                if seg_digit = 7 then
                    seg_digit <= (others => '0');
                else
                    seg_digit <= seg_digit + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- Process to select the current digit's value
    process(seg_digit, current_segments)
    begin
        case to_integer(seg_digit) is
            when 0 => digit_value <= current_segments(3 downto 0);
            when 1 => digit_value <= current_segments(7 downto 4);
            when 2 => digit_value <= current_segments(11 downto 8);
            when 3 => digit_value <= current_segments(15 downto 12);
            when 4 => digit_value <= current_segments(19 downto 16);
            when 5 => digit_value <= current_segments(23 downto 20);
            when 6 => digit_value <= current_segments(27 downto 24);
            when 7 => digit_value <= current_segments(31 downto 28);
            when others => digit_value <= "0000";
        end case;
    end process;
    
    -- Process to set the segment pattern based on digit value
    process(digit_value)
    begin
        seg_pattern <= CHAR_SEGMENTS(to_integer(unsigned(digit_value)));
    end process;
    
    -- Assign segments
    CA1 <= seg_pattern(0);
    CB1 <= seg_pattern(1);
    CC1 <= seg_pattern(2);
    CD1 <= seg_pattern(3);
    CE1 <= seg_pattern(4);
    CF1 <= seg_pattern(5);
    CG1 <= seg_pattern(6);
    DP1 <= '1';  -- Decimal point off
    
    -- Activate the current digit (active low)
    process(seg_digit)
    begin
        disp <= (others => '1');  -- All digits off
        disp(to_integer(seg_digit)) <= '0';  -- Current digit on
    end process;
    
end Behavioral;
