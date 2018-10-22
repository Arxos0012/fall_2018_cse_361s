--- 2008 "pullups" VHDL Code 
--- Current file name: pullups.vhd
--- Last Revised:  10/23/2008; 9:45 a.m.
--- Author:  WDR

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY pullups IS
   PORT (d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         done     : OUT STD_LOGIC ;
         read     : OUT STD_LOGIC ;
         write    : OUT STD_LOGIC) ;
END pullups ;

ARCHITECTURE behavioral OF pullups IS

BEGIN

   address(31 DOWNTO 0) <= (OTHERS => 'H') ;
   d(31 DOWNTO 0) <= (OTHERS => 'H') ;
   read <= 'L' ;
   write <= 'L' ;
   done  <= 'L' ;

END behavioral ;
