library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


library altera;
use altera.altera_syn_attributes.all;

entity blend_to_display is

	Port (
		nRESET : IN STD_LOGIC;
		WRITE_CLOCK : IN STD_LOGIC;
		READ_CLOCK : IN STD_LOGIC;
		R_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		G_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		B_1		: IN STD_LOGIC_VECTOR(7 downto 0);
		R_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		G_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		B_2		: IN STD_LOGIC_VECTOR(7 downto 0);
		OUT_RED		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		OUT_GREEN		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		OUT_BLUE 		: OUT STD_LOGIC_VECTOR(7 downto 0);
		DATA_ENABLE : OUT STD_LOGIC;
		H_SYNC	:	OUT STD_LOGIC;
		V_SYNC	: OUT STD_LOGIC;
		TEST_W_REQ_RGB : OUT STD_LOGIC_VECTOR(24 downto 0);
		TEST_R_REQ_RGB : OUT STD_LOGIC_VECTOR(25 downto 0);

		ALPHA_V	:  IN STD_LOGIC_VECTOR(7 downto 0) --alpha values can hold values from 0-255

		);
end entity blend_to_display;


architecture rtl of blend_to_display is
	signal read_rgb : STD_LOGIC_VECTOR(23 downto 0);
	alias read_red : STD_LOGIC_VECTOR (7 downto 0) IS read_rgb(23 downto 16);
	alias read_green : STD_LOGIC_VECTOR (7 downto 0) IS read_rgb(15 downto 8);
	alias read_blue : STD_LOGIC_VECTOR (7 downto 0) IS read_rgb(7 downto 0);
	signal write_rgb : STD_LOGIC_VECTOR(23 downto 0);
	alias write_red : STD_LOGIC_VECTOR (7 downto 0) IS write_rgb(23 downto 16);
	alias write_green : STD_LOGIC_VECTOR (7 downto 0) IS write_rgb(15 downto 8);
	alias write_blue : STD_LOGIC_VECTOR (7 downto 0) IS write_rgb(7 downto 0);
	signal write_req, read_req, full, empty : STD_LOGIC;
	--ports
	signal sigp_r_clock, sigp_w_clock, sigp_data_enable : STD_LOGIC;
	signal sigp_test_w_req_rgb : STD_LOGIC_VECTOR(24 downto 0);
	signal sigp_test_r_req_rgb : STD_LOGIC_VECTOR(25 downto 0);

	component fifio_out is
		PORT
		(
			data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdempty		: OUT STD_LOGIC ;
			wrfull		: OUT STD_LOGIC 
		);
	end component;
	
	component blending is
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
	end component;
	
	component displayController is
		Port (
			--clock 1000hz
			CLOCK		: IN STD_LOGIC;
			OUT_RED		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			OUT_GREEN		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			OUT_BLUE 		: OUT STD_LOGIC_VECTOR(7 downto 0);
			IN_RED		: IN	STD_LOGIC_VECTOR(7 downto 0);
			IN_GREEN		: IN	STD_LOGIC_VECTOR(7 downto 0);
			IN_BLUE 		: IN STD_LOGIC_VECTOR(7 downto 0);
			D_ENABLE : OUT STD_LOGIC;
			nRESET	: IN STD_LOGIC;
			H_SYNC	:	OUT STD_LOGIC;
			V_SYNC	: OUT STD_LOGIC
			);
	end component displayController;

begin

	blender : blending PORT MAP (
											nRESET => nRESET,
											CLOCK		=> WRITE_CLOCK,
											OUT_RED		=> write_red,
											OUT_GREEN 	=> write_green,
											OUT_BLUE  	=> write_blue,
											R_1		=> R_1,
											G_1		=> G_1,
											B_1		=> B_1,
											R_2		=> R_2,
											G_2		=> G_2,
											B_2		=> B_2, 
											ALPHA_V	=>  ALPHA_V
											);
											
	displayer : displayController PORT MAP (
														CLOCK			=> READ_CLOCK,
														OUT_RED		=> OUT_RED,
														OUT_GREEN	=> OUT_GREEN,
														OUT_BLUE 	=> OUT_BLUE, 
														IN_RED		=> read_red,
														IN_GREEN		=> read_green,
														IN_BLUE 		=> read_blue,
														D_ENABLE 	=> sigp_data_enable,
														nRESET		=> nRESET,
														H_SYNC		=> H_SYNC,
														V_SYNC		=> V_SYNC
														);
	fifo : fifio_out PORT MAP (
										data			=>  write_rgb,
										rdclk			=> READ_CLOCK,
										rdreq			=> read_req,
										wrclk			=> WRITE_CLOCK,
										wrreq			=> write_req,
										q				=> read_rgb,
										rdempty		=> empty,
										wrfull		=> full
										);	
	
	sigp_r_clock <= READ_CLOCK;
	sigp_w_clock <= WRITE_CLOCK;
	DATA_ENABLE <= sigp_data_enable;
	TEST_W_REQ_RGB <= sigp_test_w_req_rgb;
	TEST_R_REQ_RGB <= sigp_test_r_req_rgb;

	
write_process: process(sigp_w_clock)
begin
	if (rising_edge(sigp_w_clock)) then
		if (full = '1') then
			write_req <= '0';
		else 
			write_req <= '1';
		end if;
	end if;
		
end process write_process;

read_process: process(sigp_r_clock) 
begin
	if  (rising_edge(sigp_r_clock)) then
		if (empty = '1' or (sigp_data_enable = '0' )) then
			read_req <= '0';
		else 
			read_req <= '1';
		end if;
	end if;
		
end process read_process;

			sigp_test_w_req_rgb <= write_req & write_rgb;
			sigp_test_r_req_rgb <= empty & read_req & read_rgb;
--read_req <= '0' when (empty = '1' or (sigp_data_enable = '0' )) else '1';
--			write_req <= '0'when (full = '1') else '1';

	


end rtl;
