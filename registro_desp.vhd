library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ganaRonda is
port(
    clk: in std_logic;
    ce: in std_logic;
    q: out std_logic_vector(15 downto 0)
    );
end ganaRonda;

architecture Behavioral of ganaRonda is

signal reg : std_logic_vector(15 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) THEN
            if ce = '1' THEN
                reg(15) <= NOT REG(0);
                reg (14 downto 0) <= reg(15 downto 1);
            end if;
        end if;
    end process;
    
q <= reg;

end Behavioral;





