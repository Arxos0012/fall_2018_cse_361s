--- 2018 RSRC new "testbench" VHDL Code 
--- Current file name:  testbench.vhd
--- Last Revised:  8/22/2018; 3:05 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY testbench IS
   PORT(clk:      IN    STD_LOGIC;
        reset_l:  IN    STD_LOGIC;
        r:        OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        g:        OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        b:        OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        hs:       OUT   STD_LOGIC;
        vs:       OUT   STD_LOGIC);
END testbench ;

ARCHITECTURE structure OF testbench IS

   COMPONENT rsrc
      PORT(clk      : IN    STD_LOGIC ;
           reset_l  : IN    STD_LOGIC ;
           d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           read     : OUT   STD_LOGIC ;
           write    : OUT   STD_LOGIC ;
           done     : IN    STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT blk_mem_gen_1
      PORT (clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
   END COMPONENT ;

   COMPONENT sram
      PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
            address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
            ce_l     : IN    STD_LOGIC ;
            oe_l     : IN    STD_LOGIC ;
            we_l     : IN    STD_LOGIC ;
            clk      : IN    STD_LOGIC) ;
   END COMPONENT ;
   
   COMPONENT clk_wiz_0 
      PORT (clk_out1 : OUT STD_LOGIC; 
            clk_out2 : OUT STD_LOGIC; 
            clk_in1  : IN  STD_LOGIC); 
   END COMPONENT; 
   
   COMPONENT vga
      PORT (src_clk   : IN  STD_LOGIC ;
            ena       : IN  STD_LOGIC ;
            wea       : IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
            addra     : IN  STD_LOGIC_VECTOR(18 DOWNTO 0) ;
            dina      : IN  STD_LOGIC_VECTOR(8 DOWNTO 0) ;
            vga_clk   : IN  STD_LOGIC ;
            r         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
            g         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
            b         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
            hs        : OUT STD_LOGIC ;
            vs        : OUT STD_LOGIC);
   END COMPONENT;

   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
   SIGNAL d            :  STD_LOGIC_VECTOR(31 downto 0):= "00000000000000000000000000000000" ;
   SIGNAL mem_out      :  STD_LOGIC_VECTOR(31 downto 0):= "00000000000000000000000000000000" ;
   SIGNAL address      :  STD_LOGIC_VECTOR(31 downto 0):= "00000000000000000000000000000000" ;
   SIGNAL read         :  STD_LOGIC ;
   SIGNAL write        :  STD_LOGIC ;
   SIGNAL done         :  STD_LOGIC ;
   SIGNAL eprom_ce_l   :  STD_LOGIC ;
   SIGNAL eprom_ce_h   :  STD_LOGIC ;
   SIGNAL eprom_oe_l   :  STD_LOGIC ;
   SIGNAL sram_ce_l    :  STD_LOGIC ;
   SIGNAL sram_oe_l    :  STD_LOGIC ;
   SIGNAL sram_we_l    :  STD_LOGIC ;
   SIGNAL src_clk      :  STD_LOGIC ;
   SIGNAL vga_clk      :  STD_LOGIC ;
   SIGNAL vga_ena      :  STD_LOGIC ;
   SIGNAL vga_wea      :  STD_LOGIC_VECTOR(0 DOWNTO 0) ;

   type states is (s0, s1, s2);
   signal state: states := s0;
   signal nxt_state: states := s0;

BEGIN

   syncprocess:PROCESS(clk)
   begin
      IF (clk = '1' AND clk'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;
   
   fetch_mem:process(src_clk)
   begin
        if (src_clk = '1' AND src_clk'event) then
            if(reset_l_sync = '0') then
                state <= s0;
            else
                state <= nxt_state;
            end if;
        end if;
    end process fetch_mem;
    
    state_trans: process(state, eprom_ce_l)
    begin
        nxt_state <= state;
            case state is
                when s0 => if (eprom_ce_l = '0') then
                                nxt_state <= s1;
                           end if;
                when s1 => nxt_state <= s2;
                when s2 => nxt_state <= s0;
            end case;
    end process state_trans;
        
   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;

   eprom_oe_l <= '0' WHEN (state = s2 AND read = '1') ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;
   
   vga_wea <= "1" WHEN (write = '1') ELSE "0";
   vga_ena <= '1' WHEN (address(31 DOWNTO 21) = "11111111111") ELSE '0';
   
   done <= '1' WHEN (state = s2 OR sram_ce_l = '0' OR vga_ena = '1') ELSE '0' ;
   
   d <= mem_out WHEN eprom_oe_l = '0' ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
   
   eprom_ce_h <= (not eprom_ce_l);
   
   rsrc1:rsrc      
      PORT MAP(clk       => src_clk,
               reset_l   => reset_l_sync,
               d         => d,
               address   => address,
               read      => read,
               write     => write,
               done      => done);

   erpom1:blk_mem_gen_1    
      PORT MAP(clka      => src_clk,
               addra     => address(11 DOWNTO 2),
               douta     => mem_out,
               ena      => eprom_ce_h);
 
   sram1:sram
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => sram_ce_l,
               oe_l      => sram_oe_l,
               we_l      => sram_we_l,
               clk       => src_clk);
    
    dcm1:clk_wiz_0
      PORT MAP(clk_out1  => src_clk,
               clk_out2  => vga_clk,
               clk_in1   => clk);
               
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
    
END structure;
