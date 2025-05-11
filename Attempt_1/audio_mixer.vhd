library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity audio_mixer is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        tone_in         : in  STD_LOGIC;
        mic_in          : in  STD_LOGIC_VECTOR(7 downto 0);
        mic_sample_ready : in  STD_LOGIC;
        music_volume    : in  STD_LOGIC_VECTOR(7 downto 0);
        mic_volume      : in  STD_LOGIC_VECTOR(7 downto 0);
        echo_enabled    : in  STD_LOGIC;
        mixed_audio     : out STD_LOGIC_VECTOR(15 downto 0);
        pwm_out         : out STD_LOGIC
    );
end audio_mixer;

architecture Behavioral of audio_mixer is
    -- Echo buffer
    type echo_buffer_type is array(0 to 8191) of unsigned(7 downto 0);
    signal echo_buffer : echo_buffer_type := (others => (others => '0'));
    signal echo_write_ptr : integer range 0 to 8191 := 0;
    signal echo_read_ptr : integer range 0 to 8191 := 4000; -- ~100ms delay at 40kHz
    
    -- Audio mixing
    signal tone_amp : unsigned(15 downto 0) := (others => '0');
    signal mic_amp : unsigned(15 downto 0) := (others => '0');
    signal echo_amp : unsigned(15 downto 0) := (others => '0');
    signal audio_mix : unsigned(15 downto 0) := (others => '0');
    
    -- PWM generation
    signal pwm_counter : unsigned(15 downto 0) := (others => '0');
    
begin
    -- Echo effect processing
    process(clk, reset)
    begin
        if reset = '1' then
            echo_write_ptr <= 0;
            echo_read_ptr <= 4000;
            for i in 0 to 8191 loop
                echo_buffer(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if mic_sample_ready = '1' then
                -- Store microphone sample in echo buffer
                echo_buffer(echo_write_ptr) <= unsigned(mic_in);
                
                -- Update write pointer
                if echo_write_ptr < 8191 then
                    echo_write_ptr <= echo_write_ptr + 1;
                else
                    echo_write_ptr <= 0;
                end if;
                
                -- Update read pointer
                if echo_read_ptr < 8191 then
                    echo_read_ptr <= echo_read_ptr + 1;
                else
                    echo_read_ptr <= 0;
                end if;
            end if;
        end if;
    end process;
    
    -- Audio mixing and PWM generation
    process(clk, reset)
    begin
        if reset = '1' then
            tone_amp <= (others => '0');
            mic_amp <= (others => '0');
            echo_amp <= (others => '0');
            audio_mix <= (others => '0');
            pwm_counter <= (others => '0');
            pwm_out <= '0';
        elsif rising_edge(clk) then
            -- Scale tone by music volume
            if tone_in = '1' then
                tone_amp <= resize(unsigned(music_volume) * 128, 16);
            else
                tone_amp <= (others => '0');
            end if;
            
            -- Scale microphone by mic volume
            mic_amp <= resize(unsigned(mic_in) * unsigned(mic_volume) / 256, 16);
            
            -- Add echo if enabled
            if echo_enabled = '1' then
                echo_amp <= resize(echo_buffer(echo_read_ptr) * unsigned(mic_volume) / 512, 16);
            else
                echo_amp <= (others => '0');
            end if;
            
            -- Mix all audio sources
            audio_mix <= tone_amp + mic_amp + echo_amp;
            
            -- PWM generation for audio output
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < audio_mix then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process;
    
    -- Output assignment
    mixed_audio <= std_logic_vector(audio_mix);
    
end Behavioral;
