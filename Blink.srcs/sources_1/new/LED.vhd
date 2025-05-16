library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED is
    Port ( 
        clk : in std_logic;
        led : out std_logic
    );
end LED;

architecture Behavioral of LED is
signal count : integer := 0;

begin

    process (clk)
        begin
        if (rising_edge(clk)) then
            count <= count + 1;
            
            if (count < 100000000) then
                led <= '1';
            elsif (count = 200000000) then
                count <= 0;
                led <= '1';
            else
                led <= '0';
            end if;
        end if;
    end process;

end Behavioral;
