library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_sender is
	port(
		clk 			 : in std_logic;
		rst 			 : in std_logic;
		
		pixel_ready	 : in std_logic; 
		pixel			 : in std_logic_vector(15 downto 0);
		pixel_set	 : out std_logic;
		pixel_offset : out std_logic_vector(17 downto 0);
		
		pi_ack		 : in std_logic;
		pi_rdy 		 : out std_logic;
		pi_data 	    : out std_logic_vector(15 downto 0);
		
		red_led		 : out std_logic_vector(2 downto 0)
	);
end pixel_sender;
	
architecture behavourial of pixel_sender is
begin
	process(clk, rst)
	
		variable state 	 : std_logic_vector(2 downto 0);
		
		variable ready 	 : std_logic := '0';
		variable set 		 : std_logic := '0';
		variable offset 	 : unsigned(17 downto 0);
		variable comm_data : std_logic_vector(15 downto 0);
	begin
		if(rst = '0') then
			pi_rdy     <= '0';
			pixel_set  <= '0';
			red_led    <= "111";
			ready      := '0';
			set 		  := '0';
			state  	  := "101";
			offset 	  := "000000000000000000";
		elsif(rising_edge(clk)) then
			case state is
				when "000" =>
					set := '0';
					if (pixel_ready = '0') then
						state := "001";
					end if;
				when "001" =>
					set   := '1';
					if (pixel_ready = '1') then
						state := "010";
					end if;
				when "010" =>					
					if (offset = "100101100000000000") then
						offset := "000000000000000000";
					else 
						offset := offset + 2;
					end if;
					
					state := "011";
				when "011" =>
					comm_data  := pixel;
					state      := "100";
				when "100" =>
					ready := '1';
					if(pi_ack = '1') then
						state := "101";
					end if;
				when "101" =>
					ready := '0';
					if(pi_ack = '0') then
						state := "000";
					end if;
				when others =>
					state 	  := "101";
			end case;
			red_led <= state;
			
			pixel_offset <= std_logic_vector(offset);
			pixel_set 	 <= set;
			
			pi_data 		 <= comm_data;
			pi_rdy 		 <= ready;
		end if;
	end process;
end behavourial;