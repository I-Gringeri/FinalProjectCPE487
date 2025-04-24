library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ButtonControl is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           play_pause : in STD_LOGIC;
           restart : in STD_LOGIC;
           state : out STD_LOGIC_VECTOR(1 downto 0));
end ButtonControl;

architecture Behavioral of ButtonControl is
    type state_type is (IDLE, PLAY, PAUSE);
    signal current_state, next_state : state_type;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, play_pause, restart)
    begin
        case current_state is
            when IDLE =>
                if play_pause = '1' then
                    next_state <= PLAY;
                else
                    next_state <= IDLE;
                end if;
            when PLAY =>
                if play_pause = '1' then
                    next_state <= PAUSE;
                elsif restart = '1' then
                    next_state <= IDLE;
                else
                    next_state <= PLAY;
                end if;
            when PAUSE =>
                if play_pause = '1' then
                    next_state <= PLAY;
                elsif restart = '1' then
                    next_state <= IDLE;
                else
                    next_state <= PAUSE;
                end if;
        end case;
    end process;

    state <= std_logic_vector(to_unsigned(current_state, state'length));
end Behavioral;
