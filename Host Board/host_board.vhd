library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity host_board is 
	port(
		SW          : in std_logic_vector(17 downto 0);
		KEY         : in std_logic_vector(3 downto 0);
		CLOCK_50    : in std_logic;
		CLOCK_27    : in std_logic;
		LEDG        : out std_logic_vector(7 downto 0);
		LEDR        : out std_logic_vector (17 downto 0);
		TD_CLK27    : in std_logic;
		TD_DATA     : in std_logic_vector(7 downto 0);
		TD_HS       : in std_logic;
		TD_VS       : in std_logic;
		TD_RESET    : out std_logic;
		SRAM_DQ     : inout std_logic_vector(15 downto 0);
		SRAM_ADDR   : out std_logic_vector(17 downto 0);
		SRAM_LB_N   : out std_logic;
		SRAM_UB_N   : out std_logic;
		SRAM_CE_N   : out std_logic;
		SRAM_OE_N   : out std_logic;
		SRAM_WE_N   : out std_logic;
		VGA_CLK     : out std_logic;
		VGA_HS      : out std_logic;
		VGA_VS      : out std_logic;
		VGA_BLANK   : out std_logic;
		VGA_SYNC    : out std_logic;
		VGA_R       : out std_logic_vector(9 downto 0);
		VGA_G       : out std_logic_vector(9 downto 0);
		VGA_B       : out std_logic_vector(9 downto 0);
		GPIO_0      : in std_logic_vector(35 downto 28);
		GPIO_1      : in std_logic_vector(25 downto 3);
		RESET_OUT	: out std_logic;
		PX_RDY_IN   : in std_logic;
		PX_DONE_OUT : out std_logic;
		COMM_ACK		: in std_logic;
		COMM_RDY		: out std_logic;
		COMM_DATA	: out std_logic_vector(17 downto 2);
		HEX0			: out std_logic_vector(6 downto 0);
		HEX1			: out std_logic_vector(6 downto 0);
		HEX2			: out std_logic_vector(6 downto 0);
		HEX3			: out std_logic_vector(6 downto 0);
		HEX4			: out std_logic_vector(6 downto 0);
		HEX5			: out std_logic_vector(6 downto 0);
		HEX6			: out std_logic_vector(6 downto 0);
		HEX7			: out std_logic_vector(6 downto 0) ;
		PWM_PAN		: out std_logic;
		PWM_TILT 	: out std_logic
	);
end host_board;

architecture structure of host_board is
	component nios_system is
		port(
			clock_50_clk 				 	 : in std_logic;
			reset_50_reset_n 			    : in std_logic;
			video_decoder_TD_CLK27      : in std_logic;
			video_decoder_TD_DATA       : in std_logic_vector(7 downto 0);
			video_decoder_TD_HS         : in std_logic;
			video_decoder_TD_VS         : in std_logic;
			video_decoder_clk27_reset   : in std_logic;
			video_decoder_TD_RESET      : out std_logic;
			video_decoder_overflow_flag : out std_logic;
			sram_DQ                     : inout std_logic_vector(15 downto 0);
			sram_ADDR                   : out std_logic_vector(17 downto 0);
			sram_LB_N                   : out std_logic;
			sram_UB_N                   : out std_logic;
			sram_CE_N                   : out std_logic;
			sram_OE_N                   : out std_logic;
			sram_WE_N                   : out std_logic;
			vga_controller_CLK          : out std_logic;
			vga_controller_HS           : out std_logic;
			vga_controller_VS           : out std_logic;
			vga_controller_BLANK        : out std_logic;
			vga_controller_SYNC         : out std_logic;
			vga_controller_R            : out std_logic_vector(9 downto 0);
			vga_controller_G            : out std_logic_vector(9 downto 0);
			vga_controller_B            : out std_logic_vector(9 downto 0);
			threedlizer_reset_out       : out std_logic;
			threedlizer_pixel_r_ready   : in std_logic;
			threedlizer_pixel_r         : in std_logic_vector(4 downto 0);
			threedlizer_pixel_offset    : in std_logic_vector(17 downto 0);
			threedlizer_pixel_r_done    : out std_logic;
			threedlizer_red_led         : out std_logic_vector(17 downto 0);
			threedlizer_clk_in          : in std_logic;
			buffer_reader_clk_in			 : in std_logic;
			buffer_reader_pixel_set	    : in std_logic;
			buffer_reader_pixel_offset	 : in std_logic_vector(17 downto 0);
			buffer_reader_pixel_ready	 : out std_logic; 
			buffer_reader_pixel			 : out std_logic_vector(15 downto 0);       
			buffer_reader_red_led 		 : out std_logic_vector(1 downto 0)  
		);
	end component;
	component servo_pwm is
		port(
			clock : in std_logic;
			reset_n : in std_logic;
			angle : in std_logic_vector(6 downto 0);
			
			pwm_out : out std_logic
		);
	end component;
	
	component pixel_sender is
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
	end component;
	
	signal PIXEL_READY	: std_logic; 
	signal PIXEL			: std_logic_vector(15 downto 0);
	signal PIXEL_SET 		: std_logic;
	signal PIXEL_OFFSET	: std_logic_vector(17 downto 0);
	
	signal PAN_ANGLE : std_logic_vector(6 downto 0);
	signal TILT_ANGLE : std_logic_vector(6 downto 0);
	
begin	
	
	HEX0 <= "1111111";
	HEX1 <= "1111111";
	HEX2 <= "1111111";
	HEX3 <= "1111111";
	HEX4 <= "1111111";
	HEX5 <= "1111111";
	HEX6 <= "1111111";
	HEX7 <= "1111111";
	threedlizer : nios_system
		port map(
			clock_50_clk                => CLOCK_50,
			reset_50_reset_n            => KEY(0),
			video_decoder_TD_CLK27      => CLOCK_27,
			video_decoder_TD_DATA       => TD_DATA,
			video_decoder_TD_HS         => TD_HS,
			video_decoder_TD_VS         => TD_VS,
			video_decoder_clk27_reset   => not KEY(1),
			video_decoder_TD_RESET      => TD_RESET,
			--video_decoder_overflow_flag => LEDR(0),
			sram_DQ                     => SRAM_DQ,
			sram_ADDR                   => SRAM_ADDR,
			sram_LB_N                   => SRAM_LB_N,
			sram_UB_N                   => SRAM_UB_N,
			sram_CE_N                   => SRAM_CE_N,
			sram_OE_N                   => SRAM_OE_N,
			sram_WE_N                   => SRAM_WE_N,
			vga_controller_CLK          => VGA_CLK,
			vga_controller_HS           => VGA_HS,
			vga_controller_VS           => VGA_VS,
			vga_controller_BLANK        => VGA_BLANK,
			vga_controller_SYNC         => VGA_SYNC,
			vga_controller_R            => VGA_R,
			vga_controller_G            => VGA_G,
			vga_controller_B            => VGA_B,
			threedlizer_reset_out       => RESET_OUT,
			threedlizer_pixel_r_ready   => PX_RDY_IN,
			threedlizer_pixel_r         => GPIO_1(7 downto 3),
			threedlizer_pixel_offset    => GPIO_1(25 downto 8),
			threedlizer_pixel_r_done    => PX_DONE_OUT,
			--threedlizer_red_led         => LEDR(17 downto 0),
			threedlizer_clk_in          => KEY(2),
			buffer_reader_clk_in 		 => KEY(3),
			buffer_reader_pixel_set		 => PIXEL_SET,
			buffer_reader_pixel_offset  => PIXEL_OFFSET,
			buffer_reader_pixel_ready   => PIXEL_READY,
			buffer_reader_pixel			 => PIXEL,
			buffer_reader_red_led       => LEDR(1 downto 0)
		);
		
	pan_servo : servo_pwm port map (CLOCK_50, KEY(0), PAN_ANGLE, PWM_PAN);
	tilt_servo : servo_pwm port map (CLOCK_50, KEY(0), TILT_ANGLE, PWM_TILT);
		
	sender : pixel_sender
		port map(
			clk 			 => CLOCK_50,
			rst 			 => KEY(0),
			
			pixel_ready	 => PIXEL_READY,
			pixel			 => PIXEL,
			pixel_set	 => PIXEL_SET,
			pixel_offset => PIXEL_OFFSET,
			
			pi_ack		 => COMM_ACK,
			pi_rdy 		 => COMM_RDY,
			pi_data 	    => COMM_DATA(17 downto 2),
			
			red_led		 => LEDG(2 downto 0)
		);
		
	process(CLOCK_50, KEY(0))
		variable tilt_angle_saved : std_logic_vector(6 downto 0) := "0000000";
		variable pan_angle_saved : std_logic_vector(6 downto 0) := "0000000";
	begin
		if(KEY(0) = '0') then
			pan_angle_saved := "0000000";
			tilt_angle_saved := "0000000";
		elsif(rising_edge(CLOCK_50)) then
			if(GPIO_0(28) = '0') then
				pan_angle_saved := GPIO_0(35 downto 29);
			else 
				tilt_angle_saved := GPIO_0(35 downto 29);
			end if;
			
			PAN_ANGLE <= pan_angle_saved;
			TILT_ANGLE <= tilt_angle_saved;
		end if;
	end process;
	
end structure;