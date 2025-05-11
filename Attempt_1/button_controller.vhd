library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_controller is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        btn_in       : in  STD_LOGIC_VECTOR(3 downto 0);
        btn_debounced : out STD_LOGIC_VECTOR(3 downto 0)
    );
end button_controller;

architecture Behavioral of button_controller is
    -- Button debouncing
    type debounce_counter_array is array(0 to 3) of unsigned(19 downto 0);
    signal debounce_counter : debounce_counter_array := (others => (others => '0'));
    signal debounced_state : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin
    -- Button debouncing process
    process(clk, reset)
    begin
        if reset = '1' then
            debounce_counter <= (others => (others => '0'));
            debounced_state <= (others => '0');
            btn_debounced <= (others => '0');
        elsif rising_edge(clk) then
            for i in 0 to 3 loop
                if btn_in(i) = '1' then
                    if debounce_counter(i) < X"FFFF0" then
                        debounce_counter(i) <= debounce_counter(i) + 1;
                    end if;
                else
                    debounce_counter(i) <= (others => '0');
                end if;
                
                if debounce_counter(i) = X"FFFF0" then
                    debounced_state(i) <= '1';
                else
                    debounced_state(i) <= '0';
                end if;
            end loop;
            
            btn_debounced <= debounced_state;
        end if;
    end process;
end Behavioral;
