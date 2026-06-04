library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.basicBuildingBlocks_package.all;

entity enhancedPwm is
    Port ( clk : in STD_LOGIC;
        resetn : in STD_LOGIC;
        dutyCycle : in STD_LOGIC_VECTOR (8 downto 0);
        enb : in STD_LOGIC;
        pwmSignal : out STD_LOGIC;
        pwmCount : out STD_LOGIC_VECTOR (7 downto 0);
        rollOver : out STD_LOGIC);
end enhancedPwm;

architecture Behavioral of enhancedPwm is
    signal E255, dutyGreaterCnt : STD_LOGIC;
    signal dutyCycle_int : STD_LOGIC_VECTOR (8 downto 0);
    signal pwmCount_int : STD_LOGIC_VECTOR (7 downto 0);
    signal pwmCount9_int : STD_LOGIC_VECTOR (8 downto 0);
    signal counterControl : STD_LOGIC_VECTOR (1 downto 0);
    signal inputCtrlVec: STD_LOGIC_VECTOR(1 downto 0);


    component genericCompare is
        generic(N: integer := 4);
        port(x,y : in std_logic_vector(N-1 downto 0);
            g,l,e: out std_logic);
    end component;

    component genericRegister is
        generic(N: integer := 4);
        port ( clk, resetn, load: in std_logic;
            d: in std_logic_vector(N-1 downto 0);
            q: out std_logic_vector(N-1 downto 0) );
    end component;
    
    begin
    
    -- DFF to address glitching
    process(clk)
        begin 
        if(rising_edge(clk)) then
            if(resetn = '0') then 
                pwmSignal <= '0';
            else 
                pwmSignal <= dutyGreaterCnt; 
            end if;
        end if;       
    end process; 
    
    -- zero-pad the pwm count, needs to be 9-bits
    pwmCount9_int <= '0' & pwmCount_int;
    
    comp_9bit : genericCompare
        GENERIC MAP(9)
        PORT MAP(x => dutyCycle_int, 
            y => pwmCount9_int, 
            g => dutyGreaterCnt, 
            l => open,
            e => open
        );

    comp_8bit : genericCompare
        GENERIC MAP(8)
        PORT MAP(x => x"FF", 
            y => pwmCount_int, 
            g => open, 
            l => open,
            e => E255
        );

    reg_inst: genericRegister
        GENERIC MAP(9)
        PORT MAP(clk => clk, 
            resetn => resetn, 
            load => E255,
            d => dutyCycle, 
            q => dutyCycle_int
        );
    
    count_inst: genericCounter
        GENERIC MAP (8)
        PORT MAP(clk=>clk,
            resetn => resetn,
            c => counterControl,
            d => x"00",
            q => pwmCount_int
        );
        
    pwmCount <= pwmCount_int;
    
--  00  Hold
--  01  load
--  10  inc
--  11  reset
    inputCtrlVec <= enb & E255;
    counterControl <=   "00" when inputCtrlVec = "00" else --  hold
                        "00" when inputCtrlVec = "01" else --  hold if E255 but no enable
                        "10" when inputCtrlVec = "10" else --  increase if neq 255
                        "11"; --  reset if E255 and counter enabled
    rollOver <= '1' when inputCtrlVec = "11" else '0';
end Behavioral;