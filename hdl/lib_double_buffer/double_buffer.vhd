library ieee;
use ieee.std_logic_1164.all;

entity double_buffer is
    generic(
        DATA_WIDTH : integer := 16      -- Generic DB Data Width
    );
    port(
        nRst     : in  std_logic;       -- Negative Reset for Buffers and Data Out
        LRCK     : in  std_logic;       -- Output Activation Clock
        data_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0); -- Data In for DB
        data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0) --  Data Out for DB
    );
end entity double_buffer;

architecture RTL of double_buffer is
    signal bufferA : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0'); -- 'BufferA' Register
    signal bufferB : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0'); -- 'BufferB' Register
begin

    -- Write process
    p_read_write : process(data_in, LRCK, bufferA, bufferB, nRst)
    begin
        if nRst = '0' then
            bufferA  <= (others => '0');
            bufferB  <= (others => '0');
            data_out <= (others => '0');
        else
            if (LRCK = '0') then
                bufferA  <= data_in;
                data_out <= bufferB;
            elsif (LRCK = '1') then
                bufferB  <= data_in;
                data_out <= bufferA;
            else
                bufferA  <= (others => '0');
                bufferB  <= (others => '0');
                data_out <= (others => '0');
            end if;
        end if;
    end process;

end architecture RTL;
