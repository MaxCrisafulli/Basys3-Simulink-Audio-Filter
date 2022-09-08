library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_control is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        nRst   : in  std_logic;
        MCLK   : in  std_logic;
        LRCK   : in  std_logic;
        SCLK   : in  std_logic;
        DAC_IN : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        SDOUT  : out std_logic
    );
end entity dac_control;

architecture RTL of dac_control is
    signal out_idx   : integer range -1 to DATA_WIDTH + 1:= 0;
    signal LRCK_curr : std_logic;
    signal LRCK_prev : std_logic;
    signal SCLK_curr : std_logic;
    signal SCLK_prev : std_logic;
begin

    LRCK_curr <= LRCK;
    SCLK_curr <= SCLK;
    CLK_ASSIGN : process(MCLK)
    begin
        if rising_edge(MCLK) then
            LRCK_prev <= LRCK_curr;
            SCLK_prev <= SCLK_curr;
        end if;
    end process;

    IDX_COUNTER : process(MCLK, nRst)
    begin
        if nRst = '0' then
            out_idx <= 0;
        else
            -- rising OR falling edge of LRCK
            if falling_edge(MCLK) then
                if (LRCK_prev = not LRCK_curr) then --if (LRCK_prev = not LRCK_curr) then -- if different
                    out_idx <= DATA_WIDTH;
                end if;
            end if;

            -- rising edge of SCLK 
            if falling_edge(MCLK) then
                --rising edge AND OTHER check
                if (SCLK_prev = '0' and SCLK_curr = '1') and (out_idx = DATA_WIDTH) and (out_idx >= 0) then -- rising edge of sclk
                    out_idx <= out_idx - 1;
                end if;

                -- falling edge AND OTHER check
                if (SCLK_prev = '1' and SCLK_curr = '0') and (out_idx < DATA_WIDTH) and (out_idx >= 0) then -- falling edge of sclk
                    out_idx <= out_idx - 1;
                end if;
            end if;
        end if;
    end process;

    PAR2SER : process(MCLK, nRst)
    begin
        if nRst = '0' then
            SDOUT <= '0';
        else
            if falling_edge(MCLK) then
                -- on falling edge of SCLK
                if (SCLK_prev = '1' and SCLK_curr = '0') then
                    if out_idx <= DATA_WIDTH - 1 and out_idx >= 0 then
                        SDOUT <= DAC_IN(out_idx);
                    else
                        SDOUT <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture RTL;
