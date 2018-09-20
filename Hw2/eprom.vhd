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
     X"2fc0001c" WHEN "0000000000" , --- la r31,TOP
     X"2f801000" WHEN "0000000001" , --- la r30,MYD
     X"28400000" WHEN "0000000010" , --- la r1,0
     X"308f422f" WHEN "0000000011" , --- lar r2,999999
     X"28c1fff6" WHEN "0000000100" , --- la r3,-10
     X"2901ffe2" WHEN "0000000101" , --- la r4,-30
     X"2941ffe8" WHEN "0000000110" , --- la r5,-24
     X"187c0000" WHEN "0000000111" , --- st r1,0(r30)
     X"6fbc0004" WHEN "0000001000" , --- addi r30,r30,4
     X"60422000" WHEN "0000001001" , --- add r1,r1,r2
     X"60843000" WHEN "0000001010" , --- add r2,r2,r3
     X"60c64000" WHEN "0000001011" , --- add r3,r3,r4
     X"61085000" WHEN "0000001100" , --- add r4,r4,r5
     X"403e2004" WHEN "0000001101" , --- brpl r31,r2
     X"187c0000" WHEN "0000001110" , --- st r1,0(r30)
     X"f8000000" WHEN "0000001111" , --- stop
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
