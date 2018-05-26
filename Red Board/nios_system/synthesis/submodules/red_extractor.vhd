library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity red_extractor is
generic(
	--variables that can be changed in Qsys component configurations
	pixel_buffer_base : std_logic_vector      := x"00000000" --address to read pixels from
);
port (
	clk 		  	  : in std_logic;
	reset_n_in    : in std_logic;
	reset_in 	  : in std_logic; --incoming reset from host board to synchronize resets
	clk_in        : in std_logic; --used only for debugging purposes, can connect to key and change process sensitivity list
	
	--incoming and outgoing signals to the GPIO pins
	pixel_r_done  : in std_logic; 
	pixel_r_ready : out std_logic;
	pixel_r 		  : out std_logic_vector(4 downto 0);
	pixel_offset  : out std_logic_vector(17 downto 0);
	
	--Avalon MM master to read from the pixel buffer
	master_r_wait : in std_logic;
	master_rd     : in std_logic_vector(15 downto 0);
	master_rd_en  : out std_logic;
	master_r_addr : out std_logic_vector(31 downto 0);
	master_r_be   : out std_logic_vector(1 downto 0);
	
	--for debugging purposes only
	red_led       : out std_logic_vector(17 downto 0)
);
end  red_extractor;

architecture behavioural of red_extractor is

begin

--this is the main process that runs on the clock and asynchronous reset
--contains the state machine for reading and sending red colors
process(clk, reset_n_in, reset_in)

--state of the state machine
variable state        : std_logic_vector(1 downto 0);

--outgoing red data from the video stream
variable red_data     : std_logic_vector(4 downto 0);

--current offset from the base address of pixel being read
variable offset       : unsigned(17 downto 0);

--if the pixel is read and ready to be sent
variable ready        : std_logic := '0';

begin
	if (reset_in = '0' or reset_n_in = '0') then
		master_rd_en <= '0';
		pixel_r_ready <= '0';
		red_led <= "111111111111111111";
		state        := "11";
		offset       := "000000000000000000";
		ready        := '0';
	elsif (rising_edge(clk)) then
		red_led <= "000000000000000000";
		
		case state is
		
			--read pixel from pixel buffer
			when "00" =>
				master_r_addr <= std_logic_vector(unsigned(pixel_buffer_base) + offset);
				master_r_be <= "11";
				master_rd_en <= '1';
				state := "01";
				
				
			--set red_data and checks if offset has reached the end of the frame
			--if offset is at the end, set it to 0, otherwise plus 2
			when "01" =>
				--waits for read transfer to complete
				if (master_r_wait = '0') then
					master_rd_en <= '0';
					red_data := master_rd(15 downto 11);
					
					--if offset is at the end, we switch the buffers and address
					if (offset = "100101100000000000") then
						offset := "000000000000000000";
					else 
						offset := offset + 2;
					end if;
					
					state := "10";
				else
					--keeps the value of the master constant
					master_r_addr <= std_logic_vector(unsigned(pixel_buffer_base) + offset);
					master_r_be <= "11";
					master_rd_en <= '1';
				end if;
			
			
			--wait for pixel to finish being processed in hostboard
			when "10" =>
				ready := '1';
				if (pixel_r_done = '1') then
					state := "11";
				end if;
				
				
			--wait for host board to deassert done sigal before reading the next pixel
			when "11" =>
				ready := '0';
				if (pixel_r_done = '0') then
					state := "00";
				end if;
				
			
			--in case there is a problem with states, go to default state
			when others =>
				state := "11";
		end case;
		
		pixel_offset <= std_logic_vector(offset);
		pixel_r <= red_data;
		pixel_r_ready <= ready;
	end if;
end process;
end behavioural;