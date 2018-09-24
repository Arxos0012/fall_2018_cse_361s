--- 2018 RSRC "controlstore" VHDL Code 
--- Current file name: controlstore.vhd
--- Last Revised:  8/31/2018; 3:48 p.m.
--- Author:  WDR
--- Copyright: William D. Richard, Ph.D., 2018

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY controlstore IS
   PORT (d        : OUT STD_LOGIC_VECTOR(44 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(8 DOWNTO 0)) ;
END controlstore ;

ARCHITECTURE behavioral OF controlstore IS

BEGIN
   WITH address SELECT
   d <=
---           
---          pcc      bm  m  w
---   bbb  cpc12i    radmmdmrr  a n ci s  bbbbbbbbb
---   rrracocooorgggroobddoaeiasnoonenshssrrrrrrrrr
---   ccciiuiuuuirrriuuurwuiatdudrteqchrhhaaaaaaaaa
---   210nntntttnabcnttsdrtndedbxxxgb4ralc876543210
     "000010010000000000000100000000010000000000000" WHEN "000000000" , ---Fetch S0
     "000001100000000000100010000000000000000000000" WHEN "000000001" , ---Fetch S1
     "000000000010000000001000000000000000000000000" WHEN "000000010" , ---Fetch S2
     "010000000000000000000000000000000000000000000" WHEN "000000011" , ---Fetch S3

     "000100000000100010000000000000000000000000000" WHEN "100001000" , ---ld: Grb, BAout, Ain
     "000010000100000000000000100000000000000000000" WHEN "100001001" , ---ld: c2out, ADD, Cin
     "000001000000000000000100000000000000000000000" WHEN "100001010" , ---ld: Cout, MAin 
     "000000000000000000100010000000000000000000000" WHEN "100001011" , ---ld: MDrd, Read
     "001000000001001000001000000000000000000000000" WHEN "100001100" , ---ld: MDout, Gra, Rin

     "000100010000000000000000000000000000000000000" WHEN "100010000" , ---ldr: PCout, Ain
     "000010001000000000000000100000000000000000000" WHEN "100010001" , ---ldr: c1out, ADD, Cin
     "000001000000000000000100000000000000000000000" WHEN "100010010" , ---ldr: Cout, MAin 
     "000000000000000000100010000000000000000000000" WHEN "100010011" , ---ldr: MDrd, Read
     "001000000001001000001000000000000000000000000" WHEN "100010100" , ---ldr: MDout, Gra, Rin

     "000100000000100010000000000000000000000000000" WHEN "100011000" , ---st: Grb, BAout, Ain
     "000010000100000000000000100000000000000000000" WHEN "100011001" , ---st: c2out, ADD, Cin
     "000001000000000000000100000000000000000000000" WHEN "100011010" , ---st: Cout, MAin
     "000000000001000101000000000000000000000000000" WHEN "100011011" , ---st: Gra, Rout, MDbus
     "001000000000000000010001000000000000000000000" WHEN "100011100" , ---st: MDwr, Write

     "000100010000000000000000000000000000000000000" WHEN "100100000" , ---str: PCout, Ain
     "000010001000000000000000100000000000000000000" WHEN "100100001" , ---str: c1out, ADD, Cin
     "000001000000000000000100000000000000000000000" WHEN "100100010" , ---str: Cout, MAin
     "000000000001000101000000000000000000000000000" WHEN "100100011" , ---str: Gra, Rout, MDbus
     "001000000000000000010001000000000000000000000" WHEN "100100100" , ---str: MDwr, Write

     "000100000000100010000000000000000000000000000" WHEN "100101000" , ---la: Grb, Baout, Ain
     "000010000100000000000000100000000000000000000" WHEN "100101001" , ---la: c2out, ADD, Cin
     "001001000001001000000000000000000000000000000" WHEN "100101010" , ---la: Cout, Gra, Rin

     "000100010000000000000000000000000000000000000" WHEN "100110000" , ---lar: PCout, Ain
     "000010001000000000000000100000000000000000000" WHEN "100110001" , ---lar: c1out, ADD, Cin
     "001001000001001000000000000000000000000000000" WHEN "100110010" , ---lar: Cout, Gra, Rin

     "011000000000000000000000000000000000101000010" WHEN "101000000" , ---br:  (test con)
     "001000000000000000000000000000000000000000000" WHEN "101000001" , ---br:  return to fetch (con=0)
     "001000100000100100000000000000000000000000000" WHEN "101000010" , ---br:  Grb, Rout, PCin (con=1)

     "000000010001001000000000000000000000000000000" WHEN "101001000" , ---brl: PCout, Gra, Rin
     "011000000000000000000000000000000000101001011" WHEN "101001001" , ---brl: (test con)
     "001000000000000000000000000000000000000000000" WHEN "101001010" , ---brl: return to fetch (con=0)
     "001000100000100100000000000000000000000000000" WHEN "101001011" , ---brl: Grb, Rout, PCin (con=1)

     "000010000000010100000000000001000000000000000" WHEN "101111000" , ---neg: Grc, Rout, Ain
     "001001000001001000000000000000000000000000000" WHEN "101111001" , ---neg: Cout, Gra, Rin

     "000010000000010100000000000010000000000000000" WHEN "111000000" , ---not: Grc, Rout, NOT, Cin
     "001001000001001000000000000000000000000000000" WHEN "111000001" , ---not: Cout, Gra, Rin

     "000010000000100100000000000000000010000000000" WHEN "111100000" , ---shl: Grb, Rout, Shl, Cin
     "001001000001001000000000000000000000000000000" WHEN "111100001" , ---shl: Cout, Gra, Rin

     "000010000000100100000000000000001000000000000" WHEN "111010000" , ---shr: Grb, Rout, Shr, Cin
     "001001000001001000000000000000000000000000000" WHEN "111010001" , ---shr: Cout, Gra, Rin

     "000010000000100100000000000000000100000000000" WHEN "111011000" , ---shra: Grb, Rout, Shra, Cin
     "001001000001001000000000000000000000000000000" WHEN "111011001" , ---shra: Cout, Gra, Rin

     "000010000000100100000000000000000001000000000" WHEN "111101000" , ---shc: Grb, Rout, Shc, Cin
     "001001000001001000000000000000000000000000000" WHEN "111101001" , ---shc: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "101101000" , ---addi: Grb, Rout, Ain
     "000010000100000000000000100000000000000000000" WHEN "101101001" , ---addi: c2out, ADD, Cin
     "001001000001001000000000000000000000000000000" WHEN "101101010" , ---addi: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "101110000" , ---sub: Grb, Rout, Ain
     "000010000000010100000000010000000000000000000" WHEN "101110001" , ---sub: Grc, Rout, SUB, Cin
     "001001000001001000000000000000000000000000000" WHEN "101110010" , ---sub: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "101100000" , ---add: Grb, Rout, Ain
     "000010000000010100000000100000000000000000000" WHEN "101100001" , ---add: Grc, Rout, ADD, Cin
     "001001000001001000000000000000000000000000000" WHEN "101100010" , ---add: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "110100000" , ---and: Grb, Rout, Ain
     "000010000000010100000000001000000000000000000" WHEN "110100001" , ---and: Grc, Rout, AND, Cin
     "001001000001001000000000000000000000000000000" WHEN "110100010" , ---and: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "110110000" , ---or: Grb, Rout, Ain
     "000010000000010100000000000100000000000000000" WHEN "110110001" , ---or: Grc, Rout, OR, Cin
     "001001000001001000000000000000000000000000000" WHEN "110110010" , ---or: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "110101000" , ---andi: Grb, Rout, Ain
     "000010000100000000000000001000000000000000000" WHEN "110101001" , ---andi: c2out, AND, Cin
     "001001000001001000000000000000000000000000000" WHEN "110101010" , ---andi: Cout, Gra, Rin

     "000100000000100100000000000000000000000000000" WHEN "110111000" , ---ori: Grb, Rout, Ain
     "000010000100000000000000000100000000000000000" WHEN "110111001" , ---ori: c2out, OR, Cin
     "001001000001001000000000000000000000000000000" WHEN "110111010" , ---ori: Cout, Gra, Rin

     "001000000000000000000000000000000000000000000" WHEN "100000000" , ---nop

     "001000000000000000000000000000000000111111000" WHEN "111111000" , ---stop
     "000000000000000000000000000000000000000000000" WHEN OTHERS ;

END behavioral ;