--------------------------------------------------------------
 --     Copyright (c) 2012-2024 Anlogic Inc.
 --  All Right Reserved.
--------------------------------------------------------------
 -- Log	:	This file is generated by Anlogic IP Generator.
 -- File	:	F:/DJS130/DJS130_final/al_ip/PLL.vhd
 -- Date	:	2024 11 12
 -- TD version	:	5.6.119222
--------------------------------------------------------------

-------------------------------------------------------------------------------
--	Input frequency:               24.000000MHz
--	Clock multiplication factor: 1
--	Clock division factor:       2
--	Clock information:
--		Clock name	| Frequency 	| Phase shift
--		C0        	| 12.000000 MHZ	| 0.0000  DEG  
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY eagle_macro;
USE eagle_macro.EAGLE_COMPONENTS.ALL;

ENTITY PLL IS
  PORT (
    refclk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    extlock : OUT STD_LOGIC;
    clk0_out : OUT STD_LOGIC 
  );
END PLL;

ARCHITECTURE rtl OF PLL IS
  SIGNAL clk0_buf :  STD_LOGIC;
  SIGNAL fbk_wire :  STD_LOGIC;
  SIGNAL clkc_wire :  STD_LOGIC_VECTOR (4 DOWNTO 0);
BEGIN
  bufg_feedback : EG_LOGIC_BUFG
  PORT MAP (
    i => clk0_buf,
    o => fbk_wire 
  );

  pll_inst : EG_PHY_PLL
  GENERIC MAP (
    DPHASE_SOURCE => "DISABLE",
    DYNCFG => "DISABLE",
    FIN => "24.000000",
    FEEDBK_MODE => "NORMAL",
    FEEDBK_PATH => "CLKC0_EXT",
    STDBY_ENABLE => "DISABLE",
    PLLRST_ENA => "ENABLE",
    SYNC_ENABLE => "DISABLE",
    GMC_GAIN => 0,
    ICP_CURRENT => 9,
    KVCO => 2,
    LPF_CAPACITOR => 2,
    LPF_RESISTOR => 8,
    REFCLK_DIV => 2,
    FBCLK_DIV => 1,
    CLKC0_ENABLE => "ENABLE",
    CLKC0_DIV => 83,
    CLKC0_CPHASE => 82,
    CLKC0_FPHASE => 0 
  )
  PORT MAP (
    refclk => refclk,
    reset => reset,
    stdby => '0',
    extlock => extlock,
    load_reg => '0',
    psclk => '0',
    psdown => '0',
    psstep => '0',
    psclksel => b"000",
    dclk => '0',
    dcs => '0',
    dwe => '0',
    di => b"00000000",
    daddr => b"000000",
    fbclk => fbk_wire,
    clkc => clkc_wire 
  );

  clk0_out <= fbk_wire;
  clk0_buf <= clkc_wire(0);

END rtl;
