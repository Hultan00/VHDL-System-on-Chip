library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.CPU_Package.all;
use work.all;

entity Testbench_Controller_and_ROM is
end Testbench_Controller_and_ROM;

architecture Testbench of Testbench_Controller_and_ROM is
  
  component enchip
    port (
      clk : in std_logic; -- fast clock
      reset : in std_logic; -- active high
      stop : in std_logic; -- stops statemachine clk
      choice : in std_logic; -- address(=0) or data(=1)
      data_in : in data_bus;
      peek_LEDs : OUT data_bus;
      Q : out data_bus
    );
  end component;
  
  signal CLK_EC : std_logic := '0';
  signal RESET_EC : std_logic;
  signal STOP_EC : std_logic := '0';
  signal CHOICE_EC : std_logic := '0';
  signal DATA_IN_EC : data_bus := "10000000";
  signal PEEK_LEDS_EC : data_bus;
  signal Q_EC : data_bus;
  
begin
  
  C1: enchip
    port map (
      clk => CLK_EC,
      reset => RESET_EC,
      stop => STOP_EC,
      choice => CHOICE_EC,
      data_in => DATA_IN_EC,
      peek_LEDs => PEEK_LEDS_EC,
      Q => Q_EC
    );
    
  CLK_EC <= not(CLK_EC) after 10 ns; 
  
  CHOICE_EC <= not(CHOICE_EC) after 200 ns;
  
  STOP_EC <= not(STOP_EC) after 2500 ns;
    
  process
    begin
      RESET_EC <= '1';
      wait for 100 ns;
      RESET_EC <= '0';
      wait;
  end process;
end Testbench;
