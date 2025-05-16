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
    
    component ila_0 is
        port (
            clk : in std_logic;
            probe0 : in std_logic_vector(0 downto 0);
            probe1 : in std_logic_vector(0 downto 0);
            probe2 : in std_logic_vector(0 downto 0)
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
        
        inst_scope: ila_0 port map (
            clk => clk,
            probe0(0) => enable,
            probe1(0) => rst,
            probe2(0) => switch        
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
