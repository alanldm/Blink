library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
    generic (N: integer := 0);
    Port ( 
        enable : in std_logic;
        rst : in std_logic;
        clk : in std_logic;
        tick : out std_logic
    );
end counter;

architecture Behavioral of counter is
    signal auxiliar : integer := 0;
    
    begin
    
    process(clk)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    auxiliar <= 0;
                else
                    if (enable = '1') then
                        auxiliar <= auxiliar + 1;
                        
                        if (auxiliar = N) then
                            tick <= '1';
                            auxiliar <= 0;
                        else
                            tick <= '0';
                        end if;
                    end if;
                end if;
            end if;
            
    end process;
end Behavioral;
