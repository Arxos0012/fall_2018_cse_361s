--- Current "arbiter" VHDL Code 
--- Current file name: arbiter.vhd
--- Last Revised:  10/23/2008; 10:15 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D., 2008

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY arbiter IS
   PORT (clk         : IN    STD_LOGIC ;
         request0    : IN    STD_LOGIC ;
         request1    : IN    STD_LOGIC ;
         reset_l     : IN    STD_LOGIC ;
         grant0      : OUT   STD_LOGIC ;
         grant1      : OUT   STD_LOGIC) ;
END arbiter ;

ARCHITECTURE behavioral of arbiter IS

   TYPE states IS (s0, s1, s2) ;

   SIGNAL state     : states ;
   SIGNAL nxt_state : states ;

 BEGIN

   clkd:PROCESS(clk)
      BEGIN
         IF (clk'EVENT AND clk='1') THEN
            IF (reset_l = '0') THEN 
               state <= s0;
            ELSE
               state <= nxt_state;
            END IF;
         END IF;
      END PROCESS clkd;

   state_trans:PROCESS(request0,request1,state)
      BEGIN
      CASE state IS
         WHEN s0 => IF (request0 = '1') THEN
                       nxt_state <= s1 ;
                    ELSIF (request1 = '1') THEN
                       nxt_state <= s2 ;
                    ELSE
                       nxt_state <= s0 ;
                    END IF ;
         WHEN s1 => IF (request0 = '1') THEN
                       nxt_state <= s1 ;
                    ELSE
                       nxt_state <= s0 ;
                    END IF;
         WHEN s2 => IF (request1 = '1') THEN
                       nxt_state <= s2 ;
                    ELSE
                       nxt_state <= s0 ;
                    END IF;
      END CASE ;
   END PROCESS state_trans ;

   output:PROCESS(state) 
   BEGIN
      CASE state IS
         WHEN s0 =>
            grant0 <= '0' ;
            grant1 <= '0' ;
         WHEN s1 =>
            grant0 <= '1' ;
            grant1 <= '0' ; 
         WHEN s2 =>
            grant0 <= '0' ;
            grant1 <= '1' ;
      END CASE ;
   END PROCESS output ;

END behavioral ; 
