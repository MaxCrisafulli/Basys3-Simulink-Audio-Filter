library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.all;

entity sine_ROM is
    generic(
        DATA_WIDTH : integer := 24
    );
    port(
        address_index : in  integer range 0 to 31;
        data_out      : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity sine_ROM;

architecture RTL of sine_ROM is

    signal addr_int     : integer range 0 to 31;
    signal data_out_int : integer range -8390000 to 8390000;
    type ROM_type is array (0 to 31) of integer range -839 to 839;
    constant sineROM    : ROM_type := (
        0,164,321,466,593,697,775,823,838,823,775,697,593,466,321,164,0,-164,-321,-466,-593,-697,-775,-823,-838,-823,-775,-697,-593,-466,-321,-164
    );

begin

    addr_int <= address_index;

    p_READ_WRITE : process(addr_int, data_out_int)
    begin
        data_out_int <= sineROM(addr_int)*1e4;
        data_out     <= std_logic_vector(to_signed(data_out_int, DATA_WIDTH));
    end process;

end architecture RTL;
