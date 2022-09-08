library ieee;
use ieee.std_logic_1164.all;
library lib_adc_receiver;
library lib_clock_controller_pll;
library lib_testbench_stimulus;

entity tb_adc_receiver is
end entity tb_adc_receiver;

architecture sim of tb_adc_receiver is
    constant DATA_WIDTH : integer   := 24;
    signal ADC_OUT      : std_logic_vector(23 downto 0);
    signal ADIN_SDOUT   : std_logic := '0';
    signal nRst         : std_logic := '0';
    signal MCLK         : std_logic := '0';
    signal SCLK         : std_logic;
    signal LRCK         : std_logic;

    constant MCLK_T : time := (1e6 us) / (11.29e6); -- 22.5792 MHz for 44.1kHz Fs (LRCK)
begin

    -- Generate Master clock
    TB_CLK : MCLK <= not MCLK after MCLK_T / 2;

    TB_STIM : entity lib_testbench_stimulus.testbench_stimulus
        port map(
            SCLK       => SCLK,
            LRCK       => LRCK,
            nRst       => nRst,
            ADIN_SDOUT => ADIN_SDOUT
        );

    -- Instantiate ADC Receiver
    i_adc_receiver : entity lib_adc_receiver.adc_receiver
        generic map(
            DATA_WIDTH => 24
        )
        port map(
            nRst    => nRst,
            MCLK    => MCLK,
            LRCK    => LRCK,
            SCLK    => SCLK,
            SDIN    => ADIN_SDOUT,
            ADC_OUT => ADC_OUT
        );

    -- Instantiate Clock Controller
    i_clock_controller : entity lib_clock_controller_pll.clock_controller_pll
        generic map(
            M_S_RATIO => 4,
            M_L_RATIO => 256
        )
        port map(
            CLK_100M => '1',
            nRst     => nRst,
            MCLK     => MCLK,
            SCLK     => open,
            LRCK     => LRCK
        );

end architecture;
