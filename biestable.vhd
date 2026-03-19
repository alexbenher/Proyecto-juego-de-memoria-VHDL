library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gana is
port(
    clk: in std_logic;
    ce: in std_logic;
    q: out std_logic_vector(15 downto 0)
    );
end gana;

architecture Behavioral of gana is

signal reg : std_logic_vector(15 downto 0) := "0101010101010101";

begin

    process(clk)
    begin
        if rising_edge(clk) THEN
            if ce = '1' THEN
                reg <= NOT reg;
           end if;
        end if;
    end process;
    
q <= reg;

end Behavioral;





