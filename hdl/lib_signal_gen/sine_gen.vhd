library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_signal_gen;

entity sine_gen is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        MCLK     : in  std_logic;
        f_out    : in  integer range 0 to 24e3;
        data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity sine_gen;

architecture RTL of sine_gen is
    constant MCLK_f : integer := integer(24.576e6);

    constant Lseq        : integer                     := 32;
    signal DCLK          : std_logic                   := '0';
    signal address_count : integer range 0 to Lseq - 1 := 0;
    signal count_max     : integer range 0 to MCLK_f   := 0;
    signal DCLK_count    : integer range 0 to MCLK_f   := 0;
    signal data_out_buf  : std_logic_vector(DATA_WIDTH - 1 downto 0);

    signal DCLK_curr : std_logic;
    signal DCLK_prev : std_logic;

begin

    data_out <= data_out_buf;

    i_sine_ROM : entity lib_signal_gen.sine_ROM
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            address_index => address_count,
            data_out      => data_out_buf
        );

    -- DCLK is a variable frequency 'clock' (data line) to output the Lseq values of 1 period of 
    -- the sine ROM at a rate of f_out * Lseq. count_max = # MCLK periods per change in DCLK
    -- E.G a 10kHz sine with Lseq = 32 needs 3.2MHz DCLK to replicate sine period in a 10kHz period
    -- the DAC will take care of buffering and sampling this internal sine and outputting it at 48kHz.
    p_DCLK_gen : process(f_out, MCLK)
    begin
        
        -- count_max = MCLK_f/(2 * Lseq * f_out)
        if 2 * Lseq * f_out /= 0 then
            count_max <= MCLK_f / (2 * Lseq * f_out);
        else
            count_max <= 1;
        end if;
        
        
        if rising_edge(MCLK) then
            if DCLK_count > count_max then
                DCLK_count <= 0;
                DCLK       <= not DCLK;
            else
                DCLK_count <= DCLK_count + 1;
            end if;
        end if;

    end process;

    -- changes non clock values for 'edge detection'
    p_dclk_monitor : process(MCLK, DCLK)
    begin
        DCLK_curr <= DCLK;
        if rising_edge(MCLK) then
            DCLK_prev <= DCLK_curr;
        end if;
    end process;

    -- increments address_count on DCLK 'rising edge'
    p_counter : process(MCLK)
    begin
        -- increment address count by 1 from 0 to 31 and repeat
        if rising_edge(MCLK) then
            if (DCLK_prev = '0' and DCLK_curr = '1') then
                if address_count < Lseq - 1 then
                    address_count <= address_count + 1;
                else
                    address_count <= 0;
                end if;
            end if;
        end if;
    end process;

end architecture RTL;
