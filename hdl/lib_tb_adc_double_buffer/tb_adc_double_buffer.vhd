library ieee;
use ieee.std_logic_1164.all;
library lib_adc_receiver;
library lib_clock_controller_pll;
library lib_double_buffer;
library lib_testbench_stimulus;

entity tb_adc_double_buffer is
end entity tb_adc_double_buffer;

architecture sim of tb_adc_double_buffer is
    constant DATA_WIDTH : integer   := 24;
    signal ADC_OUT      : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal DB_OUT       : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal SDIN         : std_logic := '0';
    signal nRst         : std_logic := '0';
    signal MCLK         : std_logic := '0';
    signal SCLK         : std_logic;
    signal LRCK         : std_logic;
begin

    -- Instantiate ADC Receiver
    i_adc_receiver : entity lib_adc_receiver.adc_receiver
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst    => nRst,
            MCLK    => MCLK,
            LRCK    => LRCK,
            SCLK    => SCLK,
            SDIN    => SDIN,
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
            SCLK     => SCLK,
            LRCK     => LRCK
        );

    i_double_buffer : entity lib_double_buffer.double_buffer
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst     => nRst,
            LRCK     => LRCK,
            data_in  => ADC_OUT,
            data_out => DB_OUT
        );

    TB_STIM : entity lib_testbench_stimulus.testbench_stimulus
        port map(
            SCLK       => SCLK,
            LRCK       => LRCK,
            nRst       => nRst,
            ADIN_SDOUT => SDIN
        );

end architecture;
