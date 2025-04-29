library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_controller is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        song_state  : in  STD_LOGIC_VECTOR(1 downto 0);
        note_index  : in  STD_LOGIC_VECTOR(5 downto 0);
        tone_out    : in  STD_LOGIC;
        echo_enabled : in  STD_LOGIC;
        led_pattern : out STD_LOGIC_VECTOR(15 downto 0)
    );
end led_controller;

architecture Behavioral of led_controller is
    -- Song state constants
    constant STATE_IDLE    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant STATE_PLAYING : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant STATE_PAUSED  : STD_LOGIC_VECTOR(1 downto 0) := "10";
    
    -- Internal signals
    signal led_counter : unsigned(23 downto 0) := (others => '0');
    signal led_output : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
begin
    process(clk, reset)
    begin
        if reset = '1' then
            led_counter <= (others => '0');
            led_output <= (others => '0');
        elsif rising_edge(clk) then
            led_counter <= led_counter + 1;
            
            -- Update LED pattern at a visible rate
            if led_counter = 0 then
                case song_state is
                    when STATE_IDLE =>
                        led_output <= X"0000"; -- All off in idle
                    when STATE_PAUSED =>
                        led_output <= X"AAAA"; -- Alternating pattern when paused
                    when STATE_PLAYING =>
                        -- Light up LEDs according to note position
                        led_output <= (others => '0');
                        if unsigned(note_index) < 16 then
                            led_output(to_integer(unsigned(note_index))) <= '1';
                        else
                            led_output(to_integer(unsigned(note_index) mod 16)) <= '1';
                        end if;
                    when others =>
                        led_output <= X"0000";
                end case;
            end if;
            
            -- Status indicators
            led_output(15) <= echo_enabled;  -- Echo effect status
            led_output(14) <= tone_out;      -- Audio output visualization
        end if;
    end process;
    
    -- Output assignment
    led_pattern <= led_output;
    
end Behavioral;
