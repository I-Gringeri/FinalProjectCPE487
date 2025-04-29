library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nexys_twinkle_karaoke is
    Port (
        -- Nexys A7 System Clock (100 MHz)
        CLK100MHZ   : in  STD_LOGIC;
        
        -- Reset button (active-low on Nexys A7)
        BTNC        : in  STD_LOGIC;  -- Center button for reset
        
        -- Control buttons
        BTNU        : in  STD_LOGIC;  -- Up button - Start/Pause song
        BTNL        : in  STD_LOGIC;  -- Left button - Decrease music volume
        BTNR        : in  STD_LOGIC;  -- Right button - Increase music volume
        BTND        : in  STD_LOGIC;  -- Down button - Toggle echo effect
        
        -- Switches for configuration
        SW          : in  STD_LOGIC_VECTOR(15 downto 0);
        
        -- LEDs for visual feedback
        LED         : out STD_LOGIC_VECTOR(15 downto 0);
        
        -- 7-segment display
        CA, CB, CC, CD, CE, CF, CG, DP : out STD_LOGIC;
        AN          : out STD_LOGIC_VECTOR(7 downto 0);
        
        -- Audio output via PWM (connect to onboard audio jack)
        AUD_PWM     : out STD_LOGIC;
        AUD_SD      : out STD_LOGIC;
        
        -- Microphone input (assuming PDM microphone connected to JA Pmod)
        JA          : in  STD_LOGIC_VECTOR(7 downto 0)
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
    reset <= not BTNC;
    
    -- Enable audio output
    AUD_SD <= '1';
    
    -- Clock divider for generating 25MHz from 100MHz
    clk_divider_inst: entity work.clock_divider
    port map (
        clk_in => CLK100MHZ,
        reset => reset,
        clk_out => clk_25MHz
    );
    
    -- Button debouncing module
    button_controller_inst: entity work.button_controller
    port map (
        clk => CLK100MHZ,
        reset => reset,
        btn_in(0) => BTNU,
        btn_in(1) => BTNL,
        btn_in(2) => BTNR,
        btn_in(3) => BTND,
        btn_debounced => btn_debounced
    );
    
    -- Song sequencer module
    song_controller_inst: entity work.song_controller
    port map (
        clk => CLK100MHZ,
        reset => reset,
        btn_debounced => btn_debounced,
        sw => SW(15 downto 8),
        song_state => song_state,
        note_index => note_index,
        current_lyric => current_lyric,
        music_volume => music_volume,
        mic_volume => mic_volume,
        echo_enabled => echo_enabled
    );
    
    -- Tone generator module
    tone_generator_inst: entity work.tone_generator
    port map (
        clk => CLK100MHZ,
        reset => reset,
        song_state => song_state,
        note_index => note_index,
        tone_out => tone_out
    );
    
    -- Microphone input processor
    mic_processor_inst: entity work.mic_processor
    port map (
        clk => clk_25MHz,
        reset => reset,
        pdm_data => JA(1),
        mic_data => mic_data,
        sample_ready => mic_sample_ready
    );
    
    -- Echo effect and audio mixer
    audio_mixer_inst: entity work.audio_mixer
    port map (
        clk => CLK100MHZ,
        reset => reset,
        tone_in => tone_out,
        mic_in => mic_data,
        mic_sample_ready => mic_sample_ready,
        music_volume => music_volume,
        mic_volume => mic_volume,
        echo_enabled => echo_enabled,
        mixed_audio => mixed_audio,
        pwm_out => AUD_PWM
    );
    
    -- LED display controller
    led_controller_inst: entity work.led_controller
    port map (
        clk => CLK100MHZ,
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
        clk => CLK100MHZ,
        reset => reset,
        current_lyric => current_lyric,
        CA => CA,
        CB => CB,
        CC => CC,
        CD => CD,
        CE => CE,
        CF => CF,
        CG => CG,
        DP => DP,
        AN => AN
    );
    
end Behavioral;
