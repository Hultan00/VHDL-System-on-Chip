library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

ENTITY Controller IS
PORT( adr : OUT address_bus; -- unsigned
 data : IN program_word; -- unsigned
 RW : OUT std_logic; -- read on high, write on low
 RWM_en : OUT std_logic; -- active low
 ROM_en : OUT std_logic; -- active low
 IO_en : OUT std_logic; -- read switches on high, write to LEDs on low
 clk : IN std_logic; 
 reset : IN std_logic; -- active high
 sel_op_1 : OUT std_logic_vector (1 downto 0); 
 sel_op_0 : OUT std_logic_vector (1 downto 0);
 sel_in : OUT std_logic_vector (1 downto 0);
 rw_reg : OUT std_logic; -- write on low, read on high
 sel_mux : OUT std_logic_vector (1 downto 0);
 alu_op : OUT std_logic_vector (2 downto 0);
 alu_en : OUT std_logic; -- active high 
 z_flag : IN std_logic; -- active high 
 n_flag : IN std_logic; -- active high 
 o_flag : IN std_logic; -- active high
 out_en : OUT std_logic; -- active high
 data_imm : OUT data_word;
 out_en_ob : OUT std_logic
 ); -- signed 
END ENTITY Controller;

ARCHITECTURE RTL OF Controller IS
type State_type IS (Controller_Reset, Fetch_Instruction, Load_Instruction, Decode_Instruction, Write_Result, Load_Data, Store_data, Load_Immidiate);
SIGNAL State : State_type;
SIGNAL pc : address_bus;
SIGNAL instr : instruction_bus;

begin
clock:process(clk, reset)
begin
  if reset = '1' then
    State <= Controller_Reset; --Initial Stat
    pc <= "0000"; --Program counter reset
    adr <= "0000";
  elsif rising_edge(clk) then
    case State is
      when Controller_Reset =>
        ROM_en <= '0';
        RWM_en <= '0';
        State <= Fetch_Instruction;
        out_en <= '0';
        
      when Fetch_Instruction =>
        adr <= pc;
        rw_reg <= '1'; --Register read mode
        State <= Load_Instruction;
        
      when Load_Instruction =>
        instr <= data; --Load the fetched instruction
        State <= Decode_Instruction;
        
      when Decode_Instruction =>
        
        case(instr(9 downto 6)) is
          when "0000" =>
            --ADD
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_0 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            sel_op_1 <= instr(3 downto 2); -- Read values from chosen registeraddress on port 1
            
            alu_op <= "000";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Write_Result;
            
          when "0001" =>
            --SUB
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0'; 
            
            rw_reg <= '0'; -- Set register in read mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            sel_op_0 <= instr(3 downto 2); -- Read values from chosen registeraddress on port 1
            
            alu_op <= "001";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1);
            
            State <= Write_Result;
            
          when "0010" =>
            --AND
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            sel_op_0 <= instr(3 downto 2); -- Read values from chosen registeraddress on port 1
            
            alu_op <= "010";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1);
            
            State <= Write_Result;
            
          when "0011" =>
            --OR
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            sel_op_0 <= instr(3 downto 2); -- Read values from chosen registeraddress on port 1
            
            alu_op <= "011";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1);
            
            State <= Write_Result;
            
          when "0100" =>
            --XOR
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            sel_op_0 <= instr(3 downto 2); -- Read values from chosen registeraddress on port 1
            
            alu_op <= "100";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Write_Result;
            
          when "0101" =>
            --NOT
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            
            alu_op <= "101";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Write_Result;
            
          when "0110" =>
            --MOV
            
            RWM_en <= '1';
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            sel_op_1 <= instr(5 downto 4); -- Read values from chosen registeraddress on port 0
            
            alu_op <= "110";
            alu_en <= '1'; -- Activate ALU
            
            sel_mux <= "00"; -- Set MUX to output data from in-port 0
            
            sel_in <= instr(1 downto 0);
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Write_Result;
            
          when "0111" =>
            --IN / OUT
            
            if instr(3) = '0' then
              --IN -> Register adr(instr(5 downto 4)) = switch
              RW <= '1';
              
              RWM_en <= '1';
              
              IO_en <= '1';
            
              out_en_ob <= '1';
              
              sel_mux <= "01";
              
              rw_reg <= '0';
              
              sel_in <= instr(5 downto 4);
              
            elsif instr(3) = '1' then
              --OUT -> LED = Register adr(instr(5 downto 4))
              RW <= '1';
              
              RWM_en <= '1';
              
              IO_en <= '0';
            
              out_en_ob <= '0';
              
              rw_reg <= '1';
              
              sel_op_1 <= instr(5 downto 4);
              
              out_en <= '1';
              
              RWM_en <= '1';
              
            end if;
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Load_Data;
            
          when "1000" =>
            --LDR
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '0';
            
            RW <= '1';
            
            out_en <= '0';
            
            RWM_en <= '0'; -- RAM enable
            
            rw_reg <= '0'; -- Set register in write mode
            
            adr <= instr(3 downto 0); -- Address to RAM
            
            sel_mux <= "01"; -- Set MUX to output data from in-port 1
            
            sel_in <= instr(5 downto 4); -- Regsiter address from instr
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Load_Data;
            
          when "1001" =>
            --STR
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '0';
            
            RW <= '0';
            
            out_en <= '1';
            
            rw_reg <= '1'; -- Register read mode
            
            sel_op_1 <= instr(5 downto 4);
            
            adr <= instr(3 downto 0);
            
            rwm_en <= '0';
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Store_Data;
            
          when "1010" =>
            --LDI
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            rw_reg <= '0'; -- Set register in write mode
            
            sel_in <= instr(5 downto 4);
            
            data_imm <= (data_size-5 downto 0 => '0') & instr(3 downto 0);
            
            sel_mux <= "10";
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Load_Immidiate;
            
          when "1011" =>
            --NOP
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
            
            State <= Fetch_Instruction;
            
          when "1100" =>
            --BRZ
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            if z_flag = '1' then
              pc <= instr(3 downto 0);
            else
        	     pc <= std_logic_vector(unsigned(pc) + 1); -- Increment program counter
    	       end if;
    	       
    	       State <= Fetch_Instruction;
        	     
          when "1101" =>
            --BRN
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            if n_flag = '0' then
              pc <= instr(3 downto 0);
            else
          	   pc <= std_logic_vector(unsigned(pc) + 1);
        	   end if;
        	   
        	   State <= Fetch_Instruction;
          	   
          when "1110" =>
            --BRO
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            if o_flag = '0' then
              pc <= instr(3 downto 0);
            else
          	   pc <= std_logic_vector(unsigned(pc) + 1);
        	   end if;
        	   
        	   State <= Fetch_Instruction;
          	   
          when "1111" =>
            --BRA
            
            IO_en <= '0';
            
            out_en_ob <= '1';
            
            RWM_en <= '1';
            
            RW <= '1';
            
            out_en <= '0';
            
            pc <= instr(3 downto 0);
            
            State <= Fetch_Instruction;
            
          when others =>
            State <= Controller_Reset;
            
        end case;
      
      when Write_Result =>
        
        alu_en <= '0';
        
        State <= Fetch_Instruction;
        
      when Load_Data =>
        
        State <= Fetch_Instruction;
        
      when Store_Data =>
        
        RW <= '1';
        
        State <= Fetch_Instruction;
        
      when Load_Immidiate =>
        
        State <= Fetch_Instruction;
          
      when others =>
        State <= Controller_Reset; --Default state
    end case;
  end if;
end process;
end RTL;


