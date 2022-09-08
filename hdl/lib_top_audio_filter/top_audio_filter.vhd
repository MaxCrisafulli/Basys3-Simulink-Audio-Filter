library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_adc_receiver;
library lib_dac_control;
library lib_double_buffer;
library lib_clock_controller_pll;
library lib_channel_splitter;
library lib_channel_recombiner;
--library lib_FIR_filter;
library lib_IIR_filter;
library lib_clock_divider;

entity top_audio_filter is
    generic(
        DATA_WIDTH : integer := 24;
        M_S_RATIO  : integer := 8;      -- M_S = 8 & M_L = 512 for 48kHz FS SSM
        M_L_RATIO  : integer := 512     -- M_S = 4 & M_L = 256 for 96khz FS DSM
    );
    port(
        CLK_100M   : in  std_logic;     -- Input 100MHz Clock (Oscillator Crystal)
        nRst       : in  std_logic;     -- Top Level Active Low Reset
        ADIN_SDOUT : in  std_logic;     -- Input from PMOD ADC, SDOUT from board
        PF_SELECT  : in  std_logic;     -- switch to change between filter/passthrough
        ADOUT_SDIN : out std_logic;     -- Output to PMOD DAC, SDIN to board
        DAC_MCLK   : out std_logic;     -- Master Clock (from PLL) 
        DAC_LRCK   : out std_logic;     -- Word Clock (Left/Right) (from clock_controller)
        DAC_SCLK   : out std_logic;     -- Serial Data Clock (from clock_controller)
        ADC_MCLK   : out std_logic;     -- Master Clock (from PLL) 
        ADC_LRCK   : out std_logic;     -- Word Clock (Left/Right) (from clock_controller)
        ADC_SCLK   : out std_logic      -- Serial Data Clock (from clock_controller)
    );
end entity top_audio_filter;

architecture RTL of top_audio_filter is

    signal ADC_OUT : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal DAC_IN  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal MCLK    : std_logic                                 := '0';
    signal LRCK    : std_logic                                 := '0';
    signal SCLK    : std_logic                                 := '0';

    signal nRst_int : std_logic := '1';

    signal INDB_OUT    : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal LDATA       : std_logic_vector(23 downto 0)             := (others => '0');
    signal RDATA       : std_logic_vector(23 downto 0)             := (others => '0');
    signal LFILTER_OUT : std_logic_vector(23 downto 0)             := (others => '0');
    signal RFILTER_OUT : std_logic_vector(23 downto 0)             := (others => '0');
    signal LMUX_OUT    : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal RMUX_OUT    : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal RECOM_OUT   : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    constant clk_enable : std_logic := '1';

begin

    p_nRSt_int_assign : nRst_int <= nRst;

    i_adc_receiver : entity lib_adc_receiver.adc_receiver
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst    => nRst_int,
            MCLK    => MCLK,
            LRCK    => LRCK,
            SCLK    => SCLK,
            SDIN    => ADIN_SDOUT,
            ADC_OUT => ADC_OUT
        );

    i_DB_IN : entity lib_double_buffer.double_buffer
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst     => nRst_int,
            LRCK     => LRCK,
            data_in  => ADC_OUT,
            data_out => INDB_OUT
        );

    i_channel_splitter : entity lib_channel_splitter.channel_splitter
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            LRCK      => LRCK,
            data_in   => INDB_OUT,
            nRst      => nRst_int,
            left_out  => LDATA,
            right_out => RDATA
        );

    --    i_FIR_filter_L : entity lib_FIR_filter.FIR_filter
    --        port map(
    --            MCLK       => MCLK,
    --            nRst       => nRst,
    --            clk_enable => clk_enable,
    --            filter_in  => LDATA,
    --            ce_out     => open,
    --            filter_out => LFILTER_OUT
    --        );
    --
    --    i_FIR_filter_R : entity lib_FIR_filter.FIR_filter
    --        port map(
    --            MCLK       => MCLK,
    --            nRst       => nRst,
    --            clk_enable => clk_enable,
    --            filter_in  => RDATA,
    --            ce_out     => open,
    --            filter_out => RFILTER_OUT
    --        );

    i_IIR_filter_L : entity lib_IIR_filter.IIR_filter
        port map(
            MCLK       => MCLK,
            nRst       => nRst_int,
            clk_enable => clk_enable,
            filter_in  => LDATA,
            ce_out     => open,
            filter_out => LFILTER_OUT
        );

    i_IIR_filter_R : entity lib_IIR_filter.IIR_filter
        port map(
            MCLK       => MCLK,
            nRst       => nRst_int,
            clk_enable => clk_enable,
            filter_in  => RDATA,
            ce_out     => open,
            filter_out => RFILTER_OUT
        );

    p_PASS_MUX : process(PF_SELECT, LDATA, RDATA, LFILTER_OUT, RFILTER_OUT)
    begin
        if (PF_SELECT = '1') then
            LMUX_OUT <= LFILTER_OUT;
            RMUX_OUT <= RFILTER_OUT;
        else
            LMUX_OUT <= LDATA;
            RMUX_OUT <= RDATA;
        end if;

    end process;

    i_channel_recombiner : entity lib_channel_recombiner.channel_recombiner
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            LRCK     => LRCK,
            nRst     => nRst_int,
            LDATA_IN => LMUX_OUT,
            RDATA_IN => RMUX_OUT,
            data_out => RECOM_OUT
        );

    i_DB_OUT : entity lib_double_buffer.double_buffer
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst     => nRst_int,
            LRCK     => LRCK,
            data_in  => RECOM_OUT,
            data_out => DAC_IN
        );

    i_dac_control : entity lib_dac_control.dac_control
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            nRst   => nRst_int,
            MCLK   => MCLK,
            LRCK   => LRCK,
            SCLK   => SCLK,
            DAC_IN => DAC_IN,
            SDOUT  => ADOUT_SDIN
        );

    i_clock_controller : entity lib_clock_controller_pll.clock_controller_pll
        generic map(
            M_S_RATIO => M_S_RATIO,
            M_L_RATIO => M_L_RATIO
        )
        port map(
            CLK_100M => CLK_100M,
            nRst     => '1',
            MCLK     => MCLK,
            SCLK     => SCLK,
            LRCK     => LRCK
        );

    -- Assign internal clocks to their output ports
    p_CLK_OUT_DRIVER : process(MCLK, LRCK, SCLK)
    begin
        DAC_MCLK <= MCLK;
        ADC_MCLK <= MCLK;
        DAC_LRCK <= LRCK;
        ADC_LRCK <= LRCK;
        DAC_SCLK <= SCLK;
        ADC_SCLK <= SCLK;
    end process;

end architecture RTL;
