----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:39:20 04/30/2017 
-- Design Name: 
-- Module Name:    SPI_master - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_master is
    Port ( clk           : in  STD_LOGIC;
           MISO          : in  STD_LOGIC;
           MOSI          : out  STD_LOGIC;
           sck           : out  STD_LOGIC;
           ss            : out  STD_LOGIC;
           data_in_slave : out  STD_LOGIC_VECTOR (7 downto 0);
           valid         : out  STD_LOGIC;
           data_in_master: in  STD_LOGIC_VECTOR (7 downto 0);
           en            : in  STD_LOGIC;
           busy          : out  STD_LOGIC);
end SPI_master;

architecture Behavioral of SPI_master is

signal master_data:STD_LOGIC_VECTOR (7 downto 0):=x"00";
signal slave_data:STD_LOGIC_VECTOR (7 downto 0):=x"00";
signal busy_sig:STD_LOGIC:='0';
signal sck_sig:STD_LOGIC:='0';
signal flag1:STD_LOGIC:='0';
signal flag2:STD_LOGIC:='0';
signal cnt:integer range 0 to 24:=0;
signal i:integer range 0 to 15:=0;
type state_machine is (s_wait , first_bit , s_sck);
signal state : state_machine:=s_wait;

begin
	
process(clk)
begin
	if(rising_edge(clk)) then
		case state is
			when s_wait =>
				ss<='1';
				valid<='0';
				if(en='1' and busy_sig='0') then 
					master_data<=data_in_master;
					busy_sig<='1';
					state<=first_bit;
				end if;
			when first_bit =>
				MOSI<=master_data(7);
				sck_sig<='0';
				ss<='0';
				cnt<=0;
				flag1<='1';
				flag2<='0';
				state<=s_sck;
			when s_sck =>
				cnt<=cnt+1;
				if(cnt=24) then 
					cnt<=0;
					sck_sig<=not sck_sig;
					i<=i+1;
					if(i=15)then
						i<=0;
						state<=s_wait;
						busy_sig<='0';
						data_in_slave<=slave_data;
						valid<='1';
					end if;	
				end if;
				if(flag1='1' and cnt=24) then
					master_data<=master_data(6 downto 0) & '0';
					slave_data<=slave_data(6 downto 0) & MISO;
					flag1<='0';
					flag2<='1';
				end if;
				if(flag2='1' and cnt=24) then
					MOSI<=master_data(7);
					flag1<='1';
					flag2<='0';
				end if;
		end case;
	end if;
end process;

busy<=busy_sig;
sck<=sck_sig;

end Behavioral;