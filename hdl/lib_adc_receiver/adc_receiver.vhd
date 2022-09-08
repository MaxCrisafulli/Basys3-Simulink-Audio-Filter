library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_receiver is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        nRst    : in  std_logic;        --active low reset
        MCLK    : in  std_logic;
        LRCK    : in  std_logic;        -- 0 = L, 1 = R
        SCLK    : in  std_logic;        -- serial data clock
        SDIN    : in  std_logic;        -- data from PMOD ADC
        ADC_OUT : out std_logic_vector(DATA_WIDTH - 1 downto 0) -- parallel output to double buffer
    );
end entity adc_receiver;

architecture RTL of adc_receiver is
    signal ADC_OUT_BUFFER : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal buf_idx        : integer range -1 to 25                    := 0;
    signal LRCK_curr      : std_logic;
    signal LRCK_prev      : std_logic;
    signal SCLK_curr      : std_logic;
    signal SCLK_prev      : std_logic;
begin

    LRCK_curr <= LRCK;
    SCLK_curr <= SCLK;
    p_CLK_ASSIGN : process(MCLK)
    begin
        if rising_edge(MCLK) then
            LRCK_prev <= LRCK_curr;
            SCLK_prev <= SCLK_curr;
        end if;
    end process;

    p_IDX_COUNTER : process(MCLK)
    begin
        -- rising OR falling edge of LRCK
        if falling_edge(MCLK) then
            if (LRCK_prev = not LRCK_curr) then
                buf_idx <= DATA_WIDTH + 1;
            end if;
        end if;

        -- rising edge of SCLK 
        if falling_edge(MCLK) then
            --rising edge AND OTHER check
            if (SCLK_prev = '0' and SCLK_curr = '1') and (buf_idx = DATA_WIDTH + 1) and (buf_idx >= 0) then -- rising edge of sclk
                buf_idx <= buf_idx - 1;
            end if;

            -- falling edge AND OTHER check
            if (SCLK_prev = '1' and SCLK_curr = '0') and (buf_idx < DATA_WIDTH + 1) and (buf_idx >= 0) then -- falling edge of sclk
                buf_idx <= buf_idx - 1;
            end if;
        end if;
    end process;

    p_SER2PAR : process(MCLK)
    begin
        -- falling edge of SCLK and buf_idx < DATA_WIDTH + 1
        if falling_edge(MCLK) then
            if (SCLK_prev = '0' and SCLK_curr = '1') and (buf_idx <= DATA_WIDTH - 1 and buf_idx >= 0) then -- falling edge of sclk
                ADC_OUT_BUFFER(buf_idx) <= SDIN;
            end if;
        end if;
    end process;

    -- continually drive output signals from their internal buffers
    p_OUTPUT_DRIVER : process(ADC_OUT_BUFFER, nRst)
    begin
        -- reset output on active low
        if nRst = '0' then
            ADC_OUT <= (others => '0');
        else
            ADC_OUT <= ADC_OUT_BUFFER;
        end if;
    end process;

end architecture RTL;
