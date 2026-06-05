
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.scopeToHdmi_package.all;

entity scopeFace is
    PORT ( 	clk: in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         pixelHorz : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
         pixelVert : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS -1 downto 0);
         triggerVolt: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         triggerTime: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         red : out  STD_LOGIC_VECTOR(7 downto 0);
         green : out  STD_LOGIC_VECTOR(7 downto 0);
         blue : out  STD_LOGIC_VECTOR(7 downto 0);
         ch1: in STD_LOGIC;
         ch1Enb: in STD_LOGIC;
         ch2: in STD_LOGIC;
         ch2Enb: in STD_LOGIC);
end scopeFace;


architecture Behavioral of scopeFace is

    -- Set these signals to '1' when the features should be drawn at the current pixelHorz, pixelVert 
    -- cordinate.  These act like Feature Booleans which you will use in the process(clk) to set the 
    -- correct RGB for this pixel location. Finish and add more.
    signal borderH, borderV : STD_LOGIC;
    signal gridH, gridV : STD_LOGIC;
    signal hatchH, hatchV : STD_LOGIC;
    signal trigH, trigV : STD_LOGIC; -- trigger locations
    signal mainH, mainV : STD_LOGIC;
    signal inBorder : STD_LOGIC; -- to check if we are within the borders

begin


    ---------------------------------------------------------------------
    -- Use the Feature Booleans to set the RGB at this pixel location.
    -- The waveforms should sit "on top" of the grid.
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                red <= (others => '0');
                green <= (others => '0');
                blue <= (others => '0');
            else
                if ((borderH = '1') or (borderV = '1')) then
                    red <= BORDER_R;
                    green <= BORDER_G;
                    blue <= BORDER_B;
                elsif ((trigH='1') or (trigV='1')) then
                    red <= TRIGGER_R;
                    green <= TRIGGER_G;
                    blue <= TRIGGER_B; 
                elsif ((ch1='1') and (ch1Enb='1') and (inBorder = '1')) then
                    red <= CH1_R;
                    green <= CH1_G;
                    blue <= CH1_B;   
                elsif ((ch2='1') and (ch2Enb='1') and (inBorder = '1')) then
                    red <= CH2_R;
                    green <= CH2_G;
                    blue <= CH2_B;
                elsif (mainH = '1') or (mainV = '1') then
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;
                elsif ((gridH = '1') or (gridV = '1')) then
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;
                elsif (hatchH = '1') or (hatchV = '1') then
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;        
                else
                    red <= X"00";
                    green <= X"00";
                    blue <= X"00";
                end if;
            end if;
        end if;
    end process;

    --inBorder <= '1' when ((pixelHorz > L_EDGE) and (pixelHorz < R_EDGE) and (pixelVert > T_EDGE) and (pixelVert < B_EDGE)) else '0';
    
    borderH <= '1' when (
    (((pixelHorz > L_EDGE - WIDTH) and (pixelHorz < L_EDGE + WIDTH)) or
    ((pixelHorz > R_EDGE - WIDTH) and (pixelHorz < R_EDGE + WIDTH)))and
    ((pixelVert > T_EDGE - HEIGHT) and (pixelVert < B_EDGE + HEIGHT))
    ) else '0';
    
    borderV <= '1' when (
        (((pixelVert > B_EDGE - HEIGHT) and (pixelVert < B_EDGE + HEIGHT)) or
        ((pixelVert > T_EDGE - HEIGHT) and (pixelVert < T_EDGE + HEIGHT))) and
        ((pixelHorz > L_EDGE - WIDTH) and (pixelHorz < R_EDGE + WIDTH))
    ) else '0';
    inBorder <= '1' when ((pixelVert > T_EDGE - HEIGHT) and (pixelVert < B_EDGE + HEIGHT) and (pixelHorz > L_EDGE - WIDTH) and (pixelHorz < R_EDGE + WIDTH)) else '0';
    mainH <= '1' when ((pixelHorz < 601) and (pixelHorz > 599)) and (pixelVert > T_EDGE) and (pixelVert < B_EDGE) else '0';
    mainV <= '1' when ((pixelVert < 351) and (pixelVert > 349)) and (pixelHorz > L_EDGE) and (pixelHorz < R_EDGE) else '0';

-- draw the trigger triangles
    trigH <= '1' when(
    ((pixelVert = T_EDGE+1) and ((pixelHorz = triggerTime) or (pixelHorz = triggerTime+1) or (pixelHorz = triggerTime-1)or (pixelHorz = triggerTime+2) or (pixelHorz = triggerTime-2)or (pixelHorz = triggerTime+3) or (pixelHorz = triggerTime-3)))or
    ((pixelVert = T_EDGE+2) and ((pixelHorz = triggerTime) or (pixelHorz = triggerTime+1) or (pixelHorz = triggerTime-1)or (pixelHorz = triggerTime+2) or (pixelHorz = triggerTime-2)))or 
    ((pixelVert = T_EDGE+3) and ((pixelHorz = triggerTime) or (pixelHorz = triggerTime+1) or (pixelHorz = triggerTime-1))) or 
    ((pixelVert = T_EDGE+4) and ((pixelHorz = triggerTime)))) else '0';
--    trigH <= '1' when((pixelVert = T_EDGE+2) and ((pixelHorz = triggerTime) or (pixelHorz = triggerTime+1) or (pixelHorz = triggerTime-1))) else '0';
--    trigH <= '1' when((pixelVert = T_EDGE+3) and ((pixelHorz = triggerTime))) else '0';

    trigV <= '1' when(
    ((pixelHorz = L_EDGE+1) and ((pixelVert = triggerVolt) or (pixelVert = triggerVolt+1) or (pixelVert = triggerVolt-1)or (pixelVert = triggerVolt+2) or (pixelVert = triggerVolt-2) or(pixelVert = triggerVolt+3) or (pixelVert = triggerVolt-3)))or
    ((pixelHorz = L_EDGE+2) and ((pixelVert = triggerVolt) or (pixelVert = triggerVolt+1) or (pixelVert = triggerVolt-1)or (pixelVert = triggerVolt+2) or (pixelVert = triggerVolt-2)))or
    ((pixelHorz = L_EDGE+3) and ((pixelVert = triggerVolt) or (pixelVert = triggerVolt+1) or (pixelVert = triggerVolt-1)))or
    ((pixelHorz = L_EDGE+4) and ((pixelVert = triggerVolt)))
    ) else '0';
--    trigV <= '1' when((pixelHorz = L_EDGE+2) and ((pixelVert = triggerVolt) or (pixelVert = triggerVolt+1) or (pixelVert = triggerVolt-1))) else '0';
--    trigV <= '1' when((pixelHorz = L_EDGE+3) and ((pixelVert = triggerVolt))) else '0';
    
    -- generated with python script
gridH <= '1' when (
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=150)) or 
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=200)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=250)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=300)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=350)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=400)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=450)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=500)) or
((pixelHorz>L_EDGE) and (pixelHorz<R_EDGE) and (pixelVert=550))
) else '0';

gridV <= '1' when (
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=200)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=300)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=400)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=500)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=600)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=700)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=800)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=900)) or
((pixelVert<B_EDGE) and (pixelVert>T_EDGE) and (pixelHorz=1000))
) else '0';

hatchH <= '1' when (
(((pixelHorz=100) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=120) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=140) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=160) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=180) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=200) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=220) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=240) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=260) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=280) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=300) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=320) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=340) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=360) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=380) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=400) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=420) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=440) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=460) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=480) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=500) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=520) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=540) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=560) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=580) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=600) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=620) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=640) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=660) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=680) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=700) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=720) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=740) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=760) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=780) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=800) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=820) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=840) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=860) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=880) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=900) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=920) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=940) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=960) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=980) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=1000) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=1020) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=1040) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=1060) and (pixelVert>347) and (pixelVert<353))) or
(((pixelHorz=1080) and (pixelVert>347) and (pixelVert<353)))
) else '0';

hatchV <= '1' when (
(((pixelVert=100) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=110) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=120) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=130) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=140) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=150) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=160) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=170) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=180) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=190) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=200) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=210) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=220) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=230) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=240) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=250) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=260) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=270) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=280) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=290) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=300) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=310) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=320) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=330) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=340) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=350) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=360) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=370) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=380) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=390) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=400) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=410) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=420) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=430) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=440) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=450) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=460) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=470) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=480) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=490) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=500) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=510) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=520) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=530) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=540) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=550) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=560) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=570) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=580) and (pixelHorz>597) and (pixelHorz<603))) or
(((pixelVert=590) and (pixelHorz>597) and (pixelHorz<603)))
) else '0';

end Behavioral;


