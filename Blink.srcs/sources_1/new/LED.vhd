library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED is
    generic (
        seconds : natural := 1;
        frequence : natural := 100000000
    );
    Port (
        enable : in std_logic;
        rst : in std_logic; 
        clk : in std_logic;
        led : out std_logic
    );
end LED;

architecture Behavioral of LED is
    component counter is
        generic (N: integer := 0);
        Port ( 
            enable : in std_logic;
            rst : in std_logic;
            clk : in std_logic;
            tick : out std_logic
        );
    end component;
    
    signal switch : std_logic := '0';
    signal tick_s : std_logic;

    begin
    
        inst_counter : counter generic map (seconds * frequence) port map (
            enable => enable,
            rst => rst,
            clk => clk,
            tick => tick_s
        );

        process (clk)
            begin
            if (rising_edge(clk)) then
                if (tick_s = '1') then
                    switch <= not switch;
                end if;
            end if;
        end process;
        
        led <= switch;
end Behavioral;
