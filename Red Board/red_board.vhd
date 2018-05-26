library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity red_board is 
	port(
		SW          : in std_logic_vector(7 downto 0);
		KEY         : in std_logic_vector(2 downto 0);
		CLOCK_50    : in std_logic;
		LEDG        : out std_logic_vector(7 downto 0);
		LEDR        : out std_logic_vector (17 downto 0);
		CLOCK_27    : in std_logic;
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
		GPIO_1      : inout std_logic_vector(25 downto 0)
	);
end red_board;

architecture structure of red_board is
	component nios_system
		port(
			clock_50_clk                : in std_logic;
			reset_50_reset_n            : in std_logic;
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
			red_extractor_pixel_r_done  : in std_logic;
			red_extractor_pixel_r_ready : out std_logic;
			red_extractor_pixel_r		 : out std_logic_vector(4 downto 0);
			red_extractor_pixel_offset  : out std_logic_vector(17 downto 0);
			red_extractor_reset_in      : in std_logic;
			red_extractor_red_led       : out std_logic_vector(17 downto 0);
			red_extractor_clk_in        : in std_logic
		);
	end component;
	
begin	
	nios_II : nios_system
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
			red_extractor_pixel_r_done  => GPIO_1(2),
			red_extractor_pixel_r_ready => GPIO_1(1),
			red_extractor_pixel_r       => GPIO_1(7 downto 3),
			red_extractor_pixel_offset  => GPIO_1(25 downto 8),
			red_extractor_reset_in      => GPIO_1(0),
			--red_extractor_red_led       => LEDR(17 downto 0),
			red_extractor_clk_in        => KEY(2)
		);
end structure;