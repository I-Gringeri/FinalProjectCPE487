library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KaraokeMachine is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           play_pause : in STD_LOGIC;
           restart : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           rgb : out STD_LOGIC_VECTOR(2 downto 0);
           tone_out : out STD_LOGIC);
end KaraokeMachine;

architecture Behavioral of KaraokeMachine is
    signal tone : STD_LOGIC;
    signal state : STD_LOGIC_VECTOR(1 downto 0);

    component ToneGenerator
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               tone_out : out STD_LOGIC);
    end component;

    component ButtonControl
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               play_pause : in STD_LOGIC;
               restart : in STD_LOGIC;
               state : out STD_LOGIC_VECTOR(1 downto 0));
    end component;

    component VGA_Controller
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               hsync : out STD_LOGIC;
               vsync : out STD_LOGIC;
               rgb : out STD_LOGIC_VECTOR(2 downto 0));
    end component;

    component MelodyGenerator
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               play : in STD_LOGIC;
               tone_out : out STD_LOGIC);
    end component;

begin
    ToneGen: ToneGenerator
        Port map ( clk => clk,
                   reset => reset,
                   tone_out => tone);

    ButtonCtrl: ButtonControl
        Port map ( clk => clk,
                   reset => reset,
                   play_pause => play_pause,
                   restart => restart,
                   state => state);

    VGA: VGA_Controller
        Port map ( clk => clk,
                   reset => reset,
                   hsync => hsync,
                   vsync => vsync,
                   rgb => rgb);

    MelodyGen: MelodyGenerator
        Port map ( clk => clk,
                   reset => reset,
                   play => play_pause,
                   tone_out => tone);

    tone_out <= tone;
end Behavioral;
