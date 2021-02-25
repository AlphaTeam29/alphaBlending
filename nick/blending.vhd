library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library altera;
use altera.altera_syn_attributes.all;

entity blending is

	Port (
		nRESET	: IN STD_LOGIC; --not sure if reset is needed
		CLOCK		: IN STD_LOGIC;
		OUT_RED		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		OUT_GREEN		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		OUT_BLUE 		: OUT STD_LOGIC_VECTOR(7 downto 0);
		R_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		G_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		B_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		R_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		G_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		B_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		ALPHA_V	:  IN STD_LOGIC_VECTOR(7 downto 0) --alpha values can hold values from 0-15
		);
end entity blending;


architecture rtl of blending is
	--no constants needed
	
	--ports
	signal sigp_nreset : STD_LOGIC;
	signal sigp_clock : STD_LOGIC;
	signal	sigp_out_red			:	STD_LOGIC_VECTOR(7 downto 0);
	signal	sigp_out_green			:	STD_LOGIC_VECTOR(7 downto 0);
	signal	sigp_out_blue		:	STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_r_1			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_g_1			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_b_1			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_r_2			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_g_2			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_b_2			: STD_LOGIC_VECTOR(7 downto 0);
	signal sigp_alpha_v			: STD_LOGIC_VECTOR(7 downto 0);

begin

	--port assignments
	sigp_nreset <= nRESET;
	sigp_clock <= CLOCK;
	OUT_RED <= sigp_out_red;
	OUT_GREEN <= sigp_out_green;
	OUT_BLUE <= sigp_out_blue;
	sigp_r_1 <= R_1;
	sigp_g_1 <= G_1;
	sigp_b_1 <= B_1;
	sigp_r_2 <= R_2;
	sigp_g_2 <= G_2;
	sigp_b_2 <= B_2;
	sigp_alpha_v <= ALPHA_v;
	
	

clock_div: process(sigp_nreset, sigp_clock)
begin
	if (sigp_nreset = '0') then 	--if rest, set values to zero (white (?))
		sigp_out_red <= (others => '0');
		sigp_out_green <= (others => '0');
		sigp_out_blue <= (others => '0');
		--out = a*inA + (1-a) * inB  , where 0<a<1 , this is hard with decimals n stuff
		--out = (a *inA + inB*n - a*inB ) / n , where a alpha blending value = a/n , this helps with integer division
		elsif (rising_edge(sigp_clock)) then --temp change input values	

				sigp_out_red <= Std_logic_vector( To_unsigned(  
													(
													
													(
													To_integer(Unsigned(sigp_r_1)) 
													* To_integer(Unsigned(sigp_alpha_v)) 
													) 
													+
													(
													To_integer(Unsigned(sigp_r_2))
													*
													256
													)
													-
													(
													To_integer(Unsigned(sigp_r_2))
													* To_integer(Unsigned(sigp_alpha_v))
													)
													)
													/
													256
													,8));
													
		--out = a*inA + (1-a) * inB  , where 0<a<1 , this is hard with decimals n stuff
		--out = (a *inA + inB*n - a*inB ) / n , where a alpha blending value = a/n , this helps with integer division
		sigp_out_green <= Std_logic_vector( To_unsigned(  
													(
													
													(
													To_integer(Unsigned(sigp_g_1)) 
													* To_integer(Unsigned(sigp_alpha_v)) 
													) 
													+
													(
													To_integer(Unsigned(sigp_g_2))
													*
													256
													)
													-
													(
													To_integer(Unsigned(sigp_g_2))
													* To_integer(Unsigned(sigp_alpha_v))
													)
													)
													/
													256
													,8));

														--out = a*inA + (1-a) * inB  , where 0<a<1 , this is hard with decimals n stuff
		--out = (a *inA + inB*n - a*inB ) / n , where a alpha blending value = a/n , this helps with integer division
		sigp_out_blue <= Std_logic_vector( To_unsigned(  
													(
													
													(
													To_integer(Unsigned(sigp_b_1)) 
													* To_integer(Unsigned(sigp_alpha_v)) 
													) 
													+
													(
													To_integer(Unsigned(sigp_b_2))
													*
													256
													)
													-
													(
													To_integer(Unsigned(sigp_b_2))
													* To_integer(Unsigned(sigp_alpha_v))
													)
													)
													/
													256
													,8));
--		if sigp_r_1 = "1111" then
--			sigp_r_1 <= (others => '0');
--		elsif sigp_r_2 = "1111" then
--			sigp_r_1 <= std_logic_vector( unsigned( sigp_r_1) + 1 ) ;
--			sigp_r_2 <= (others => '0');
--		elsif sigp_b_1 = "1111" then
--			sigp_r_2 <= std_logic_vector( unsigned( sigp_r_2) + 1 ) ;
--			sigp_b_1 <= (others => '0');
--		elsif b_2 = "1111" then
--			sigp_b_1 <= std_logic_vector( unsigned( sigp_b_1) + 1 ) ;
--			sigp_b_2 <= (others => '0');
--		elsif sigp_g_1 = "1111" then
--			sigp_b_2 <= std_logic_vector( unsigned( sigp_b_2) + 1 ) ;
--			sigp_g_1 <= (others => '0');
--		elsif g_2 = "1111" then
--			sigp_g_1 <= std_logic_vector( unsigned( sigp_g_1) + 1 ) ;
--			sigp_g_2 <= (others => '0');
--		else	
--			sigp_g_2 <= std_logic_vector( unsigned( sigp_g_2) + 1 ) ;
--			
	end if;
		
end process clock_div;



	
end rtl;
	