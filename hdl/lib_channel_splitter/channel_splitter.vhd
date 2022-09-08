library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity channel_splitter is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        LRCK      : in  std_logic;
        data_in   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        nRst      : in  std_logic;
        left_out  : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        right_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity channel_splitter;

architecture RTL of channel_splitter is
    signal left_buffer  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal right_buffer : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
begin

    SPLITTER : process(LRCK, data_in, nRst)
    begin
        if nRst = '0' then
            left_buffer  <= (others => '0');
            right_buffer <= (others => '0');
        else
            if LRCK = '0' then
                right_buffer <= data_in;
            elsif LRCK = '1' then
                left_buffer <= data_in;
            end if;
        end if;
    end process;

    OUTPUT_DRIVER : process(left_buffer, right_buffer, nRst)
    begin
        if nRst = '0' then
            left_out  <= (others => '0');
            right_out <= (others => '0');
        else
            left_out  <= left_buffer;
            right_out <= right_buffer;
        end if;
    end process;

end architecture RTL;
