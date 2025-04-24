library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Twinkle_Top is
    Port (
        clk : in STD_LOGIC;
        speaker_out : out STD_LOGIC
    );
end Twinkle_Top;

architecture Behavioral of Twinkle_Top is
    signal note_freq : INTEGER;
    signal note_duration : INTEGER;
    signal pwm_signal : STD_LOGIC;
    signal rom_addr : INTEGER range 0 to 15 := 0;
    signal timer : INTEGER := 0;
begin
    -- Instantiate Song ROM
    Song_ROM_inst : entity work.Song_ROM
        Port Map (
            clk => clk,
            addr => rom_addr,
            frequency => note_freq,
            duration => note_duration
        );

    -- Instantiate PWM Generator
    PWM_Generator_inst : entity work.PWM_Generator
        Port Map (
            clk => clk,
            frequency => note_freq,
            pwm_out => pwm_signal
        );

    -- Playback Controller
    process(clk)
    begin
        if rising_edge(clk) then
            if timer = (note_duration * 100000) then -- Convert ms to clock cycles
                timer <= 0;
                if rom_addr = 13 then
                    rom_addr <= 0; -- Loop back to the beginning
                else
                    rom_addr <= rom_addr + 1;
                end if;
            else
                timer <= timer + 1;
            end if;
        end if;
    end process;

    speaker_out <= pwm_signal; -- Connect PWM output to speaker
end Behavioral;
