library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity text_display is
    port (
        clk        : in std_logic;
        reset      : in std_logic;                         
        line_index : in integer range 0 to 7;
        row        : in integer range 0 to 37;
        col        : in integer range 0 to 99;  
        play       : in std_logic;
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
    
    constant center_row : integer := 18;
    constant center_col : integer := 25;
    
    -- Add state machine for display control
    type display_state_type is (IDLE, DISPLAYING, COMPLETED);
    signal display_state : display_state_type := IDLE;
    
    signal current_displayed_line : integer range 0 to 7 := 0;
    

    constant LINE_DURATION : integer := 50000000;  -- 0.5s at 100MHz
    signal line_timer : integer := 0;
    
begin
    -- FSM
    process(clk, reset)
    begin
        if reset = '1' then
            display_state <= IDLE;
            current_displayed_line <= 0;
            line_timer <= 0;
        elsif rising_edge(clk) then
            if play = '1' and display_state = IDLE then
                display_state <= DISPLAYING;
                current_displayed_line <= 0;
                line_timer <= 0;
            end if;
            
            if display_state = DISPLAYING then
                if line_timer >= LINE_DURATION then
                    line_timer <= 0;
                    if current_displayed_line < 7 then
                        current_displayed_line <= current_displayed_line + 1;
                    else
                        display_state <= COMPLETED;
                    end if;
                else
                    line_timer <= line_timer + 1;
                end if;
            end if;
        end if;
    end process;
    
    process(row, col, line_index, display_state, current_displayed_line)
    begin
        char_out <= std_logic_vector(to_unsigned(character'pos(' '), 8));
        
        if display_state = DISPLAYING or display_state = COMPLETED then
            if line_index <= current_displayed_line then
                if row = center_row and col >= center_col and col < center_col + 50 then
                    char_out <= std_logic_vector(to_unsigned(character'pos(lyrics(line_index)(col - center_col - 1)), 8));
                end if;
            end if;
        end if;
    end process;
end Behavioral;
