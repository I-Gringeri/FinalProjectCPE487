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
    -- FSM states
    type play_state_type is (IDLE, PLAYING, COMPLETED);
    signal play_state : play_state_type := IDLE;
    
    signal counter      : integer := 0;
    signal current_line : integer range 0 to 7 := 0;
    
    constant MAX_COUNT  : integer := 400_000_000; -- Change line every ~4s at 100MHz
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            current_line <= 0;
            play_state <= IDLE;
        elsif rising_edge(clk) then
            -- State transitions based on play signal
            case play_state is
                when IDLE =>
                    if play = '1' then
                        play_state <= PLAYING;
                        counter <= 0;
                        current_line <= 0;
                    end if;
                    
                when PLAYING =>
                    -- Increment counter and update current line
                    if counter >= MAX_COUNT then
                        counter <= 0;
                        if current_line = 6 then  -- Changed from 7 to 6 to stop at the last line
                            current_line <= 7;
                            play_state <= COMPLETED;
                        else
                            current_line <= current_line + 1;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                    
                when COMPLETED =>
                    -- Stay in completed state until reset
                    null;
            end case;
        end if;
    end process;
    
    -- Output current line
    line_index <= current_line;
end Behavioral;
