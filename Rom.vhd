library IEEE;
use IEEE.std_logic_1164.all;
use work.CPU_Package.all;
use ieee.numeric_std.all;
use std.STANDARD.BOOLEAN;

ENTITY rom IS 
   PORT (adr : IN address_bus; 
         instr : OUT instruction_bus; 
         ce_n : IN std_logic);          -- active low 
END ENTITY rom; 
ARCHITECTURE RTL OF rom IS   
type rom_types is array (0 to 14) of std_logic_vector(9 downto 0);
constant memory: rom_types:=
(
    ldi_op & r3_adr & "0011",          -- 0  (LDI R3, 3) W
    str_op & r3_adr & "1110",          -- 1  (STR R3, 14) W
    ldi_op & r1_adr & "0001",          -- 2  (LDI R1, 1) W
    ldr_op & r0_adr & "1110",          -- 3  (LDR R0, 14) W
    mov_op & r0_adr & "00" & r2_adr,   -- 4  (MOV R0, R2) W
    add_op & r2_adr & r1_adr & r2_adr, -- 5  (ADD R2, R1, R2) W
    sub_op & r0_adr & r1_adr & r0_adr, -- 6  (SUB R0, R1, R0) 
    brz_op & "00" & "1100",            -- 7  (BRZ 12)
    nop_op & "000000",                 -- 8  (NOP)
    bra_op & "00" & "0101",            -- 9  (BRA 5)
    nop_op & "000000",                 -- 10 (NOP)
    nop_op & "000000",                 -- 11 (NOP)
    str_op & r2_adr & "1111",          -- 12 (STR R2, 15)
    out_op & r2_adr & "1" & "000",     -- 13 (OUT R2)
    bra_op & "00" & "1110"             -- 14 (BRA 14)
);

begin

save_rom: process(ce_n, adr) is
    begin
        if (ce_n = '1') then
            instr <= (others=>'Z');
        else
            if to_integer(unsigned(adr)) > 14 then
                instr <= nop_op & "000000"; -- Output NOP if adr > 14
            else
                instr <= memory(to_integer(unsigned(adr)));
            end if;
        end if;
    end process save_rom;

end RTL;


