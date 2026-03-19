library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath_simon is
    port (
        clk, reset : in std_logic;
        inicio : in std_logic;
        sw : in std_logic_vector(1 downto 0); -- dificultad
        btn0, btn1, btn2 : in std_logic;
        control : in std_logic_vector(12 downto 0);
        entrada_valida: out std_logic;         
        entrada_jugador: out std_logic_vector(1 downto 0);
        timer : out std_logic;          -- tiempo agotado según dificultad
        equals_cont_5seg : out std_logic;          -- tiempo agotado 5 seg
        equals_cont_2seg : out std_logic;          -- tiempo agotado 2 seg
        contRand: out integer;
        display : out  STD_LOGIC_VECTOR (15 downto 0);
        leds : out std_logic_vector(15 downto 0)

    );
end datapath_simon;

architecture ARCH of datapath_simon is

    -- Componentes
    component contador is
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : in  std_logic;
            q   : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component contador3bits is
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : in  std_logic;
            q   : out std_logic_vector(2 downto 0)
        );
    end component;

    component divisor is
        port (
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC; 
            clk_salida05: out STD_LOGIC;
            clk_salidaRapido: out STD_LOGIC 
        
        
    );
    end component;
    
    component ganaRonda is
        port (
            clk: in std_logic;
            ce: in std_logic;
            q: out std_logic_vector(15 downto 0)
    );
    end component;
    
    component pierde is
        port (
            clk: in std_logic;
            ce: in std_logic;
            q: out std_logic_vector(15 downto 0)
    );
    
    end component;
    
    
    component gana is
        port (
            clk: in std_logic;
            ce: in std_logic;
            q: out std_logic_vector(15 downto 0)
    );
    end component;

    

    alias reset_contadorDif: std_logic is control(0);
    alias reset_contadorRapido: std_logic is control(1);
    alias reset_contador5seg: std_logic is control(2);
    alias enable_contadorDif : std_logic is control(3);
    alias enable_contadorRapido : std_logic is control(4);
    alias enable_contador5seg : std_logic is control(5);
    alias led0 : std_logic is control(6);
    alias led1 : std_logic is control(7);
    alias led2 : std_logic is control(8);
    alias led3 : std_logic is control(9);
    alias display0 : std_logic is control(10);
    alias display1 : std_logic is control(11);
    alias display2 : std_logic is control(12);

    -- Señales internas
    signal clk_lento : std_logic;
    signal clk_rapido : std_logic;
    signal cont_dificultad : std_logic_vector(3 downto 0);
    signal cont_rapido : std_logic_vector(2 downto 0);
    signal cont_5seg : std_logic_vector(3 downto 0);
    signal salida_Pierde : std_logic_vector(15 downto 0);
    signal salida_Gana : std_logic_vector(15 downto 0);
    signal salida_Gana_Ronda : std_logic_vector(15 downto 0);
    signal obj_contador : std_logic_vector(3 downto 0);


begin

    -- Divisor de reloj
    div_inst : divisor
        port map (
            rst => reset,
            clk_entrada => clk,
            clk_salida05 => clk_lento,
            clk_salidaRapido  => clk_rapido    -- 2 Hz
        );

    -- Contador
    cont5seg : contador
        port map (
            clk => clk_lento,
            rst => reset_contador5seg,
            ce  => enable_contador5seg,
            q   => cont_5seg
        );
        
    contDif : contador
        port map (
            clk => clk_lento,
            rst => reset_contadorDif,
            ce  => enable_contadorDif,
            q   => cont_dificultad
        );
        
    contRapido : contador3bits
        port map (
            clk => clk_rapido,
            rst => reset_contadorRapido,
            ce  => enable_contadorRapido,
            q   => cont_rapido
        );
        
    pierdeRonda : pierde
        port map (
            clk => clk,
            ce  => clk_lento,
            q   => salida_Pierde
        );
        
    ganaFinal : gana
        port map (
            clk => clk,
            ce  => clk_lento,
            q   => salida_Gana
        );
        
    gana_Ronda : ganaRonda
        port map (
            clk => clk,
            ce  => clk_lento,
            q   => salida_Gana_Ronda
        );

    -- Comparadores
    
    contRand <= to_integer(unsigned(cont_rapido));
    
    process(btn0, btn1, btn2)
        begin
            entrada_jugador <= "00";
            entrada_valida <= '0';
            if btn0 = '1' then
                entrada_jugador <= "00";
                entrada_valida <= '1';
            elsif btn1 = '1' then
                entrada_jugador <= "01";
                entrada_valida <= '1';
            elsif btn2 = '1' then
                entrada_jugador <= "10";
                entrada_valida <= '1';
            end if;
        end process;
    
    with sw select
    obj_contador <= "1000" when "00", -- 2 s
                     "0101" when "01", -- 1,5 seg
                     "0010" when "10", -- 1 s
                     "0001" when "11", -- 0,5 s
                     "0100" when others;



    process (cont_dificultad, cont_5seg)
    begin
        if cont_dificultad = obj_contador then
            timer <= '1';    -- cont con dificultad
        else
            timer <= '0';
        end if;

        if cont_5seg = "1000" then
            equals_cont_5seg <= '1';    -- cont 5 seg
        else
            equals_cont_5seg <= '0';
        end if;
        
        if cont_5seg = "0100" then
            equals_cont_2seg <= '1';    -- cont 5 seg
        else
            equals_cont_2seg <= '0';
        end if;
    end process;


    -- Selección de LEDs
    process(control, cont_rapido, salida_Gana, salida_Pierde, salida_Gana_Ronda)
        begin
            case control(9 downto 6) is
                when "0000" =>
                    leds <= "0000000000000001";
                when "0001" =>
                    leds <= "0000000000000010";
                when "0010" =>
                    leds <= "0000000000000100";
                when "0011" =>
                    leds <= "1111111111111111";
                when "0100" =>
                    leds <= salida_Gana_Ronda;
                when "0101" =>
                    leds <= salida_Pierde;
                when "0110" =>
                    leds <= salida_Gana;
                when "0111" =>
                    leds(15 downto 10) <= (others => cont_rapido(2)); -- los 5 bits altos
                    leds(9 downto 5) <= (others => cont_rapido(1)); -- los 5 bits altos
                    leds(4 downto 0)  <= (others => cont_rapido(0)); -- los 5 bits bajos
                when "1000" =>
                    leds <= "0000000000000001";
                when "1001" =>
                    leds <= "0000000000000011";
                when "1010" =>
                    leds <= "0000000000000111";
                when "1011" =>
                    leds <= "0000000000000000";
                    
                when others =>
                    leds <= (others => '0');
            end case;
        end process; 
    
    
    
                
     with control(12 downto 10) select
      display <= 
               "0000000100100011" when "000", -- lose
               "0100010101100101" when "001", -- gana
               "0111010100100101" when "010", --pasa
               "1000100100110100" when "011", -- jueg
               "1011100100110110" when "100", -- cuen
               "1100110111001101" when "101", -- o abajo o arriba
               "1101110011011100" when "110", -- o arriba o abajo
               "1010010100000011" when "111", -- vale
               "011001011000" when others;

end ARCH;
