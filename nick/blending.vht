-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/17/2021 12:24:49"
                                                            
-- Vhdl Test Bench template for design  :  blending
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use IEEE.NUMERIC_STD.ALL;

ENTITY blending_vhd_tst IS
END blending_vhd_tst;
ARCHITECTURE blending_arch OF blending_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ALPHA_V : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
SIGNAL B_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL B_2 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
SIGNAL CLOCK : STD_LOGIC := '0';
SIGNAL G_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL G_2 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
SIGNAL nRESET : STD_LOGIC := '0';
SIGNAL OUT_BLUE : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL OUT_GREEN : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL OUT_RED : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL R_1 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
SIGNAL R_2 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
COMPONENT blending
	PORT (
	ALPHA_V : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	B_1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	B_2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	CLOCK : IN STD_LOGIC;
	G_1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	G_2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	nRESET : IN STD_LOGIC;
	OUT_BLUE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	OUT_GREEN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	OUT_RED : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	R_1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	R_2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : blending
	PORT MAP (
-- list connections between master ports and signals
	ALPHA_V => ALPHA_V,
	B_1 => B_1,
	B_2 => B_2,
	CLOCK => CLOCK,
	G_1 => G_1,
	G_2 => G_2,
	nRESET => nRESET,
	OUT_BLUE => OUT_BLUE,
	OUT_GREEN => OUT_GREEN,
	OUT_RED => OUT_RED,
	R_1 => R_1,
	R_2 => R_2
	);
		--Clock is 4800 Hz = 32 * 15 * 10
	CLOCK <= not CLOCK after 104us;  
init : PROCESS                                               
-- variable declarations                                   
BEGIN                                                        
        -- code that executes only once  
nRESET <= '1' after 3000ns;		  
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
( CLOCK       )                                                 
-- variable declarations                                      
BEGIN                                                         	
	if (falling_edge(CLOCK)) then --temp change input values	
      -- code executes for every event on sensitivity list 
		 if R_1 = "1111" then
			R_1 <= (others => '0');
		elsif R_2 = "1111" then
			R_1 <= std_logic_vector( unsigned( R_1) + 1 ) ;
			R_2 <= (others => '0');
		elsif B_1 = "1111" then
			R_2 <= std_logic_vector( unsigned( R_2) + 1 ) ;
			B_1 <= (others => '0');
		elsif B_2 = "1111" then
			B_1 <= std_logic_vector( unsigned( B_1) + 1 ) ;
			B_2 <= (others => '0');
		elsif G_1 = "1111" then
			B_2 <= std_logic_vector( unsigned( B_2) + 1 ) ;
			G_1 <= (others => '0');
		elsif G_2 = "1111" then
			G_1 <= std_logic_vector( unsigned( G_1) + 1 ) ;
			G_2 <= (others => '0');
		else	
			G_2 <= std_logic_vector( unsigned( G_2) + 1 ) ;
			
		end if; 
	end if;
                                                      
END PROCESS always;                                          
END blending_arch;
