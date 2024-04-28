library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

entity OutBuffert is
    port(clk : IN std_logic;
        OUT_EN : IN std_logic;
        DATA_IN : IN data_word;
        DATA_OUT : OUT data_bus);
end entity OutBuffert;

architecture RTL of OutBuffert is
  signal buf_register : data_bus := (others => '0');
    begin
      DATA_OUT <= buf_register;
      outBuff:process(clk)
      begin
        if(rising_edge(clk)) then
          if(OUT_EN = '0') then
            buf_register <= DATA_IN;
          end if;
        end if;
      end process outBuff;
end RTL;

