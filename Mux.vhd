library IEEE;
use IEEE.std_logic_1164.all;
use work.CPU_Package.all;
use ieee.numeric_std.all;
use std.STANDARD.BOOLEAN;

Entity Multiplexer is  
   Port(  
      Sel : IN std_logic_vector(1 downto 0);
      Data_in_3: IN data_word;  
      Data_in_2 : IN data_word;  
      Data_in_1 : IN data_bus; -- Potential type problem...  
      Data_in_0 : IN data_word;  
      Data_out : OUT data_word
      );  
   End Entity Multiplexer;  
   
ARCHITECTURE RTL OF Multiplexer IS   


begin

Multi:process(sel,Data_in_0,Data_in_1,Data_in_2, Data_in_3) is
begin
  
  case(sel) is
  
    when "00" =>
      Data_out <=Data_in_0;
    when "01" =>
      Data_out <= Data_in_1;
    when "10" =>
      Data_out <= Data_in_2;
    when "11" => 
      Data_out <= Data_in_3;
   	when others => 
  
  end case;

end process Multi;

end RTL;
