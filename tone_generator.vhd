library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tone_generator is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        song_state  : in  STD_LOGIC_VECTOR(1 downto 0);
        note_index  : in  STD_LOGIC_VECTOR(5 downto 0);
        tone_out    : out STD_LOGIC
    );
end tone_generator;

architecture Behavioral of tone_generator is
    -- Song state constants
    constant STATE_PLAYING : STD_LOGIC_VECTOR(1 downto 0) := "01";
    
    -- Note frequency values (based on 100MHz clock)
    constant C4_COUNT : integer := 191113; -- 261.63 Hz
    constant D4_COUNT : integer := 170262; -- 293.66 Hz
    constant E4_COUNT : integer := 151686; -- 329.63 Hz
    constant F4_COUNT : integer := 143173; -- 349.23 Hz
    constant G4_COUNT : integer := 127551; -- 392.00 Hz
    constant A4_COUNT : integer := 113636; -- 440.00 Hz
    
    -- Note sequencing
    type note_array is array(0 to 41) of integer;
    
    -- Notes for Twinkle Twinkle (C C G G A A G F F E E D D C...)
    constant NOTES : note_array := (
        C4_COUNT, C4_COUNT, G4_COUNT, G4_COUNT, A4_COUNT, A4_COUNT, G4_COUNT*2,
        F4_COUNT, F4_COUNT, E4_COUNT, E4_COUNT, D4_COUNT, D4_COUNT, C4_COUNT*2,
        G4_COUNT, G4_COUNT, F4_COUNT, F4_COUNT, E4_COUNT, E4_COUNT, D4_COUNT*2,
        G4_COUNT, G4_COUNT, F4_COUNT, F4_COUNT, E4_COUNT, E4_COUNT, D4_COUNT*2,
        C4_COUNT, C4_COUNT, G4_COUNT, G4_COUNT, A4_COUNT, A4_COUNT, G4_COUNT*2,
        F4_COUNT, F4_COUNT, E4_COUNT, E4_COUNT, D4_COUNT, D4_COUNT, C4_COUNT*2
    );
    
    -- Tone generation
    signal tone_counter : integer range 0 to 200000 := 0;
    signal tone_compare : integer range 0 to 200000 := C4_COUNT;
    signal tone_signal : STD_LOGIC := '0';
    
begin
    -- Tone generation process
    process(clk, reset)
    begin
        if reset = '1' then
            tone_counter <= 0;
            tone_signal <= '0';
            tone_compare <= C4_COUNT;
        elsif rising_edge(clk) then
            -- Update tone frequency based on current note
            tone_compare <= NOTES(to_integer(unsigned(note_index)));
            
            -- Generate tone only when playing
            if song_state = STATE_PLAYING then
                if tone_counter >= tone_compare then
                    tone_counter <= 0;
                    tone_signal <= not tone_signal;
                else
                    tone_counter <= tone_counter + 1;
                end if;
            else
                tone_signal <= '0';
            end if;
        end if;
    end process;
    
    -- Output assignment
    tone_out <= tone_signal;
    
end Behavioral;
