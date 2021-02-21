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
-- Generated on "12/09/2020 18:24:19"
                                                            
-- Vhdl Test Bench template for design  :  displayController
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY displayController_vhd_tst IS
END displayController_vhd_tst;
ARCHITECTURE displayController_arch OF displayController_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL BLUE : STD_LOGIC;
SIGNAL CLOCK : STD_LOGIC := '0';
SIGNAL GREEN : STD_LOGIC;
SIGNAL H_SYNC : STD_LOGIC;
SIGNAL nRESET : STD_LOGIC := '0';
SIGNAL RED : STD_LOGIC;
SIGNAL V_SYNC : STD_LOGIC;
SIGNAL D_ENABLE : STD_LOGIC;
COMPONENT displayController
	PORT (
	BLUE : OUT STD_LOGIC;
	CLOCK : IN STD_LOGIC ;
	GREEN : OUT STD_LOGIC;
	H_SYNC : OUT STD_LOGIC;
	nRESET : IN STD_LOGIC;
	RED : OUT STD_LOGIC;
	V_SYNC : OUT STD_LOGIC;
	D_ENABLE : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : displayController
	PORT MAP (
-- list connections between master ports and signals
	BLUE => BLUE,
	CLOCK => CLOCK,
	GREEN => GREEN,
	H_SYNC => H_SYNC,
	nRESET => nRESET,
	RED => RED,
	V_SYNC => V_SYNC,
	D_ENABLE => D_ENABLE
	);
	--Clock is 4800 Hz = 32 * 15 * 10
	CLOCK <= not CLOCK after 104us;
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once
			-- code that executes only once    
			nRESET <= '1' after 3000ns;
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END displayController_arch;
