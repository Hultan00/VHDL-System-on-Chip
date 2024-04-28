library IEEE;
use IEEE.std_logic_1164.all;
use work.CPU_Package.all;
use ieee.numeric_std.all;

ENTITY RegisterFile IS  
   PORT(clk : IN std_logic; 
    data_in : IN data_word; 
    data_out_1 : OUT data_word; 
    data_out_0 : OUT data_word; 
    sel_in : IN std_logic_vector (1 downto 0);   
    sel_out_1 : IN std_logic_vector (1 downto 0);   
    sel_out_0 : IN std_logic_vector (1 downto 0);  
    rw_reg : in std_logic);  
END ENTITY RegisterFile;  

architecture RTL of RegisterFile is
signal registerAddr : register_f;
begin

data_out_0 <= registerAddr(to_integer(unsigned(sel_out_0)));
data_out_1 <= registerAddr(to_integer(unsigned(sel_out_1)));
 
save_register:process(clk)
  begin
  if(rising_edge(clk)) then
    if(rw_reg = '0') then
     registerAddr(to_integer(unsigned(sel_in))) <=  data_in;
    end if;

  end if;
end process save_register;

end RTL;
