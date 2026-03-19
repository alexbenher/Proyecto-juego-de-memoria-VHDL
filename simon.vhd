

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;



ENTITY simon IS
    PORT (
        rst : IN std_logic;
        clk : IN std_logic;
        inicio : IN std_logic;
        fin: IN std_logic;
        sw: in std_logic_vector(1 downto 0);
        btn0, btn1, btn2 : in std_logic;
        display : out  STD_LOGIC_VECTOR (15 downto 0);
        leds: OUT std_logic_vector (15 DOWNTO 0)
    );
END simon;

architecture Behavioral of simon is



    component datapath_simon
    port(  
        clk, reset : in std_logic;
        inicio : in std_logic;
        sw : in std_logic_vector(1 downto 0); -- dificultad
        btn0, btn1, btn2 : in std_logic;
        control : in std_logic_vector(12 downto 0);
        entrada_valida: out std_logic;         
        entrada_jugador: out std_logic_vector(1 downto 0);
        timer : out std_logic;          -- tiempo agotado según dificultad
        equals_cont_5seg : out std_logic;          -- tiempo agotado según dificultad
        equals_cont_2seg : out std_logic;          -- tiempo agotado según dificultad
        contRand: out integer;
        display : out  STD_LOGIC_VECTOR (15 downto 0);
        leds : out std_logic_vector(15 downto 0)
        );
    end component;
    
        
    component controlador_simon
        port( 
            clk: in std_logic;               -- reloj principal
            reset: in std_logic;             -- reset global
            inicio: in std_logic;            -- inicio del juego
            fin: in std_logic;            -- fin
            entrada_valida: in std_logic;         
            entrada_jugador: in std_logic_vector(1 downto 0);
            contRand: in integer;    
            equals_cont_5seg: in std_logic;
            equals_cont_2seg: in std_logic;
            timer: in std_logic;       -- pulso de 0.5 s para mostrar LED
            control: out std_logic_vector(12 downto 0)  -- salidas a datapath
        );
        end component;
        
    signal aux_timer : std_logic;
    signal equals_cont5seg : std_logic;
    signal equals_cont2seg : std_logic;
    signal entradaValida : std_logic;
    signal aux_control : std_logic_vector(12 downto 0);
    signal leds_salida : std_logic_vector(15 downto 0);        
    signal clk_random_aux: integer;        -- pulso rápido para generar random
    signal entradaJugador_aux : std_logic_vector(1 downto 0);
    signal verificar_aux      : std_logic;

        
        
    begin
    
    
    
    controlador: controlador_simon
    port map( 
        clk => clk,
        reset => rst,
        inicio => inicio,
        fin => fin,
        entrada_valida => entradaValida,
        entrada_jugador => entradaJugador_aux,
        contRand => clk_random_aux,
        equals_cont_5seg => equals_cont5seg,
        equals_cont_2seg => equals_cont2seg,
        timer => aux_timer,
        control => aux_control
    );


    datapath: datapath_simon
    port map(
        clk => clk,
        reset => rst,
        inicio => inicio,
        sw => sw,        
        btn0 => btn0,
        btn1 => btn1,
        btn2 => btn2,
        control => aux_control,
        entrada_valida => entradaValida,
        entrada_jugador => entradaJugador_aux,
        timer => aux_timer,
        equals_cont_5seg => equals_cont5seg,
        equals_cont_2seg => equals_cont2seg,
        contRand => clk_random_aux,
        display => display,
        leds => leds
    );

                




end Behavioral;









