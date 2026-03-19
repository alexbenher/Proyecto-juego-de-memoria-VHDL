
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlador_simon is
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
end controlador_simon;


architecture ARCH of controlador_simon is

    constant MAX_NIVELES : integer := 1;
        type vector6bits is array (0 to 7) of std_logic_vector(5 downto 0);
        constant secuencias : vector6bits := (
            0 => "000110",
            1 => "100001",
            2 => "011001",
            3 => "000010", 
            4 => "101010",
            5 => "000001",
            6 => "010100",
            7 => "100100"            
        );
        
    type STATES is (S0, S1, S2_PRE, S2, S3, S4, S5, S6, S7, S8); --Define the states here
        signal STATE, NEXT_STATE: STATES;
        signal nivel, nivel_next: integer := 0;
        signal secuencia, secuencia_next: std_logic_vector (5 downto 0);
        signal indice, indice_next: integer;
        signal aux_indice: integer;
        
        signal control_aux: std_logic_vector(12 downto 0);
        alias reset_contadorDif: std_logic is control_aux(0);
        alias reset_contadorRapido: std_logic is control_aux(1);
        alias reset_contador5seg: std_logic is control_aux(2);
        alias enable_contadorDif : std_logic is control_aux(3);
        alias enable_contadorRapido : std_logic is control_aux(4);
        alias enable_contador5seg : std_logic is control_aux(5);
        alias led0 : std_logic is control_aux(6);
        alias led1 : std_logic is control_aux(7);
        alias led2 : std_logic is control_aux(8);
        alias led3 : std_logic is control_aux(9);
        alias display0 : std_logic is control_aux(10);
        alias display1 : std_logic is control_aux(11);
        alias display2 : std_logic is control_aux(12);
        
        
        
        
begin
--SECUENCIAL
SYNC: process (clk, reset)
begin
    if reset = '1' then
        STATE <= S0;
        nivel <= 0;
        indice <= 0;
        secuencia <= "000000";
    elsif rising_edge(clk) then
        STATE <= NEXT_STATE;
        nivel <= nivel_next;
        indice <= indice_next;
        secuencia <= secuencia_next;
    end if;
end process SYNC;

--COMBINACIONAL
COMB: process (STATE, inicio, fin, entrada_jugador, timer, equals_cont_5seg, nivel)

    begin
    
        NEXT_STATE <= STATE;
        nivel_next <= nivel;
        indice_next <= indice;
        secuencia_next <= secuencia;
        -- Salidas combinacionales
        display0 <= '1';
        display1 <= '1';
        display2 <= '0';
        led0 <= '1';
        led1 <= '1';
        led2 <= '0';
        led3 <= '1';
        enable_contadorDif <= '0';
        enable_contadorRapido <= '0';
        enable_contador5seg <= '0';
        reset_contadorDif <= '0';
        reset_contador5seg <= '0';
        reset_contadorRapido <= '0';
                        
                          
        case STATE is
      
        when S0 =>
            led0 <= '0';  led1 <= '0';  led2 <= '1';  led3 <= '0'; 
            display0 <= '1'; display1 <= '1'; display2 <= '0';
            reset_contadorDif <= '1';
            reset_contadorRapido <= '1';
            reset_contador5seg <= '1';
            nivel_next <= 0;
            indice_next <= 0;
            if inicio = '1' then
                NEXT_STATE <= S1;
            end if;
        
        when S1 => 
            display0 <= '0';
            display1 <= '0';
            display2 <= '1';
            enable_contadorRapido <= '1';
            led0 <= '1';
            led1 <= '1';
            led2 <= '1';
            led3 <= '0';
            if fin = '1' then
                secuencia_next <= secuencias(contRand);
                NEXT_STATE <= S2_PRE;
            else NEXT_STATE <= S1;
            end if;
            
        when S2_PRE =>
            reset_contadorDif <= '1';   
            indice_next <= indice;      
            NEXT_STATE <= S2;
        
        when S2 =>
            display0 <= '1';
            display1 <= '0';
            display2 <= '1';
            enable_contadorDif <= '1';
            case secuencia((indice*2) + 1 downto indice*2) is
                when "00" => led0 <= '0' ;
                             led1 <= '0';
                             led2 <= '0';
                             led3 <= '0';
                when "01" => led0 <= '1' ;
                             led1 <= '0';
                             led2 <= '0';
                             led3 <= '0';
                when "10" => led0 <= '0' ;
                             led1 <= '1';
                             led2 <= '0';
                             led3 <= '0';
                when others => led0 <= '0' ;
                             led1 <= '0';
                             led2 <= '0';
                             led3 <= '0';
            end case;
            if timer = '1' then
                indice_next <= indice;
                NEXT_STATE <= S3;
            else NEXT_STATE <= S2;
            end if;

        when S3 =>
            led0 <= '1';
            led1 <= '1';
            led2 <= '0';
            led3 <= '1';
            enable_contadorDif <= '0';
            display0 <= '0'; display1 <= '1'; display2 <= '1';
            
            if indice = 2 then
                indice_next <= 0;
                NEXT_STATE <= S4;
            elsif fin = '1' then
                indice_next <= indice + 1;
                NEXT_STATE <= S2_PRE;
            end if;
        
        when S4 =>
            enable_contador5seg <= '1';
            indice_next <= 0;
            display0 <= '0';
            display1 <= '1';
            display2 <= '0';
            led0 <= '1' ;
            led1 <= '1';
            led2 <= '0';
            led3 <= '0';
            if  equals_cont_2seg = '1' then
                NEXT_STATE <= S5;
            else NEXT_STATE <= S4;
            end if;
            
        when S5 =>
        display0 <= '1';
        display1 <= '1';
        display2 <= '1';
        if indice = 0 then
                    led0 <= '0' ;
                    led1 <= '0';
                    led2 <= '0';
                    led3 <= '1';
                elsif indice = 1 then
                    led0 <= '1' ;
                    led1 <= '0';
                    led2 <= '0';
                    led3 <= '1';
                else 
                    led0 <= '0' ;
                    led1 <= '1';
                    led2 <= '0';
                    led3 <= '1';
                end if;
            if entrada_valida = '1' then 
                if entrada_jugador = secuencia((indice*2) + 1 downto indice*2) then
                    indice_next <= indice + 1;
                    if indice = 2 then
                        indice_next <= 0;
                        reset_contador5seg <= '1';
                        NEXT_STATE <= S6;
                    else 
                        NEXT_STATE <= S5;
                    end if;
                else 
                    indice_next <= 0;
                    NEXT_STATE <= S7; 
                end if;   
            else NEXT_STATE <= S5;
            end if;    
           

        when S6 =>
            reset_contador5seg <= '0';
            led0 <= '0' ;
            led1 <= '1';
            led2 <= '1';
            led3 <= '0';
            display0 <= '1';
            display1 <= '0';
            display2 <= '0';
            nivel_next <= nivel + 1;
            enable_contador5seg <= '1';
            if equals_cont_2seg = '1' then
                if nivel >= MAX_NIVELES then
                    NEXT_STATE <= S8;  -- Ganó todo
                else 
                    NEXT_STATE <= S0;  -- Siguiente nivel
                end if;
            else NEXT_STATE <= S6;
            end if;

        when S7 =>
            reset_contador5seg <= '0';
            led0 <= '1' ;
            led1 <= '0';
            led2 <= '1';
            led3 <= '0';
            display0 <= '0';
            display1 <= '0';
            display2 <= '0';
            enable_contador5seg <= '1';
            
            if equals_cont_2seg = '1' then
                NEXT_STATE <= S0;
            end if;
        
        when S8 => 
            led0 <= '0' ;
            led1 <= '1';
            led2 <= '1';
            led3 <= '0';
            display0 <= '1';
            display1 <= '0';
            display2 <= '0';
            enable_contador5seg <= '1';
            
            if equals_cont_5seg = '1' then
                NEXT_STATE <= S0;
            end if;
            
    end case;

end process COMB;

control <= control_aux;

end ARCH;













