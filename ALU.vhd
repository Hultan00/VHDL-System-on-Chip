library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

entity ALU is 
  PORT(
    Op : IN std_logic_vector(2 downto 0);
    A : IN data_word;
    B : IN data_word;
    En : IN std_logic;
    clk : IN std_logic;
    y : OUT data_word;
    n_flag: OUT std_logic;
    z_flag: OUT std_logic;
    o_flag: OUT std_logic
    ); 
end ALU;

architecture RTL of ALU is
  signal z_flag_check : std_logic_vector(data_size-1 downto 0) := (others => '0');
  signal n_flag_check : std_logic_vector(data_size-1 downto 0);
begin
next_state:process(clk)
  begin
    if(rising_edge(clk)) then
      if(En='1') then
        case (Op) is
          
          when "000" =>
            y <= add_overflow(a,b)(data_size-1 downto 0);
            if((add_overflow(a,b)(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
            end if;
            if((add_overflow(a,b)(data_size-1 downto 0)) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            if((add_overflow(a,b)(data_size)) = '1') then
              o_flag <= '1';
            else
              o_flag <= '0';
            end if;
            
          when "001" =>
            y <= sub_overflow(a,b)(data_size-1 downto  0);
            if((sub_overflow(a,b)(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
            end if;
            z_flag_check <= (others => '0');
            if((sub_overflow(a,b)(data_size-1 downto 0)) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            if((sub_overflow(a,b)(data_size)) = '1') then
              o_flag <= '1';
            else
              o_flag <= '0';
            end if;
            
          when "010" =>
            y <= a and b;
            n_flag_check <= a and b;
            if((n_flag_check(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
	          end if;
            if((a and b) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            o_flag <= '0';
            
          when "011" =>
            y <= a or b;
            n_flag_check <= a or b;
            if((n_flag_check(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
	          end if;
            if((a or b) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            o_flag <= '0';
            
          when "100" =>
            y <= a xor b;
            n_flag_check <= a xor b;
            if((n_flag_check(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
	          end if;
            if((a xor b) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            o_flag <= '0';
            
          when "101" =>
            y <= not(a);
            n_flag_check <= not(a);
            if((n_flag_check(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
	          end if;
            if((not(a)) = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            o_flag <= '0';
            
          when "110" =>
            y <= a;
            n_flag_check <= a;
            if((n_flag_check(data_size-1)) = '1') then
              n_flag <= '1';
            else
              n_flag <= '0';
	          end if;
            if(a = z_flag_check) then
              z_flag <= '1';
            else
              z_flag <= '0';
            end if;
            o_flag <= '0';
            
          when others =>
            y <= (others => '0');
            n_flag <= '0';
            z_flag <= '0';
            o_flag <= '0';
            
        end case;
      end if;
    end if;
end process next_state;
end RTL;

