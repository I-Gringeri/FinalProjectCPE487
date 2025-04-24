library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_Generator is
    Port (
        clk : in STD_LOGIC;
        frequency : in INTEGER;
        pwm_out : out STD_LOGIC
    );
end PWM_Generator;

architecture Behavioral of PWM_Generator is
    signal counter : INTEGER := 0;
    signal toggle : STD_LOGIC := '0';
    signal period : INTEGER;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            period <= 100000000 / frequency; -- Calculate period (assuming 100 MHz clock)
            if counter = period / 2 then
                toggle <= not toggle;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
        pwm_out <= toggle;
    end process;
end Behavioral;
