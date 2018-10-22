--- 2018 RSRC new "Multimaster RSRC VGA Simulation Wrapper" VHDL Code 
--- Current file name:  simulationwrapper.vhd
--- Last Revised:  10/8/2018; 12:01 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY wrapper IS
   PORT(clk       : IN  STD_LOGIC;
        reset_l   : IN  STD_LOGIC;
        r         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        g         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        b         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        hs        : OUT STD_LOGIC ;
        vs        : OUT STD_LOGIC);
END wrapper ;

ARCHITECTURE structure OF wrapper IS

   COMPONENT testbench
   PORT(clk       : IN    STD_LOGIC ;
        reset_l   : IN    STD_LOGIC ;
        read      : INOUT STD_LOGIC ;
        write     : INOUT STD_LOGIC ;
        done      : INOUT STD_LOGIC ;
        r         : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        g         : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        b         : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        hs        : OUT   STD_LOGIC ;
        vs        : OUT   STD_LOGIC) ;
   END COMPONENT ;

   SIGNAL read  : STD_LOGIC ;
   SIGNAL write : STD_LOGIC ;
   SIGNAL done  : STD_LOGIC ;

BEGIN

   read  <= 'L' ;
   write <= 'L' ;
   done  <= 'L' ;

   testbench1:testbench
   PORT MAP(clk       => clk,
            reset_l   => reset_l,
            read      => read,
            write     => write,
            done      => done,
            r         => r,
            g         => g,
            b         => b,
            hs        => hs,
            vs        => vs);

END structure;