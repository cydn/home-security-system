library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity home_security is
    Port ( Door_Sensor : in STD_LOGIC;
           Fire_Sensor : in STD_LOGIC;
           KeyPad : in STD_LOGIC_VECTOR (2 downto 0);
           CLK : in STD_LOGIC;
           Timer_OSC : in STD_LOGIC;
           Alarm_Siren : out STD_LOGIC;
           Door_Open : out STD_LOGIC);
end home_security;

architecture Behavioral of home_security is
    type state_type is (Dis_Armed, Armed, Door_Wait, Fire_Alarm);
    signal state,  NextState : state_type; 
    signal Delay_Counter : integer := 0;

begin
    Registers: process (CLK)
    begin
       if clk'event = TRUE and clk = '1' then
          if (KeyPad(2) = '1') then
             state <= Dis_Armed;
          else
              state <= NextState;    
          end if;        
          if state = Door_Wait and Door_Sensor ='0' and Fire_Sensor = '0' and Delay_Counter <=15 then
              Delay_Counter <= Delay_Counter + 1;
          else
               Delay_Counter <= 0;  
          end if;    
       end if;
     end process;

    C_logic: process (state, Door_Sensor , Fire_Sensor, KeyPad, Timer_OSC)
    begin
       
    NextState <= state;  
      case (state) is 
         when Dis_Armed =>
             Alarm_Siren <= '0';
             Door_Open <= '0';
             if KeyPad(1) = '1' then
                 NextState <= Armed ;
             else 
                 NextState <= state;
             end if;
         when Armed =>
             Alarm_Siren <= '0';
             Door_Open <= '0';
             if Keypad(2) = '1' then
                NextState <= Dis_Armed;
             elsif Fire_Sensor = '1' then
                NextState <= Fire_Alarm;
             elsif Door_Sensor = '1' then
                 NextState <= Door_Wait;
             else 
                 NextState <= state;
             end if ;
         when Door_Wait =>
             Alarm_Siren <= '0';
             if Keypad(2) = '1' then
                 Door_Open <= '0';
                 NextState <= Dis_Armed;
             elsif Fire_Sensor = '1' then
                 Door_Open <= '0';
                 NextState <= Fire_Alarm;
             elsif Door_Sensor = '1' then
                 NextState <= state;
             elsif KeyPad(0) = '1'  then
                 Door_Open <= '1';
                 NextState <= Armed;
             elsif Door_Sensor = '0' and Fire_Sensor = '0' and Delay_Counter = 15 then
                 Door_Open <= '0';
                 NextState <= Armed;
             end if;
         when Fire_Alarm =>
             Alarm_Siren <= '1';
             Door_Open <= '1';
             if KeyPad(2) = '1' then
                 NextState <= Dis_Armed ;
             else 
                 NextState <= state ;
             end if;  
         end case;
      end process;
end Behavioral;