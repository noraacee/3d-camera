library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo_pwm is
	port(
		clock : in std_logic;
		reset_n : in std_logic;
		angle : in std_logic_vector(6 downto 0);
		
		pwm_out : out std_logic
	);
end servo_pwm;
	
architecture b of servo_pwm is
	constant DEG_90_VECTOR : std_logic_vector(6 downto 0) := "1011010";
	constant DEG_90_NATURAL : natural := 100000;
	constant DEG_0_NATURAL : natural := 50000;
	constant MILLI_DEG_0_NATURAL : natural := 50;
	signal PWM : std_logic := '0';
begin
	pwm_out <= PWM;
	
	process(clock, reset_n)
		variable tickCount : natural range 0 to 1000000 := 0; -- 1000000 is 2ms, PWM range is 1 - 2ms
		variable degree : natural range 0 to 90 := 0; -- literal angle to rotate to
		variable pwmDegree : natural range 50000 to 100000 := 50000; -- # of clock cycles to spend high
	begin
		if(reset_n = '0') then
			tickCount := 0;
		elsif(rising_edge(clock)) then
			if(angle > DEG_90_VECTOR) then
				-- Can't go more than 180 degrees
				pwmDegree := DEG_90_NATURAL;
			else
				-- Converts input degrees value to pwm ticks
				degree := to_integer(unsigned(angle));
				pwmDegree := (degree * 1000 / 90) * (MILLI_DEG_0_NATURAL) + DEG_0_NATURAL;
			end if;
			
			-- Sets the PWM signal based on current tickCount and the set pwmDegree
			-- Signal must be high for a minimum of 50000 ticks (1 ms, 45 degrees)
			-- Signal cannot be high for longer than 100000 ticks (2ms, 135 degrees)
			if(tickCount <= pwmDegree) then
				PWM <= '1';
			elsif(tickCount > 100000) then
				PWM <= '0';
			else
				PWM <= '0';
			end if;
			tickCount := (tickCount + 1) mod 1000000;
		end if;
	end process;
end b;