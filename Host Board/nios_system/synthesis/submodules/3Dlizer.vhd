library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity threeDlizer is
generic(
	--variables that can be changed in Qsys component configurations
   pixel_buffer_2D      : std_logic_vector := x"00000000"; --this is where video source writes to
	pixel_buffer_3D      : std_logic_vector := x"00025800"  --this is what will be sent to display
);
port (

	clk 		  	     : in std_logic;
	reset_in 	     : in std_logic;
	reset_out 	     : out std_logic; --send the reset to red board to synchronize resets
	clk_in           : in std_logic; -- only for debugging purposes, can be set to a key and process sensitivity list will be changed
	
	--incoming and outgoing signals to the GPIO pins
	pixel_r_ready    : in std_logic;
	pixel_r 		     : in std_logic_vector(4 downto 0);
	pixel_offset     : in std_logic_vector(17 downto 0);
	pixel_r_done     : out std_logic;
	
	--Avalon MM master to write to pixel buffer
	master_w_wait    : in std_logic;
	master_wr_en     : out std_logic;
	master_wd        : out std_logic_vector(15 downto 0);
	master_w_addr    : out std_logic_vector(31 downto 0);
	master_w_be      : out std_logic_vector(1 downto 0);
	
	--Avalon MM master to read from pixel buffer
	master_r_wait    : in std_logic;
	master_rd        : in std_logic_vector(15 downto 0);
	master_rd_en     : out std_logic;
	master_r_addr    : out std_logic_vector(31 downto 0);
	master_r_be      : out std_logic_vector(1 downto 0);
	
	--for debugging purposes only
	red_led          : out std_logic_vector(17 downto 0)
);
end  threeDlizer;

architecture behavioural of threeDlizer is

--incoming data after reading from the pixel buffer
--red from red board already concatenated with blue and green
--used in second process to check for problem bits
signal write_data : std_logic_vector(15 downto 0);

--final pixel to be written to pixel buffer
--problem bits are alreay checked and will not cause flickering
signal pixel      : std_logic_vector(15 downto 0);

begin

reset_out <= reset_in;


--this is the main process that runs on the clock and asynchronous reset
--contains the state machine that the whole sytsem runs on
process(clk, reset_in)

--state of state machine
variable state 		 : std_logic_vector(2 downto 0);

--flag for if pixel processing is done or not, set only after pixel is written into pixel buffer
variable done         : std_logic := '0';

--incoming red color from red board
variable red_data     : std_logic_vector(4 downto 0);

--offset of address to write to from red board
variable offset_data  : std_logic_vector(17 downto 0);

begin
	if (reset_in = '0') then
		master_wr_en <= '0';
		master_rd_en <= '0';
		red_led <= "111111111111111111";
		done         := '0';
		state        := "110";
	elsif (rising_edge(clk)) then
		red_led <= "000000000000000000";
		
		case state is
		
			--waits for pixel ready to be 1 before doing anything else
			when "000" =>
				done := '0';
				if (pixel_r_ready = '1') then
					state := "001";
				end if;
				
				
			--sets the data from pins to variables (in case pins are changed later)
			--checks if buffer address needs to be changed
			when "001" =>
				red_data := pixel_r;
				offset_data := pixel_offset;
				
				state := "010";
				
			--read pixel from host board camera
			when "010" =>
				master_r_addr <= std_logic_vector(unsigned(pixel_buffer_2D) + unsigned(offset_data));
				master_r_be <= "11";
				master_rd_en <= '1';
				state := "011";
				
				
			--set the write_data signal to blue and green from host board and red from red board
			when "011" =>
				if (master_r_wait = '0') then
					master_rd_en <= '0';
					write_data <= red_data & master_rd(10 downto 0);
					state := "100";
				else
					master_r_addr <= std_logic_vector(unsigned(pixel_buffer_2D) + unsigned(offset_data));
					master_r_be <= "11";
					master_rd_en <= '1';
				end if;
				
			
			--writes pixel to pixel buffer
			when "100" =>
				master_wd <= pixel;
				master_w_addr <= std_logic_vector(unsigned(pixel_buffer_3D) + unsigned(offset_data));
				master_w_be <= "11";
				master_wr_en <= '1';
				state := "101";
				
			
			--checks if write is successful, and if so, assert done signal
			when "101" =>
				if(master_w_wait = '0') then
					master_wr_en <= '0';
					state := "110";
				else
					master_wd <= pixel;
					master_w_addr <= std_logic_vector(unsigned(pixel_buffer_3D) + unsigned(offset_data));
					master_w_be <= "11";
					master_wr_en <= '1';
				end if;
				
				
			--waits for pixel ready to be deasserted before deasserting done
			--this is also the state the system will default to on reset
			when "110" =>
				done := '1';
				if (pixel_r_ready = '0') then
					state := "000";
				end if;
			
				
			--in case there is a problem with states, go to default state
			when others =>
				state := "110";
		end case;
		
		pixel_r_done <= done;
	end if;
end process;

--this process checks for any problem bits in the pixel
--and changes it to the closest pixel that will not cause fickering
process(write_data)
begin
	--ignore first bit of blue at all times
	pixel <= write_data and "1111111111111110";
	
	--checks for bit 1 and 2 of red
	if (write_data(13) = '1') then
		if (write_data(12) = '1') then
			if (write_data(4 downto 1) = "1111") then
				pixel(12) <= '0';
			elsif (write_data(4 downto 2) = "111") then
				pixel(12) <= '0';
			elsif (write_data(4 downto 1) = "1101") then
				pixel(12) <= '0';
			end if;
		end if;
		
		if (write_data(4 downto 1) = "1111") then
			pixel(2 downto 1) <= "00";
			pixel(7) <= '0';
		elsif (write_data(4 downto 2) = "111") then
			pixel(2) <= '0';
			pixel(7) <= '0';
		elsif (write_data(4 downto 1) = "1101") then
			pixel(7) <= '0';
			pixel(1) <= '0';
		end if;
	end if;
end process;
end behavioural;