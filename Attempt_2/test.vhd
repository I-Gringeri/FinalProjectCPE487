library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity twinkle_audio is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;  -- External reset
        audio_out_pwm : out STD_LOGIC;
        aud_sd        : out STD_LOGIC   -- Audio shutdown (active low)
    );
end twinkle_audio;
architecture Behavioral of twinkle_audio is
    -- Note frequency counts for 100MHz clock
    constant C4 : integer := 191113;
    constant D4 : integer := 170262;
    constant E4 : integer := 151686;
    constant F4 : integer := 143173;
    constant G4 : integer := 127551;
    constant A4 : integer := 113636;
    constant REST : integer := 0;
    type note_array is array(0 to 47) of integer;
    constant SONG : note_array := (
        C4, C4, G4, G4, A4, A4, G4, G4,
        F4, F4, E4, E4, D4, D4, C4, C4,
        G4, G4, F4, F4, E4, E4, D4, D4,
        G4, G4, F4, F4, E4, E4, D4, D4,
        C4, C4, G4, G4, A4, A4, G4, G4,
        F4, F4, E4, E4, D4, D4, C4, C4
    );
    
    signal note_index : integer range 0 to 47 := 0;
    signal note_timer : integer := 0;
    constant NOTE_DURATION : integer := 50000000;  -- 0.5s at 100 MHz
    signal tone_counter : integer := 0;
    signal tone_limit   : integer := C4;
    signal square_wave  : STD_LOGIC := '0';
    signal pwm_counter  : unsigned(15 downto 0) := (others => '0');
    signal audio_level  : unsigned(15 downto 0);
begin
    -- Tone generation based on current note
    process(clk, reset)
    begin
        if reset = '1' then
            tone_counter <= 0;
            square_wave <= '0';
            note_index <= 0;
            note_timer <= 0;
        elsif rising_edge(clk) then
            -- Play next note after NOTE_DURATION
            if note_timer >= NOTE_DURATION then
                note_timer <= 0;
                if note_index < 47 then
                    note_index <= note_index + 1;
                else
                    note_index <= 0;  -- loop the song
                end if;
            else
                note_timer <= note_timer + 1;
            end if;
            -- Set tone limit from song
            tone_limit <= SONG(note_index);
            -- Generate square wave tone
            if tone_limit /= 0 then
                if tone_counter >= tone_limit then
                    tone_counter <= 0;
                    square_wave <= not square_wave;
                else
                    tone_counter <= tone_counter + 1;
                end if;
            else
                square_wave <= '0';
            end if;
        end if;
    end process;
    -- Convert square wave to PWM amplitude
    audio_level <= x"7FFF" when square_wave = '1' else x"0000";
    -- Simple PWM generator
    process(clk)
    begin
        if rising_edge(clk) then
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < audio_level then
                audio_out_pwm <= '1';
            else
                audio_out_pwm <= '0';
            end if;
        end if;
    end process;
    -- Enable amplifier
    aud_sd <= '1';  -- Enable the audio amplifier
end Behavioral;
