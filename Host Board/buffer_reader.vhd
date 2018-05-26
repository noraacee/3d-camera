library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer_reader is
generic (
	pixel_buffer_base  : std_logic_vector := x"00025800"
);

port (
	clk 		  	  : in std_logic;
	rst           : in std_logic;
	clk_in        : in std_logic; --used only for debugging purposes, can connect to key and change process sensitivity list
	
	--incoming and outgoing signals to the GPIO pins
	pixel_set     : in std_logic;
	pixel_offset  : in std_logic_vector(17 downto 0);
	pixel_ready   : out std_logic;
	pixel 		  : out std_logic_vector(15 downto 0);
	
	--Avalon MM master to read from the pixel buffer
	master_r_wait : in std_logic;
	master_rd     : in std_logic_vector(15 downto 0);
	master_rd_en  : out std_logic;
	master_r_addr : out std_logic_vector(31 downto 0);
	master_r_be   : out std_logic_vector(1 downto 0);
	
	--for debugging purposes only
	red_led       : out std_logic_vector(1 downto 0)
);
end buffer_reader;

architecture behavioural of buffer_reader is 
begin

process(clk, rst)
	variable state        : std_logic_vector(1 downto 0);
	variable p            : std_logic_vector(15 downto 0);
	variable ready        : std_logic := '0';
begin
	if (rst = '0') then
		red_led(1 downto 0) <= "11";
		pixel_ready <= '0';
		ready 		:= '0';
		state 		:= "11";
	elsif (rising_edge(clk)) then
		case state is
			when "00" =>
				ready := '0';
				if (pixel_set = '1') then
					state := "01";
				end if;
			when "01" =>
				master_r_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(pixel_offset));
				master_r_be <= "11";
				master_rd_en <= '1';
				state := "10";
			when "10" =>
				if (master_r_wait = '0') then
					master_rd_en <= '0';
					p     := master_rd(15 downto 0);
					state := "11";
				else
					master_r_addr <= std_logic_vector(unsigned(pixel_buffer_base) + unsigned(pixel_offset));
					master_r_be <= "11";
					master_rd_en <= '1';
				end if;
			when "11" =>
				ready := '1';
				if (pixel_set = '0') then
					state := "00";
				end if;
			when others =>
				state := "11";
		end case;
		red_led <= state;
			
		pixel       <= p;
		pixel_ready <= ready;
	end if;
end process;
end behavioural;