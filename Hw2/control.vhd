--- Current RSRC "control" VHDL Code 
--- Current file name: control.vhd
--- Last Revised:  7/5/2018; 9:15 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D., 2018

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY control IS
   PORT (clk         : IN    STD_LOGIC ;
         opcode      : IN    STD_LOGIC_VECTOR(4 DOWNTO 0) ;
         con         : IN    STD_LOGIC ;
         done        : IN    STD_LOGIC ;
         reset_l     : IN    STD_LOGIC ;
         a_in        : OUT   STD_LOGIC ;
         c_in        : OUT   STD_LOGIC ;
         c_out       : OUT   STD_LOGIC ;
         pc_in       : OUT   STD_LOGIC ;
         pc_out      : OUT   STD_LOGIC ;
         c1_out      : OUT   STD_LOGIC ;
         c2_out      : OUT   STD_LOGIC ;
         ir_in       : OUT   STD_LOGIC ;
         gra         : OUT   STD_LOGIC ;
         grb         : OUT   STD_LOGIC ;
         grc         : OUT   STD_LOGIC ;
         r_in        : OUT   STD_LOGIC ;
         r_out       : OUT   STD_LOGIC ;
         ba_out      : OUT   STD_LOGIC ;
         md_bus      : OUT   STD_LOGIC ;
         md_rd       : OUT   STD_LOGIC ;
         md_wr       : OUT   STD_LOGIC ;
         md_out      : OUT   STD_LOGIC ;
         ma_in       : OUT   STD_LOGIC ;
         read        : OUT   STD_LOGIC ;
         write       : OUT   STD_LOGIC ;
         add         : OUT   STD_LOGIC ;
         sub         : OUT   STD_LOGIC ;
         andx        : OUT   STD_LOGIC ;
         orx         : OUT   STD_LOGIC ;
         notx        : OUT   STD_LOGIC ;
         neg         : OUT   STD_LOGIC ;
         c_eq_b      : OUT   STD_LOGIC ;
         inc4        : OUT   STD_LOGIC ;
         shr         : OUT   STD_LOGIC ;
         shra        : OUT   STD_LOGIC ;
         shl         : OUT   STD_LOGIC ;
         shc         : OUT   STD_LOGIC) ;

END control ;

ARCHITECTURE behavioral of control IS

   COMPONENT controlstore
   PORT (d        : OUT STD_LOGIC_VECTOR(44 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(8 DOWNTO 0)) ;
   END COMPONENT ;

   SIGNAL upc         : STD_LOGIC_VECTOR(8 DOWNTO 0) ;
   SIGNAL d           : STD_LOGIC_VECTOR(44 DOWNTO 0) ;
   SIGNAL brcondition : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
   SIGNAL braddress   : STD_LOGIC_VECTOR(8 DOWNTO 0) ;

BEGIN

   clkd:PROCESS(clk)
   BEGIN
      IF (clk'EVENT AND clk='1') THEN
         IF (reset_l = '0') THEN 
            upc <= "000000000" ;
         ELSIF (brcondition = "000") THEN
            upc <= upc + 1 ;
         ELSIF (brcondition = "001") THEN
            upc <= braddress ;
         ELSIF (brcondition = "010") THEN
            upc <= ('1' & opcode & "000") ;
         ELSIF (brcondition = "011") THEN
            IF (con = '1') THEN
               upc <= braddress ;
            ELSE
               upc <= upc + 1 ;
            END IF ;
         ELSIF (brcondition = "101") THEN
            IF (done = '0') THEN
               upc <= braddress ;
            ELSE
               upc <= upc + 1 ;
            END IF ;
         ELSE
            upc <= upc + 1 ;
         END IF;
      END IF;
   END PROCESS clkd;

   mycontrolstore:controlstore
   PORT MAP (d       => d ,
             address => upc) ;

      a_in     <= d(41) ;   
      c_in     <= d(40) ;
      c_out    <= d(39) ;
      pc_in    <= d(38) ;
      pc_out   <= d(37) ;
      c1_out   <= d(36) ;
      c2_out   <= d(35) ;
      ir_in    <= d(34) ;
      gra      <= d(33) ;
      grb      <= d(32) ;
      grc      <= d(31) ;
      r_in     <= d(30) ;
      r_out    <= d(29) ;
      ba_out   <= d(28) ;
      md_bus   <= d(27) ;
      md_rd    <= d(26) ;
      md_wr    <= d(25) ;
      md_out   <= d(24) ;
      ma_in    <= d(23) ;
      read     <= d(22) ;
      write    <= d(21) ;
      add      <= d(20) ;
      sub      <= d(19) ;
      andx     <= d(18) ;
      orx      <= d(17) ;
      notx     <= d(16) ;
      neg      <= d(15) ;
      c_eq_b   <= d(14) ;
      inc4     <= d(13) ;
      shr      <= d(12) ;
      shra     <= d(11) ;
      shl      <= d(10) ;
      shc      <= d(9) ;

      braddress <= d(8 DOWNTO 0) ;
      brcondition <= d(44 DOWNTO 42) ;

END behavioral ; 
