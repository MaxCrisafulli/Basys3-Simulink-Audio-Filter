library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_top_audio_filter;
library lib_testbench_stimulus;
library lib_signal_gen;
library lib_dac_control;

entity tb_top_audio_filter is
end entity tb_top_audio_filter;

architecture sim of tb_top_audio_filter is
    --signal CLK_100MHZ : std_logic := '0';
    signal nRst       : std_logic                     := '0';
    signal ADIN_SDOUT : std_logic                     := '0';
    signal TEST_WORD  : std_logic_vector(23 downto 0) := (others => '0');
    signal PF_SELECT  : std_logic                     := '1';
    signal ADOUT_SDIN : std_logic;
    signal MCLK       : std_logic                     := '0';
    signal LRCK       : std_logic;
    signal SCLK       : std_logic;

    signal signal_DAC_in : std_logic_vector(23 downto 0);
    signal f_out         : integer := 1;

    -- full system data_width (TB works for 24 max, theoretically 32 max)
    constant DATA_WIDTH : integer := 24;

begin
    -- 
    i_top_audio_filter : entity lib_top_audio_filter.top_audio_filter
        generic map(
            DATA_WIDTH => DATA_WIDTH,
            M_S_RATIO  => 8,
            M_L_RATIO  => 512
        )
        port map(
            CLK_100M   => '1',
            nRst       => nRst,
            ADIN_SDOUT => ADIN_SDOUT,
            PF_SELECT  => PF_SELECT,
            ADOUT_SDIN => ADOUT_SDIN,
            DAC_MCLK   => MCLK,
            DAC_LRCK   => LRCK,
            DAC_SCLK   => SCLK,
            ADC_MCLK   => open,
            ADC_LRCK   => open,
            ADC_SCLK   => open
        );

    -- Stimulus Process
    --    i_testbench_stimulus : entity lib_testbench_stimulus.testbench_stimulus
    --        port map(
    --            SCLK       => SCLK,
    --            LRCK       => LRCK,
    --            nRst       => nRst,
    --            ADIN_SDOUT => ADIN_SDOUT
    --        );

    i_sine_gen : entity lib_signal_gen.sine_gen
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            MCLK     => MCLK,
            f_out    => f_out,
            data_out => signal_DAC_in
        );

    i_signal_DAC : entity lib_dac_control.dac_control
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst   => nRst,
            MCLK   => MCLK,
            LRCK   => LRCK,
            SCLK   => SCLK,
            DAC_IN => signal_DAC_in,
            SDOUT  => ADIN_SDOUT
        );

    TB_STIM : process
    begin
        f_out <= 1;
        nRst  <= '1';
        wait for 1 us;
        nRst  <= '0';
        wait for 1 us;
        nRst  <= '1';
        for i in 1 to 20 loop
            f_out <= i * 25;            -- 250
            wait for 7500 us;           --4e3
        end loop;

        nRst <= '0';
        wait for 10 us;
        nRst <= '1';

        for i in 11 to 80 * 5 loop
            f_out <= i * 50;            -- 250
            wait for 2e3 us;            --4e3
        end loop;
        wait;
    end process;

    TB_STIM_2 : process
    begin
        PF_SELECT <= '1';
        wait for 15e3 us;
        PF_SELECT <= '1';
        wait;
    end process;

end architecture sim;
