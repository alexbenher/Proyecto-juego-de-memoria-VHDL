----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida05: out STD_LOGIC; -- reloj que se utiliza en los process del programa principal
        clk_salidaRapido: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
        
        
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(25 downto 0);
 SIGNAL cuentaRapida: std_logic_vector(25 downto 0);
 SIGNAL clk_aux_05: std_logic;
 SIGNAL clk_aux_rapido: std_logic;

  
begin
clk_salida05<=clk_aux_05;
clk_salidaRapido<=clk_aux_rapido;

  
  contador05seg: -- contador
  PROCESS(rst, clk_entrada)
  BEGIN
    IF (rst='1') THEN
      cuenta<= (OTHERS=>'0');
      clk_aux_05<='0';
    ELSIF(rising_edge(clk_entrada)) THEN
      IF (cuenta="01011101011011010100000000") THEN 
      	clk_aux_05 <= '1';
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
	   clk_aux_05<='0';
      END IF;
    END IF;
  END PROCESS contador05seg;
  
  contadorRapido:
  PROCESS(rst, clk_entrada)
  BEGIN
    IF (rst='1') THEN
      cuentaRapida<= (OTHERS=>'0');
      clk_aux_rapido<='0';
    ELSIF(rising_edge(clk_entrada)) THEN
      IF (cuentaRapida="01000010011011010100000000") THEN 
      	clk_aux_rapido <= '1';
        cuentaRapida<= (OTHERS=>'0');
      ELSE
        cuentaRapida <= cuentaRapida+'1';
	   clk_aux_rapido<='0';
      END IF;
    END IF;
  END PROCESS contadorRapido;

end divisor_arch;
