library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

ENTITY DataInBuffert IS
  PORT (in_en : IN std_logic;
        data_in : IN data_word;
        data_out : OUT data_bus);
END ENTITY DataInBuffert; 

ARCHITECTURE RTL OF DataInBuffert IS
begin
databuf:process(in_en, data_in)
begin
  if(in_en = '1') then
    data_out <= data_in;
  else
    data_out <= (others=>'Z');
  end if;
end process databuf;
end RTL;

