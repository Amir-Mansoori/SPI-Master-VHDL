--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:17:41 04/30/2017
-- Design Name:   
-- Module Name:   D:/FPGA/SPI_master_final/SPI_master/master_tb.vhd
-- Project Name:  SPI_master
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI_master
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY master_tb IS
END master_tb;
 
ARCHITECTURE behavior OF master_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPI_master
    PORT(
         clk : IN  std_logic;
         MISO : IN  std_logic;
         MOSI : OUT  std_logic;
         sck : OUT  std_logic;
         ss : OUT  std_logic;
         data_in_slave : OUT  std_logic_vector(7 downto 0);
         valid : OUT  std_logic;
         data_in_master : IN  std_logic_vector(7 downto 0);
         en : IN  std_logic;
         busy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal MISO : std_logic := '0';
   signal data_in_master : std_logic_vector(7 downto 0) := (others => '0');
   signal en : std_logic := '0';

 	--Outputs
   signal MOSI : std_logic;
   signal sck : std_logic;
   signal ss : std_logic;
   signal data_in_slave : std_logic_vector(7 downto 0);
   signal valid : std_logic;
   signal busy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI_master PORT MAP (
          clk => clk,
          MISO => MISO,
          MOSI => MOSI,
          sck => sck,
          ss => ss,
          data_in_slave => data_in_slave,
          valid => valid,
          data_in_master => data_in_master,
          en => en,
          busy => busy
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		en<='1';
		data_in_master<=x"A2";
		miso<='1';
		wait for 1030 ns;
		
		miso<='0';
		wait for 1000 ns;

		miso<='1';
		wait for 1000 ns;

		miso<='0';
		wait for 1000 ns;

		miso<='0';
		wait for 1000 ns;

		miso<='1';
		wait for 1000 ns;

		miso<='0';
		wait for 1000 ns;

		miso<='1';
		wait for 1000 ns;
		
		data_in_master<=x"F8";
      wait;
   end process;

END;
