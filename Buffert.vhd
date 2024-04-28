library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

ENTITY DataBuffert IS
  PORT (out_en : IN std_logic;
        data_in : IN data_word;
        data_out : OUT data_bus
        );
END ENTITY DataBuffert; 

ARCHITECTURE RTL OF DataBuffert IS
 
begin
  data_out <= (others => 'Z') when out_en = '0' else data_in;
end RTL;




