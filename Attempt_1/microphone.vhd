library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mic_processor is
    Port (
        clk          : in  STD_LOGIC;  -- 25MHz clock input
        reset        : in  STD_LOGIC;
        pdm_data     : in  STD_LOGIC;  -- PDM microphone data input
        mic_data     : out STD_LOGIC_VECTOR(7 downto 0);
        sample_ready : out STD_LOGIC
    );
end mic_processor;

architecture Behavioral of mic_processor is
    signal pdm_acc : unsigned(15 downto 0) := (others => '0');
    signal pdm_counter : unsigned(7 downto 0) := (others => '0');
    signal data_sample : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal ready_flag : STD_LOGIC := '0';
    
begin
    -- PDM demodulation process
    process(clk, reset)
    begin
        if reset = '1' then
            pdm_acc <= (others => '0');
            pdm_counter <= (others => '0');
            data_sample <= (others => '0');
            ready_flag <= '0';
        elsif rising_edge(clk) then
            -- Accumulate PDM bits
            if pdm_data = '1' then
                pdm_acc <= pdm_acc + 1;
            end if;
            
            pdm_counter <= pdm_counter + 1;
            ready_flag <= '0';
            
            -- Generate a new 8-bit sample every 256 PDM bits
            if pdm_counter = 0 then
                data_sample <= std_logic_vector(pdm_acc(15 downto 8));
                pdm_acc <= (others => '0');
                ready_flag <= '1';
            end if;
        end if;
    end process;
    
    -- Output assignments
    mic_data <= data_sample;
    sample_ready <= ready_flag;
    
end Behavioral;
