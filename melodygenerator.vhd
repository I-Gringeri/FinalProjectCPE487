library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MelodyGenerator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           play : in STD_LOGIC;
           tone_out : out STD_LOGIC);
end MelodyGenerator;

architecture Behavioral of MelodyGenerator is
    type state_type is (SILENT, NOTE_C, NOTE_G, NOTE_A, NOTE_F, NOTE_E, NOTE_D);
    signal current_state, next_state : state_type;
    signal counter : INTEGER := 0;
    signal tone : STD_LOGIC := '0';

    constant C_FREQ : INTEGER := 500000; -- Adjust for desired frequency
    constant G_FREQ : INTEGER := 400000;
    constant A_FREQ : INTEGER := 350000;
    constant F_FREQ : INTEGER := 450000;
    constant E_FREQ : INTEGER := 300000;
    constant D_FREQ : INTEGER := 250000;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= SILENT;
            counter <= 0;
            tone <= '0';
        elsif rising_edge(clk) then
            if play = '1' then
                current_state <= next_state;
                if counter = C_FREQ then
                    tone <= not tone;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                current_state <= SILENT;
                tone <= '0';
            end if;
        end if;
    end process;

    process(current_state)
    begin
        case current_state is
            when SILENT =>
                next_state <= NOTE_C;
            when NOTE_C =>
                next_state <= NOTE_G;
            when NOTE_G =>
                next_state <= NOTE_A;
            when NOTE_A =>
                next_state <= NOTE_F;
            when NOTE_F =>
                next_state <= NOTE_E;
            when NOTE_E =>
                next_state <= NOTE_D;
            when NOTE_D =>
                next_state <= NOTE_C;
        end case;
    end process;

    tone_out <= tone;
end Behavioral;
