library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador is
    port(
        clk   : in std_logic;
        rst   : in std_logic;
        ce    : in std_logic;
        q     : out std_logic_vector(3 downto 0)
    );
end;

architecture beh of contador is
    signal count : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count <= (others => '0');
        elsif rising_edge(clk) then
            if ce = '1' then
                if count = 9 then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    q <= std_logic_vector(count);
end architecture;