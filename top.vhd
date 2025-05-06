library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nexys_twinkle_karaoke is
    Port (
        -- Nexys A7 System Clock (100 MHz)
        clk_100MHz   : in  STD_LOGIC;
        
        -- Reset button (active-low on Nexys A7)
        reset_btn        : in  STD_LOGIC;  -- Center button for reset
        
        -- Control buttons
        up_btn        : in  STD_LOGIC;  -- Up button - Start/Pause song
        left_btn        : in  STD_LOGIC;  -- Left button - Decrease music volume
        right_btn        : in  STD_LOGIC;  -- Right button - Increase music volume
        down_btn        : in  STD_LOGIC;  -- Down button - Toggle echo effect
        
        -- Switches for configuration
        Switch          : in  STD_LOGIC_VECTOR(15 downto 0);
        
        -- LEDs for visual feedback
        LED         : out STD_LOGIC_VECTOR(15 downto 0);
        
        -- 7-segment display
        CA1, CB1, CC1, CD1, CE1, CF1, CG1, DP1 : out STD_LOGIC;
        disp          : out STD_LOGIC_VECTOR(7 downto 0);
        
        -- Audio output via PWM (connect to onboard audio jack)
        pwm_btn     : out STD_LOGIC;
        sd_btn      : out STD_LOGIC;
        
        -- Microphone input (assuming PDM microphone connected to JA Pmod)
        mic          : in  STD_LOGIC_VECTOR(7 downto 0)
    );
end nexys_twinkle_karaoke;

architecture Behavioral of nexys_twinkle_karaoke is
    -- Reset signal (active high internally)
    signal reset : STD_LOGIC := '0';
    
    -- Clock signals
    signal clk_25MHz : STD_LOGIC := '0';
    
    -- Button interface signals
    signal btn_debounced : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Song controller signals
    signal song_state : STD_LOGIC_VECTOR(1 downto 0);
    signal note_index : STD_LOGIC_VECTOR(5 downto 0);
    signal current_lyric : STD_LOGIC_VECTOR(2 downto 0);
    signal tone_out : STD_LOGIC;
    
    -- Volume control signals
    signal music_volume : STD_LOGIC_VECTOR(7 downto 0);
    signal mic_volume : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Audio processing signals
    signal mic_data : STD_LOGIC_VECTOR(7 downto 0);
    signal mic_sample_ready : STD_LOGIC;
    signal echo_enabled : STD_LOGIC;
    signal mixed_audio : STD_LOGIC_VECTOR(15 downto 0);
    
    -- LED patterns
    signal led_pattern : STD_LOGIC_VECTOR(15 downto 0);
    
begin
    -- Reset is active high internally, but button is active low on board
    reset <= not reset_btn;
    
    -- Enable audio output
    sd_btn <= '1';
    
    -- Clock divider for generating 25MHz from 100MHz
    clk_divider_inst: entity work.clock_divider
    port map (
        clk_in => CLK_100MHZ,
        reset => reset,
        clk_out => clk_25MHz
    );
    
    -- Button debouncing module
    button_controller_inst: entity work.button_controller
    port map (
        clk => CLK_100MHZ,
        reset => reset,
        btn_in(0) => up_btn,
        btn_in(1) => left_btn,
        btn_in(2) => right_btn,
        btn_in(3) => down_btn,
        btn_debounced => btn_debounced
    );
    
    -- Song sequencer module
    song_controller_inst: entity work.song_controller
    port map (
        clk => CLK_100MHZ,
        reset => reset,
        btn_debounced => btn_debounced,
        switch => Switch(15 downto 8),
        song_state => song_state,
        note_index => note_index,
        current_lyric => current_lyric,
        music_volume => music_volume,
        mic_volume => mic_volume,
        echo_enabled => echo_enabled
    );
    
    -- Tone generator module
--    tone_generator_inst: entity work.tone_generator
--    port map (
--        clk => CLK_100MHZ,
--        reset => reset,
--        song_state => song_state,
--        note_index => note_index,
--        tone_out => tone_out
--    );
    -- Tone Generator Using Test Code
    tone_generator_inst: entity work.twinkle_audio
    port map (
        clk => CLK_100MHZ,
        reset => reset,
        audio_out_pwm => pwm_btn
      );  
      
    -- Microphone input processor
    mic_processor_inst: entity work.mic_processor
    port map (
        clk => clk_25MHz,
        reset => reset,
        pdm_data => mic(1),
        mic_data => mic_data,
        sample_ready => mic_sample_ready
    );
    
    -- Echo effect and audio mixer
--    audio_mixer_inst: entity work.audio_mixer
--    port map (
--        clk => CLK_100MHZ,
--        reset => reset,
--        tone_in => tone_out,
--        mic_in => mic_data,
--        mic_sample_ready => mic_sample_ready,
--        music_volume => music_volume,
--        mic_volume => mic_volume,
--        echo_enabled => echo_enabled,
--        mixed_audio => mixed_audio,
--        pwm_out => pwm_btn
--    );
    
    -- LED display controller
    led_controller_inst: entity work.led_controller
    port map (
        clk => CLK_100MHZ,
        reset => reset,
        song_state => song_state,
        note_index => note_index,
        tone_out => tone_out,
        echo_enabled => echo_enabled,
        led_pattern => LED
    );
    
    -- 7-segment display controller
    seg_display_inst: entity work.seg_display_controller
    port map (
        clk => CLK_100MHZ,
        reset => reset,
        current_lyric => current_lyric,
        CA1 => CA1,
        CB1 => CB1,
        CC1 => CC1,
        CD1 => CD1,
        CE1 => CE1,
        CF1 => CF1,
        CG1 => CG1,
        DP1 => DP1,
        disp => disp
    );
    
end Behavioral;
