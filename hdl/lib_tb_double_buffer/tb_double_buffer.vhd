library ieee;
use ieee.std_logic_1164.all;
library lib_double_buffer;
library lib_clock_controller_pll;

entity tb_double_buffer is
end entity tb_double_buffer;

architecture sim of tb_double_buffer is
    signal ADC_OUT : std_logic_vector(23 downto 0) := x"000000";
    signal DB_OUT  : std_logic_vector(23 downto 0);
    signal nRst    : std_logic                     := '1';
    signal MCLK    : std_logic                     := '0';
    signal LRCK    : std_logic;

    constant MCLK_T : time := (1e6 us) / (22.5792e6); -- 22.5792 MHz for 44.1kHz Fs (LRCK)
begin

    -- Generate TB clock
    TB_CLK : MCLK <= not MCLK after MCLK_T / 2;

    -- Instantiate the Double Buffer
    i_double_buffer : entity lib_double_buffer.double_buffer
        generic map(
            DATA_WIDTH => 24
        )
        port map(
            nRst     => nRst,
            LRCK     => LRCK,
            data_in  => ADC_OUT,
            data_out => DB_OUT
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
        nRst    <= '1';
        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"c21882";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"02cda8";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"ffbe40";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"5fe068";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"344a3f";

        wait until falling_edge(LRCK) or rising_edge(LRCK);
        ADC_OUT <= x"35673d";
    end process;

end architecture;
