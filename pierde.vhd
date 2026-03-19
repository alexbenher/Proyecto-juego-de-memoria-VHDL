


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pierde is
port(
    clk: in std_logic;
    ce: in std_logic;
    q: out std_logic_vector(15 downto 0)
    );
end pierde;

architecture Behavioral of pierde is

signal reg : std_logic_vector(15 downto 0) := "0000000011111111";

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





