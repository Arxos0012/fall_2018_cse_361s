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

   TYPE states IS (idle012, idle021, idle102, idle120, idle201, idle210,
				   gr00, gr01, gr02, gr10, gr11, gr12) ;

   SIGNAL state     : states ;
   SIGNAL nxt_state : states ;

 BEGIN

	clkd:PROCESS(clk)
    BEGIN
        IF (clk'EVENT AND clk='1') THEN
            IF (reset_l = '0') THEN 
				state <= idle012;
            ELSE
				state <= nxt_state;
			END IF;
        END IF;
    END PROCESS clkd;
	
	
	
	state_trans:PROCESS(request0,request1,request2,state)
	BEGIN
		CASE state IS
			when idle012 => if	  (request0 = '1') then nxt_state <= gr00;
							elsif (request1 = '1') then nxt_state <= gr01;
							elsif (request2 = '1') then nxt_state <= gr02;
							else				        nxt_state <= idle012;
							end if;
			when idle021 => if	  (request0 = '1') then nxt_state <= gr10;
							elsif (request2 = '1') then nxt_state <= gr02;
							elsif (request1 = '1') then nxt_state <= gr01;
							else				        nxt_state <= idle021;
							end if;
			when idle102 => if	  (request1 = '1') then nxt_state <= gr01;
							elsif (request0 = '1') then nxt_state <= gr00;
							elsif (request2 = '1') then nxt_state <= gr12;
							else				        nxt_state <= idle102;
							end if;
			when idle120 => if	  (request1 = '1') then nxt_state <= gr11;
							elsif (request2 = '1') then nxt_state <= gr12;
							elsif (request0 = '1') then nxt_state <= gr00;
							else				        nxt_state <= idle120;
							end if;
			when idle201 => if	  (request2 = '1') then nxt_state <= gr02;
							elsif (request0 = '1') then nxt_state <= gr10;
							elsif (request1 = '1') then nxt_state <= gr11;
							else				        nxt_state <= idle201;
							end if;
			when idle210 => if	  (request2 = '1') then nxt_state <= gr12;
							elsif (request1 = '1') then nxt_state <= gr11;
							elsif (request0 = '1') then nxt_state <= gr10;
							else				        nxt_state <= idle210;
							end if;
							
			when gr00	 => if	  (request0 = '1') then nxt_state <= gr00;
							else				        nxt_state <= idle120;
							end if;
			when gr01	 => if	  (request1 = '1') then nxt_state <= gr01;
							else				        nxt_state <= idle021;
							end if;
			when gr02	 => if	  (request2 = '1') then nxt_state <= gr02;
							else				        nxt_state <= idle012;
							end if;
			when gr10	 => if	  (request0 = '1') then nxt_state <= gr10;
							else				        nxt_state <= idle210;
							end if;
			when gr11	 => if	  (request1 = '1') then nxt_state <= gr11;
							else				        nxt_state <= idle201;
							end if;
			when gr12	 => if	  (request2 = '1') then nxt_state <= gr12;
							else				        nxt_state <= idle102;
							end if;

		END CASE ;
	END PROCESS state_trans ;
	
	
	
	output:PROCESS(state) 
	BEGIN
		CASE state IS
			when gr00 | gr10 =>
				grant0 <= '1';
				grant1 <= '0';
				grant2 <= '0';
			when gr01 | gr11 =>
				grant0 <= '0';
				grant1 <= '1';
				grant2 <= '0';
			when gr02 | gr12 =>
				grant0 <= '0';
				grant1 <= '0';
				grant2 <= '1';
			when others =>
				grant0 <= '0';
				grant1 <= '0';
				grant2 <= '0';
		END CASE ;
	END PROCESS output ;



END behavioral ; 
