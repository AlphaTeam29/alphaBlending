library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library altera;
use altera.altera_syn_attributes.all;

entity displayController is

	Port (
		--clock 1000hz
		CLOCK		: IN STD_LOGIC;
		RED		: OUT	STD_LOGIC;
		GREEN		: OUT	STD_LOGIC;
		BLUE 		: OUT STD_LOGIC;
		D_ENABLE : OUT STD_LOGIC;
		nRESET	: IN STD_LOGIC;
		H_SYNC	:	OUT STD_LOGIC;
		V_SYNC	: OUT STD_LOGIC
		);
end entity displayController;


architecture rtl of displayController is
	--question requirements
	constant v_const_hsync : STD_LOGIC_VECTOR (12 downto 0) :=   "0000000000010"; --hsync = 2
	constant v_const_hbp : STD_LOGIC_VECTOR (12 downto 0) := 	 "0000000000110"; --back porch = 6
	constant v_const_hfp : STD_LOGIC_VECTOR (12 downto 0) :=	 	 "0000000000100"; --front porch = 4
	constant const_hdv_end : STD_LOGIC_VECTOR (12 downto 0) := 	 "0000000010011"; --active frame = 20 (we write 19 since 0 is included)
	
	constant v_const_vsync : STD_LOGIC_VECTOR (12 downto 0) := 	 "0000000000001"; --vsync = 1
	constant v_const_vbp : STD_LOGIC_VECTOR (12 downto 0) := 	 "0000000000011"; --back porch = 3
	constant v_const_vfp : STD_LOGIC_VECTOR (12 downto 0) :=	 	 "0000000000001"; --front porch = 1
	constant const_vdv_end : STD_LOGIC_VECTOR (12 downto 0) := 	 "0000000001001"; --active frame = 10 (we write 9 since 0 is included)
	--ending counter times
	constant const_hfp_end : STD_LOGIC_VECTOR (12 downto 0) := v_const_hfp + const_hdv_end;  --fp ends at this clock (20 + 4)
	constant const_hsync_end : STD_LOGIC_VECTOR (12 downto 0) := const_hfp_end + v_const_hsync; --hsync ends at this clock (24 + 2)
	constant const_hbp_end 	:	STD_LOGIC_VECTOR (12 downto 0) := const_hsync_end + v_const_hbp; --hsync ends at this clock (32), end of horiz line
	
	constant const_vfp_end : STD_LOGIC_VECTOR (12 downto 0) := v_const_vfp + const_vdv_end;  --fp ends at this clock (10 + 1)
	constant const_vsync_end : STD_LOGIC_VECTOR (12 downto 0) := const_vfp_end + v_const_vsync; --vsync ends at this clock (11 + 1)
	constant const_vbp_end 	:	STD_LOGIC_VECTOR (12 downto 0) := const_vsync_end + v_const_vbp; --vsync ends at this clock (15), end of vertical line
	--counters
	signal sig_vcounter : STD_LOGIC_VECTOR (12 downto 0) := "0000000000000";
	signal sig_hcounter : STD_LOGIC_VECTOR (12 downto 0) := "0000000000000";
	
	--ports
	signal sigp_clock : STD_LOGIC;
	signal	sigp_red			:	STD_LOGIC;
	signal	sigp_green			:	STD_LOGIC;
	signal	sigp_blue		:	STD_LOGIC;
	signal sigp_nreset 		:	STD_LOGIC;
	signal	sigp_hsync		:	STD_LOGIC;
	signal sigp_vsync 		:	STD_LOGIC;	
	signal sigp_d_enable 	: STD_LOGIC;
	
begin

	--port assignments
	sigp_nreset <= nRESET;
	sigp_clock <= CLOCK;
	RED <= sigp_red;
	GREEN <= sigp_green;
	BLUE <= sigp_blue;
	H_SYNC <= sigp_hsync;
	V_SYNC <= sigp_vsync;
	D_ENABLE <= sigp_d_enable;

clock_div: process(sigp_nreset, sigp_clock)
begin
	if (sigp_nreset = '0') then
		--set sig counter to all zero (others do this)
		sig_vcounter <= (others => '0');
		sig_hcounter <= (others => '0');
	elsif (rising_edge(sigp_clock)) then
		--if finised with last row than reset
		if (sig_vcounter = const_vbp_end and sig_hcounter = const_hbp_end) then
			sig_hcounter <= (others => '0');
			sig_vcounter <= (others => '0');
		--if not in data valid of vertical than go to next row
--		elsif (sig_vcounter > const_vdv_end) then 
--			sig_vcounter <= sig_vcounter + '1' ;
		--else if at the end of horizontal line then go to next row
		elsif (sig_hcounter = const_hbp_end) then
			sig_hcounter <= (others => '0');
			sig_vcounter <= sig_vcounter + '1' ;
		--else go to next pixel in row
		else
			sig_hcounter <= sig_hcounter + '1' ;
		end if;
	end if;
		
end process clock_div;

sigp_d_enable <= '1' when (sig_hcounter <= const_hdv_end) and (sig_vcounter <= const_vdv_end) else '0';

sigp_red <= '1' when sigp_d_enable = '1' else '0';
sigp_blue <= '1' when sigp_d_enable = '1' else '0';
sigp_green <= '1' when sigp_d_enable = '1' else '0';

sigp_hsync <= '0' when (sig_hcounter > const_hfp_end) and (sig_hcounter <= const_hsync_end) else '1';
sigp_vsync <= '0' when (sig_vcounter > const_vfp_end) and (sig_vcounter <= const_vsync_end) else '1';


end rtl;
	