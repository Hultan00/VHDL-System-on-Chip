library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package CPU_Package is
  constant address_size: integer:=4;
  constant data_size: integer:=8;
  constant operation_size: integer:=4;
  constant instruction_size: integer:=10;
  
  constant add_op: std_logic_vector(3 downto 0):="0000";
  constant sub_op: std_logic_vector(3 downto 0):="0001";
  constant and_op: std_logic_vector(3 downto 0):="0010";
  constant or_op: std_logic_vector(3 downto 0):="0011";
  constant xor_op: std_logic_vector(3 downto 0):="0100";
  constant not_op: std_logic_vector(3 downto 0):="0101";
  constant mov_op: std_logic_vector(3 downto 0):="0110";
  constant in_op: std_logic_vector(3 downto 0):="0111";
  constant out_op: std_logic_vector(3 downto 0):="0111";
  constant ldr_op: std_logic_vector(3 downto 0):="1000";
  constant str_op: std_logic_vector(3 downto 0):="1001";
  constant ldi_op: std_logic_vector(3 downto 0):="1010";
  constant nop_op: std_logic_vector(3 downto 0):="1011";
  constant brz_op: std_logic_vector(3 downto 0):="1100";
  constant brn_op: std_logic_vector(3 downto 0):="1101";
  constant bro_op: std_logic_vector(3 downto 0):="1110";
  constant bra_op: std_logic_vector(3 downto 0):="1111";
  
  constant r0_adr: std_logic_vector(1 downto 0):="00";
  constant r1_adr: std_logic_vector(1 downto 0):="01";
  constant r2_adr: std_logic_vector(1 downto 0):="10";
  constant r3_adr: std_logic_vector(1 downto 0):="11";
  
  subtype data_word is std_logic_vector(data_size-1 downto 0);
  subtype address_bus is std_logic_vector(address_size-1 downto 0);
  subtype data_bus is std_logic_vector(data_size-1 downto 0);
  subtype instruction_bus is std_logic_vector(instruction_size-1 downto 0);
  subtype program_word is std_logic_vector(instruction_size-1 downto 0);
  subtype command_word is std_logic_vector(operation_size-1 downto 0);
  subtype register_h is std_logic_vector(data_size-1 downto 0);
  
  type register_f is array (0 to 3) of std_logic_vector(data_size-1 downto 0);
  
  function add_overflow(a, b : std_logic_vector) return std_logic_vector;
  function sub_overflow(a, b : std_logic_vector) return std_logic_vector;
end package;

package body CPU_Package is
  function add_overflow(a, b : std_logic_vector) return std_logic_vector is
    variable sum : std_logic_vector(data_size-1 downto 0);
    variable output : std_logic_vector(data_size downto 0);
    variable A_int : integer;
    variable B_int : integer;
    begin
    -- Konvertera de två n-bitars vektorerna till heltal
    A_int := to_integer(signed(a));
    B_int := to_integer(signed(b));

    -- Utför additionen
    sum := std_logic_vector(signed(a) + signed(b));

    -- Kolla om det blir overflow genom att jämföra med det maximala och
    -- minimala värdet som kan representeras med n bitar
    if (A_int >= 0 and B_int >= 0 and sum(data_size-1) = '1') or
       (A_int < 0 and B_int < 0 and sum(data_size-1) = '0') then
        -- Det uppstår overflow
        output := '1' & sum(data_size-1 downto 0);
    else
        -- Det uppstår inte overflow
        output := '0' & sum(data_size-1 downto 0);
    end if;

    return output;
  end function;


  function sub_overflow(a, b: std_logic_vector) return std_logic_vector is
    variable diff: std_logic_vector(data_size-1 downto 0);
    variable output: std_logic_vector(data_size downto 0);
    variable A_int: integer;
    variable B_int: integer;
    begin
    -- Konvertera de två n-bitars vektorerna till heltal
    A_int := to_integer(signed(a));
    B_int := to_integer(signed(b));

    -- Utför subtraktionen
    diff := std_logic_vector(signed(a) - signed(b));

    -- Kolla om det blir overflow genom att jämföra med det maximala och
    -- minimala värdet som kan representeras med n bitar
    if (A_int >= 0 and B_int < 0 and diff(data_size-1) = '0') or
       (A_int < 0 and B_int >= 0 and diff(data_size-1) = '1') then
        -- Det uppstår overflow
        output := '1' & diff(data_size - 1 downto 0);
    else
        -- Det uppstår inte overflow
        output := '0' & diff(data_size - 1 downto 0);
    end if;

    return output;
  end function;

end package body CPU_Package;





