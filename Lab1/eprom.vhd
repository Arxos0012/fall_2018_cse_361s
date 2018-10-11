--- 2018 RSRC new "eprom" VHDL Code
--- f(x) = 1,000,000x - x^2 + x^3 - x^4, x = 0, 1, 2, ... , to max f(x)
--- Current file name:  eprom.vhd
--- Last Revised:  8/22/2018; 2:48 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY eprom IS
   PORT (d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l     : IN  STD_LOGIC ;
         oe_l     : IN  STD_LOGIC) ;
END eprom ;

ARCHITECTURE behavioral OF eprom IS

   SIGNAL data    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN
   WITH address  SELECT
   data <=
          X"2f400008" WHEN "0000000000" , --- la r29, TOP
          X"28400000" WHEN "0000000001" , --- la r1, 0
          X"2f81ffff" WHEN "0000000010" , --- la r30, -1
          X"e7bc0015" WHEN "0000000011" , --- shl r30, r30, 21
          X"3841e003" WHEN "0000000100" , --- blt r1, r30
          X"68420001" WHEN "0000000101" , --- la r31, LOOP
          X"403a0001" WHEN "0000000110" , --- br r29
          X"f8000000" WHEN "0000000111" , --- stop
          X"00000000" WHEN OTHERS ;
        
   readprocess:PROCESS(ce_l,oe_l,data)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d(31 DOWNTO 0) <= data ;
      else
	 d(31 DOWNTO 0) <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ; 

END behavioral ;
