library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity channel_recombiner is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        LRCK     : in  std_logic;
        nRst     : in  std_logic;
        LDATA_IN : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        RDATA_IN : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity channel_recombiner;

architecture RTL of channel_recombiner is
    signal left_buffer  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal right_buffer : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
begin

    INPUT_READ : process(LDATA_IN, RDATA_IN, nRst)
    begin
        if nRst <= '0' then
            left_buffer  <= (others => '0');
            right_buffer <= (others => '0');
        else
            left_buffer  <= LDATA_IN;
            right_buffer <= RDATA_IN;
        end if;
    end process;

    COMBINER : process(LRCK, left_buffer, right_buffer, nRst)
    begin
        if nRst = '0' then
            data_out <= (others => '0');
        else
            if LRCK = '0' then
                data_out <= right_buffer;
            elsif LRCK = '1' then
                data_out <= left_buffer;
            end if;
        end if;
    end process;

end architecture RTL;
