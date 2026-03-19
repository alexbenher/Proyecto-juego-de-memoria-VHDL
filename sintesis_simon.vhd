LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;


ENTITY sintesis_simon IS
  PORT (
    rst			: IN  std_logic;
    clk			: IN  std_logic;
    boton_inicio		: IN  std_logic;
    boton_fin		: IN  std_logic;
    sw0, sw1: in std_logic;
    boton0, boton1, boton2 : in std_logic;
    display_salida		: OUT std_logic_vector (6 DOWNTO 0);
    leds			: OUT std_logic_vector (15 DOWNTO 0);
    s_display	: OUT std_logic_vector (3 DOWNTO 0)
  );
END sintesis_simon;

ARCHITECTURE simonArch OF sintesis_simon IS

    COMPONENT simon IS
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
    END COMPONENT;

  COMPONENT debouncer
    PORT (
      rst: IN std_logic;
      clk: IN std_logic;
      x: IN std_logic;
      xDeb: OUT std_logic;
      xDebFallingEdge: OUT std_logic;
      xDebRisingEdge: OUT std_logic
    );
  END COMPONENT;
   
 component displays is
    Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
     );
end component;

  
  SIGNAL s_displays : std_logic_vector (3 DOWNTO 0);
  SIGNAL sal_display : std_logic_vector (15 DOWNTO 0);
  SIGNAL inicio, fin: std_logic;
  SIGNAL btn0,btn1,btn2: std_logic;
  signal  digito0, digito1, digito2, digito3: std_logic_vector (3 DOWNTO 0);
  signal reset_n:  std_logic;
  signal sw_aux: std_logic_vector(1 downto 0);

BEGIN
    reset_n <= not rst;
    sw_aux(0) <= sw0;
    sw_aux(1) <= sw1;
    digito0 <= sal_display(3 downto 0);
    digito1 <= sal_display(7 downto 4);
    digito2 <= sal_display(11 downto 8);
    digito3 <= sal_display(15 downto 12);

debouncerInsts_displayce1: debouncer PORT MAP (reset_n, clk, boton_fin,open, open, fin);
debouncerInsts_displayce2: debouncer PORT MAP (reset_n, clk, boton0,open, open, btn0);
debouncerInsts_displayce3: debouncer PORT MAP (reset_n, clk, boton1,open, open, btn1);
debouncerInsts_displayce4: debouncer PORT MAP (reset_n, clk, boton2,open, open, btn2);
debouncerInsts_displayce5: debouncer PORT MAP (reset_n, clk, boton_inicio,open, open, inicio);
simonInsts_displayce : simon PORT MAP (rst, clk, inicio, fin, sw_aux,btn0, btn1, btn2, sal_display, leds);


displays_inst:  displays PORT MAP (rst,clk,digito0,digito1,digito2,digito3, display_salida, s_display);
  
END simonArch;
