library ieee;
use ieee.std_logic_1164.all;
library lib_dac_control;
library lib_clock_controller_pll;

entity tb_dac_control is
end entity tb_dac_control;

architecture sim of tb_dac_control is
    constant DATA_WIDTH : integer                       := 24;
    signal DB_OUT       : std_logic_vector(23 downto 0) := x"000000";
    signal nRst         : std_logic                     := '1';
    signal MCLK         : std_logic                     := '0';
    signal LRCK         : std_logic;
    signal SDOUT        : std_logic;
    signal SCLK         : std_logic;

    constant MCLK_T : time := (1e6 us) / (22.5792e6); -- 22.5792 MHz for 44.1kHz Fs (LRCK)
begin

    -- Generate TB MCLK clock
    TB_CLK : MCLK <= not MCLK after MCLK_T / 2;

    -- Instantiate Dac Controller
    i_dac_control : entity lib_dac_control.dac_control
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst   => nRst,
            MCLK   => MCLK,
            LRCK   => LRCK,
            SCLK   => SCLK,
            DAC_IN => DB_OUT,
            SDOUT  => SDOUT
        );

    -- Instantiate Clock Controller
    i_clock_controller : entity lib_clock_controller_pll.clock_controller_pll
        generic map(
            M_S_RATIO => 4,
            M_L_RATIO => 256
        )
        port map(
            MCLK     => MCLK,
            nRst     => nRst,
            SCLK     => open,
            LRCK     => LRCK,
            CLK_100M => '1'
        );

    -- Stimulus Process
    TB_STIM : process is
    begin
        nRst   <= '1';
        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"c21882";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"02cda8";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"ffbe40";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"5fe068";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"344a3f";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        DB_OUT <= x"35673d";
    end process;

end architecture;
