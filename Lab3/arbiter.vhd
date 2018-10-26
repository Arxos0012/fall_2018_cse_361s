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
         request2    : IN    STD_LOGIC ;
         reset_l     : IN    STD_LOGIC ;
         grant0      : OUT   STD_LOGIC ;
         grant1      : OUT   STD_LOGIC ;
         grant2      : OUT   STD_LOGIC) ;
END arbiter ;

ARCHITECTURE behavioral of arbiter IS

   TYPE states IS (idle0, idle1, idle2, s0, s1, s2) ;

   SIGNAL state     : states ;
   SIGNAL nxt_state : states ;

 BEGIN

   clkd:PROCESS(clk)
      BEGIN
         IF (clk'EVENT AND clk='1') THEN
            IF (reset_l = '0') THEN 
               state <= idle0;
            ELSE
               state <= nxt_state;
            END IF;
         END IF;
      END PROCESS clkd;

   state_trans:PROCESS(request0,request1,request2,state)
      BEGIN
      CASE state IS
           when idle0 => if    (request0 = '1') then nxt_state <= s0;
                         elsif (request1 = '1') then nxt_state <= s1;
                         elsif (request2 = '1') then nxt_state <= s2;
                         else                        nxt_state <= idle0;
                         end if;
           when idle1 => if    (request1 = '1') then nxt_state <= s1;
                         elsif (request2 = '1') then nxt_state <= s2;
                         elsif (request0 = '1') then nxt_state <= s0;
                         else                        nxt_state <= idle1;
                         end if;
           when idle2 => if    (request2 = '1') then nxt_state <= s2;
                         elsif (request0 = '1') then nxt_state <= s0;
                         elsif (request1 = '1') then nxt_state <= s1;
                         else                        nxt_state <= idle2;
                         end if;
           when s0    => if (request0 = '1')    then nxt_state <= s0;
                         else                        nxt_state <= idle1;
                         end if;
           when s1    => if (request1 = '1')    then nxt_state <= s1;
                         else                        nxt_state <= idle2;
                         end if;
           when s2    => if (request2 = '1')    then nxt_state <= s2;
                         else                        nxt_state <= idle0;
                         end if;
      END CASE ;
   END PROCESS state_trans ;

   output:PROCESS(state) 
   BEGIN
      CASE state IS
           when idle0 =>
              grant0 <= '0';
              grant1 <= '0';
              grant2 <= '0';
           when idle1 =>
              grant0 <= '0';
              grant1 <= '0';
              grant2 <= '0';
           when idle2 =>
              grant0 <= '0';
              grant1 <= '0';
              grant2 <= '0';
           when s0    =>
              grant0 <= '1';
              grant1 <= '0';
              grant2 <= '0';
           when s1    =>
              grant0 <= '0';
              grant1 <= '1';
              grant2 <= '0';
           when s2    =>
              grant0 <= '0';
              grant1 <= '0';
              grant2 <= '1';
      END CASE ;
   END PROCESS output ;



END behavioral ; 
