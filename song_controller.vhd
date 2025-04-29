library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity song_controller is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        btn_debounced : in  STD_LOGIC_VECTOR(3 downto 0);
        switch           : in  STD_LOGIC_VECTOR(7 downto 0);
        song_state   : out STD_LOGIC_VECTOR(1 downto 0);
        note_index   : out STD_LOGIC_VECTOR(5 downto 0);
        current_lyric : out STD_LOGIC_VECTOR(2 downto 0);
        music_volume : out STD_LOGIC_VECTOR(7 downto 0);
        mic_volume   : out STD_LOGIC_VECTOR(7 downto 0);
        echo_enabled : out STD_LOGIC
    );
end song_controller;

architecture Behavioral of song_controller is
    -- Song states
    constant STATE_IDLE    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant STATE_PLAYING : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant STATE_PAUSED  : STD_LOGIC_VECTOR(1 downto 0) := "10";
    
    -- Internal signals
    signal current_state   : STD_LOGIC_VECTOR(1 downto 0) := STATE_IDLE;
    signal index_counter   : unsigned(5 downto 0) := (others => '0');
    signal note_timer      : unsigned(24 downto 0) := (others => '0');
    signal lyric_index     : unsigned(2 downto 0) := (others => '0');
    signal vol_music       : unsigned(7 downto 0) := X"80"; -- Default 50% volume
    signal vol_mic         : unsigned(7 downto 0) := X"80"; -- Default 50% volume
    signal echo_effect     : STD_LOGIC := '0';
    signal btn_prev        : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    
    -- Note durations
    constant QUARTER_NOTE : unsigned(24 downto 0) := to_unsigned(25000000, 25); -- 0.25s at 100MHz
    
begin
    -- Control logic for buttons and song state
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= STATE_IDLE;
            index_counter <= (others => '0');
            lyric_index <= (others => '0');
            vol_music <= X"80";
            vol_mic <= X"80";
            echo_effect <= '0';
            btn_prev <= (others => '0');
            note_timer <= (others => '0');
        elsif rising_edge(clk) then
            -- Button state changes detection
            if btn_debounced(0) = '1' and btn_prev(0) = '0' then -- Start/Pause (BTNU)
                case current_state is
                    when STATE_IDLE =>
                        current_state <= STATE_PLAYING;
                        index_counter <= (others => '0');
                        lyric_index <= (others => '0');
                    when STATE_PLAYING =>
                        current_state <= STATE_PAUSED;
                    when STATE_PAUSED =>
                        current_state <= STATE_PLAYING;
                    when others =>
                        current_state <= STATE_IDLE;
                end case;
            end if;
            
            -- Volume controls
            if btn_debounced(1) = '1' and btn_prev(1) = '0' then -- Vol down (BTNL)
                if vol_music > X"10" then
                    vol_music <= vol_music - 16;
                end if;
            end if;
            
            if btn_debounced(2) = '1' and btn_prev(2) = '0' then -- Vol up (BTNR)
                if vol_music < X"F0" then
                    vol_music <= vol_music + 16;
                end if;
            end if;
            
            -- Echo effect toggle
            if btn_debounced(3) = '1' and btn_prev(3) = '0' then -- Echo (BTND)
                echo_effect <= not echo_effect;
            end if;
            
            -- Song playback logic
            if current_state = STATE_PLAYING then
                if note_timer < QUARTER_NOTE then
                    note_timer <= note_timer + 1;
                else
                    note_timer <= (others => '0');
                    
                    -- Move to next note
                    if index_counter < 41 then
                        index_counter <= index_counter + 1;
                        
                        -- Update lyric index at phrase boundaries
                        if index_counter = 6 or index_counter = 13 or 
                           index_counter = 20 or index_counter = 27 or 
                           index_counter = 34 then
                            if lyric_index < 5 then
                                lyric_index <= lyric_index + 1;
                            end if;
                        end if;
                    else
                        -- Loop back
                        index_counter <= (others => '0');
                        lyric_index <= (others => '0');
                    end if;
                end if;
            end if;
            
            -- Update microphone volume from switches
            vol_mic <= unsigned(switch);
            
            -- Store previous button states
            btn_prev <= btn_debounced;
        end if;
    end process;
    
    -- Output assignments
    song_state <= current_state;
    note_index <= std_logic_vector(index_counter);
    current_lyric <= std_logic_vector(lyric_index);
    music_volume <= std_logic_vector(vol_music);
    mic_volume <= std_logic_vector(vol_mic);
    echo_enabled <= echo_effect;
    
end Behavioral;
