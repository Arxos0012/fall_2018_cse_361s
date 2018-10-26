--- 2018 RSRC new "Multimaster RSRC VGA Testbench" VHDL Code 
--- Current file name:  testbench.vhd
--- Last Revised:  10/12/2018; 2:51 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY testbench IS
   PORT(clk       : IN  STD_LOGIC ;
        reset_l   : IN  STD_LOGIC ;
        read      : INOUT STD_LOGIC ;
        write     : INOUT STD_LOGIC ;
        done      : INOUT STD_LOGIC ;
        r         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        g         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        b         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        hs        : OUT STD_LOGIC ;
        vs        : OUT STD_LOGIC) ;
END testbench ;

ARCHITECTURE structure OF testbench IS

   COMPONENT clk_wiz_0
   PORT (clk_out1 : OUT STD_LOGIC;
         clk_out2 : OUT STD_LOGIC;
         clk_in1  : IN  STD_LOGIC);
   END COMPONENT;

   COMPONENT arbiter
   PORT (clk         : IN    STD_LOGIC ;
         request0    : IN    STD_LOGIC ;
         request1    : IN    STD_LOGIC ;
         reset_l     : IN    STD_LOGIC ;
         grant0      : OUT   STD_LOGIC ;
         grant1      : OUT   STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT rsrc
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        request  : OUT   STD_LOGIC ;
        grant    : IN    STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT eprom
      PORT(d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
           ce_l     : IN  STD_LOGIC ;
           oe_l     : IN  STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT sram
      PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
            address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
            ce_l     : IN    STD_LOGIC ;
            oe_l     : IN    STD_LOGIC ;
            we_l     : IN    STD_LOGIC ;
            clk      : IN    STD_LOGIC) ;
   END COMPONENT ;
   
   COMPONENT vga
   PORT(src_clk  : IN  STD_LOGIC ;
        ena      : IN  STD_LOGIC ;
        wea      : IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
        addra    : IN  STD_LOGIC_VECTOR(18 DOWNTO 0) ;
        dina     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0) ;
        vga_clk  : IN STD_LOGIC ;
        r        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        g        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        b        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        hs       : OUT STD_LOGIC ;
        vs       : OUT STD_LOGIC);
   END COMPONENT ;           

   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
   SIGNAL src_clk      : STD_LOGIC ;
   SIGNAL vga_clk      : STD_LOGIC ;
   SIGNAL d            : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL address      : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
---SIGNAL read         : STD_LOGIC;
---SIGNAL write        : STD_LOGIC;
---SIGNAL done         : STD_LOGIC;
   SIGNAL eprom_ce_l   : STD_LOGIC ;
   SIGNAL eprom_oe_l   : STD_LOGIC ;
   SIGNAL sram_ce_l    : STD_LOGIC ;
   SIGNAL sram_oe_l    : STD_LOGIC ;
   SIGNAL sram_we_l    : STD_LOGIC ;
   SIGNAL vga_ena      : STD_LOGIC;
   SIGNAL vga_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;

   SIGNAL request0     :  STD_LOGIC;
   SIGNAL request1     :  STD_LOGIC;
   SIGNAL grant0       :  STD_LOGIC;
   SIGNAL grant1       :  STD_LOGIC;

BEGIN

   arb1:arbiter
   PORT MAP(clk         => src_clk,
            request0    => request0,
            request1    => request1,
            reset_l     => reset_l,
            grant0      => grant0,
            grant1      => grant1);
            
   mydcm1:clk_wiz_0
   PORT MAP(clk_out1 => src_clk ,
            clk_out2 => vga_clk ,
            clk_in1  => clk) ;

   syncprocess:PROCESS(src_clk)
   BEGIN
      IF (src_clk = '1' AND src_clk'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

------------------------------------------------------------------------

   rsrc0:rsrc      
   PORT MAP(clk       => src_clk,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            request   => request0,
            grant     => grant0,
            done      => done);
   
   rsrc1:rsrc      
   PORT MAP(clk       => src_clk,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            request   => request1,
            grant     => grant1,
            done      => done);

------------------------------------------------------------------------
---done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR vga_ena = '1') ELSE 'Z' ;
------------------------------------------------------------------------

   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   eprom_oe_l <= '0' WHEN read = '1' ELSE '1' ;
   done <= '1' WHEN (eprom_ce_l = '0') ELSE 'Z' ;

   erpom1:eprom    
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => eprom_ce_l,
               oe_l      => eprom_oe_l);
 
------------------------------------------------------------------------

   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;
   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;
   done <= '1' WHEN (sram_ce_l = '0') ELSE 'Z' ;

   sram1:sram
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => sram_ce_l,
               oe_l      => sram_oe_l,
               we_l      => sram_we_l,
               clk       => src_clk);

------------------------------------------------------------------------

   vga_ena <= '1' WHEN address(31 DOWNTO 21) = "11111111111" ELSE '0' ;
   vga_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;
   done <= '1' WHEN (vga_ena = '1') ELSE 'Z' ;

   vga1:vga
   PORT MAP(src_clk   => src_clk,
            ena       => vga_ena,
            wea       => vga_wea,
            addra     => address(20 DOWNTO 2),
            dina      => d(8 DOWNTO 0),
            vga_clk   => vga_clk,
            r         => r,
            g         => g,
            b         => b,
            hs        => hs,
            vs        => vs);

------------------------------------------------------------------------

END structure;