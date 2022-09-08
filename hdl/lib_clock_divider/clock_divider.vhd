library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
    generic(
        DIV_RATIO : integer := 1        -- Integer frequency division ratio (IN/OUT)
    );
    port(
        clk_in  : in  std_logic;        -- Input clk, clk_in >= clk_out
        nRst    : in  std_logic;        -- Asynchronous negative reset
        clk_out : out std_logic         -- output divided clock
    );
end entity clock_divider;

architecture RTL of clock_divider is
    signal count       : integer   := 0;
    signal clk_out_buf : std_logic := '0';
begin

    COUNTER : process(clk_in, nRst)
    begin
        if (nRst = '0') then
            count       <= 0;
            clk_out_buf <= '0';
        else
            if rising_edge(clk_in) then
                count <= count + 2;
                if count = DIV_RATIO - 2 then
                    count       <= 0;
                    clk_out_buf <= not clk_out_buf;
                end if;
            end if;
        end if;
    end process;

    clk_out <= clk_out_buf;

end architecture RTL;
