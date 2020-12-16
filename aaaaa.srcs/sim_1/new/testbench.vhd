library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
component home_security
    Port ( Door_Sensor : in STD_LOGIC;
           Fire_Sensor : in STD_LOGIC;
           KeyPad : in STD_LOGIC_VECTOR (2 downto 0);
           CLK : in STD_LOGIC;
           Timer_OSC : in STD_LOGIC;
           Alarm_Siren : out STD_LOGIC;
           Door_Open : out STD_LOGIC);
end component; 
signal clk, fire, door, alarm, door_open: STD_LOGIC;
signal keypad: STD_LOGIC_VECTOR (2 downto 0);
begin
    uut: home_security port map (Door_Sensor => door, Fire_Sensor => fire, KeyPad => keypad,CLK => clk, Timer_OSC => clk, Alarm_Siren => alarm, Door_Open => door_open);
    process
    begin
        clk <= '0';
        wait for 2.5 ns;
        clk <= '1';
        wait for 2.5 ns;
    end process;
    
    process
    begin
        keypad(2) <= '0';
        wait for 5 ns;
        keypad(2) <= '1';
        wait for 5 ns;
        keypad(2) <= '0';
        wait for 200 ns;
        keypad(2) <= '1';
        wait for 5 ns;
        keypad(2) <= '0';
        wait;
    end process;
    
    process
    begin
        keypad(1) <= '0';
        wait for 15 ns;
        keypad(1) <= '1';
        wait for 5 ns;
        keypad(1) <= '0';
        wait;     
    end process;

    process
    begin
        keypad(0) <= '0';
        wait for 35 ns;
        keypad(0) <= '1';
        wait for 5 ns;
        keypad(0) <= '0';
        wait;
    end process;
    
    process 
    begin
        door <= '0';
        wait for 25 ns;
        door <= '1';
        wait for 5 ns;
        door <= '0';
        wait for 50 ns;
        door <= '1';
        wait for 5 ns;
        door <= '0';
        wait for 100 ns;
        door <= '1';
        wait for 10 ns;
        door <= '0';
        wait;
    end process;
    
    process 
    begin
        fire <= '1';
        wait for 10 ns;
        fire <= '0';
        wait for 175 ns;
        fire <= '1';
        wait for 5 ns;
        fire <= '0';
        wait;
    end process;
end Behavioral;
