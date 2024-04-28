library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

entity Enchip is
  port(clk : in std_logic; -- fast clock
      reset : in std_logic; -- active high
      stop : in std_logic; -- stops statemachine clk
      choice : in std_logic; -- address(=0) or data(=1)
      data_in : in data_bus; -- data fr�n switchar
      peek_LEDs : OUT data_bus := "00000000";
      Q : out data_bus := "00000000";
		  seven_seg : out std_logic_vector(6 downto 0) := "0000000"
      ); -- output
end entity Enchip; 
 
architecture RTL of Enchip is 

  --CLK_DIV
  component clockdivider
    port (
      ext_clk : in std_logic;  -- Input clock (too fast)
      stop : in std_logic;     -- Stop signal (active low)
      clk : out std_logic      -- Output 1 Hz clock
    );
  end component;
  
  signal EXT_CLK_CD : std_logic;
  signal STOP_CD : std_logic;
  signal CLK_CD : std_logic;


  --OUT_BUFFERT
  component outbuffert
    port (
      clk : in std_logic;
      out_en : in std_logic;
      data_in : in data_word;
      data_out : out data_bus
    );
  end component;
  
  signal CLK_OB : std_logic;
  signal OUT_EN_OB : std_logic;
  signal DATA_IN_OB : data_word;
  signal DATA_OUT_OB : data_bus;

  --ROM--
  component rom
    port (
      adr : in address_bus;
      instr : out instruction_bus;
      ce_n : in std_logic
    );
  end component;
  
  signal ADR_ROM : address_bus;
  signal CE_N_ROM : std_logic;
  signal INSTR_ROM : instruction_bus;
  
  --RAM--
  component ram
    port (
      adr : in address_bus;
      data : inout data_bus;
      clk : in std_logic;
      ce_n : in std_logic; -- active low
      rw : in std_logic
    );
  end component;

  signal ADR_RAM : address_bus;
  signal DATA_RAM : data_bus;
  signal CLK_RAM : std_logic;
  signal CE_N_RAM : std_logic;
  signal RW_RAM : std_logic;
  
  --RAM--
  component cpu
    port (
      adr : out address_bus;
      instr : in instruction_bus; 
      data : inout data_bus; 
      rw : out std_logic; -- read on high, write on low 
      ROM_en : out std_logic; -- active low 
      RWM_en : out std_logic; -- active low 
      IO_en : out std_logic;
      OUT_en : out std_logic;
      clk : in std_logic; 
      reset : in std_logic
    );
  end component;
  
  signal ADR_CPU : address_bus;
  signal INSTR_CPU : instruction_bus;
  signal DATA_CPU : data_bus;
  signal RW_CPU : std_logic;
  signal ROM_EN_CPU : std_logic;
  signal RWM_EN_CPU : std_logic;
  signal IO_EN_CPU : std_logic;
  signal OUT_EN_CPU : std_logic;
  signal CLK_CPU : std_logic := '0';
  signal RESET_CPU : std_logic;
  
  component datainbuffert
    port (
      in_en : in std_logic;
      data_in : in data_word;
      data_out : out data_bus
    );
  end component;
  
  signal IN_EN_INBUF : std_logic;
  signal DATA_IN_INBUF : data_word;
  signal DATA_OUT_INBUF : data_bus;
  
  component counter
    port (
      clk : IN std_logic;
      step : IN std_logic;
      display : OUT std_logic_vector(6 downto 0)
    );
  end component;
  signal CLK_COUNTER : std_logic;
  signal STEP_COUNTER : std_logic;
  signal DISPLAY_COUNTER : std_logic_vector(6 downto 0);

begin

  C1: rom
    port map (
      adr => ADR_ROM,
      instr => INSTR_ROM,
      ce_n => CE_N_ROM
    );
    
  C2: ram
    port map (
      adr => ADR_RAM,
      data => DATA_RAM,
      clk => CLK_RAM,
      ce_n => CE_N_RAM,
      rw => RW_RAM
    );
    
  C3: cpu
    port map (
      adr => ADR_CPU,
      instr => INSTR_CPU,
      data => DATA_CPU,
      rw => RW_CPU,
      ROM_en => ROM_EN_CPU,
      RWM_en => RWM_EN_CPU,
      IO_en => IO_EN_CPU,
      OUT_en => OUT_EN_CPU,
      clk => CLK_CPU,
      reset => RESET_CPU
    );
    
  C4: outbuffert
    port map (
      clk => CLK_OB,
      out_en => OUT_EN_OB,
      data_in => DATA_IN_OB,
      data_out => DATA_OUT_OB
    );
    
  C5: clockdivider
    port map (
      ext_clk => EXT_CLK_CD,
      stop => STOP_CD,
      clk => CLK_CD
    );
    
  C6: datainbuffert
    port map (
      in_en => IN_EN_INBUF,
      data_in => DATA_IN_INBUF,
      data_out => DATA_OUT_INBUF
    );
	 
  C7: counter
	 port map (
		clk => CLK_COUNTER,
      step => STEP_COUNTER,
      display => DISPLAY_COUNTER
	 );
	 
	 CLK_COUNTER <= clk;
	 
	 STEP_COUNTER <= CLK_CD;
	 
	 seven_seg <= DISPLAY_COUNTER;
    
    IN_EN_INBUF <= IO_EN_CPU;
    
    OUT_EN_OB <= OUT_EN_CPU;
    
    EXT_CLK_CD <= clk;
    
    CLK_RAM <= CLK_CD;
    CLK_CPU <= CLK_CD;
    CLK_OB <= CLK_CD;
    
    STOP_CD <= stop;
    
    Q <= DATA_OUT_OB;
    
    ADR_ROM <= ADR_CPU;
    ADR_RAM <= ADR_CPU;
    
    INSTR_CPU <= INSTR_ROM;
    
    DATA_CPU <= DATA_RAM when RW_CPU = '1' and RWM_EN_CPU = '0' else (others => 'Z');
    DATA_RAM <= DATA_CPU when RW_CPU = '0' else (others => 'Z');
    
    DATA_CPU <= DATA_OUT_INBUF when IN_EN_INBUF = '1' else (others => 'Z');
    DATA_IN_OB <= DATA_CPU when OUT_EN_OB = '0' else (others => 'Z');
    
    RW_RAM <= RW_CPU;
    
    CE_N_ROM <= ROM_EN_CPU;
    CE_N_RAM <= RWM_EN_CPU;
 
    peek_LEDs <= DATA_CPU when choice = '1' else (data_size-5 downto 0 => '0') & ADR_CPU;
    
    DATA_IN_INBUF <= data_in;
    
    RESET_CPU <= reset;

end RTL;