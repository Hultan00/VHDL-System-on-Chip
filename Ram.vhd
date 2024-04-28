library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CPU_Package.all;

ENTITY ram IS
  PORT(
    adr : IN address_bus;
    data : INOUT data_bus;
    clk : IN std_logic;
    ce_n : IN std_logic; -- active low
    rw : IN std_logic -- r=0 for read, w=1 for write
  );
END ENTITY ram;

ARCHITECTURE RTL OF ram IS
  type ram_array is array (0 to 15) of data_bus;
  signal ram_data: ram_array;

begin
  data <= ram_data(to_integer(unsigned(adr))) when ce_n = '0' and rw = '1' else (others => 'Z');
  
  process(clk, ce_n)
  begin
    if rising_edge(clk) then
      if ce_n = '0' then
        if rw = '0' then
          -- Write operation (rw = '1')
          ram_data(to_integer(unsigned(adr))) <= data;
        end if;
      else
        data <= (others => 'Z');
      end if;
    end if;
  end process;
end RTL;
