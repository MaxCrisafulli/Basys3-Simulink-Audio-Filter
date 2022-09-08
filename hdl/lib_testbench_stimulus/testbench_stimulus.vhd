library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_stimulus is
    port(
        SCLK       : in  std_logic;
        LRCK       : in  std_logic;
        nRst       : out std_logic;
        ADIN_SDOUT : out std_logic
    );
end entity testbench_stimulus;

architecture sim of testbench_stimulus is

    constant wb_length : integer := 32;

    subtype word is std_logic_vector(23 downto 0);
    type word_bank is array (wb_length - 1 downto 0) of word;

    constant TEST_WORD_BANK : word_bank := (
        x"800000", x"98F8B8", x"B0FBC5", x"C71CEC", x"DA8279",
        x"EA6D98",
        x"F641AE",
        x"FD8A5E",
        x"FFFFFF",
        x"FD8A5E",
        x"F641AE",
        x"EA6D98",
        x"DA8279",
        x"C71CEC",
        x"B0FBC5",
        x"98F8B8",
        x"800000",
        x"670747",
        x"4F043A",
        x"38E313",
        x"257D86",
        x"159267",
        x"09BE51",
        x"0275A1",
        x"000000",
        x"0275A1",
        x"09BE51",
        x"159267",
        x"257D86",
        x"38E313",
        x"4F043A",
        x"670747");

    signal TEST_WORD : word := x"000000";

begin

    -- Stimulus Process
    TB_STIM : process is
    begin
        nRst       <= '1';
        ADIN_SDOUT <= '0';
        wait for 1 us;
        nRst       <= '0';
        wait for 0.5 us;
        nRst       <= '1';

        for i in 0 to wb_length - 1 loop
            wait until LRCK'event;
            ADIN_SDOUT <= '0';
            TEST_WORD  <= TEST_WORD_BANK(i);
            for i in 1 to 24 loop       -- iterates and serially export TEST_WORD for 24 periods of SCLK (on falling edge)
                wait until falling_edge(SCLK);
                ADIN_SDOUT <= TEST_WORD(24 - i);
            end loop;
            wait until falling_edge(SCLK);
            ADIN_SDOUT <= '0';

            wait until LRCK'event;
            ADIN_SDOUT <= '0';
            TEST_WORD  <= TEST_WORD_BANK(i);
            for i in 1 to 24 loop       -- iterates and serially export TEST_WORD for 24 periods of SCLK (on falling edge)
                wait until falling_edge(SCLK);
                ADIN_SDOUT <= TEST_WORD(24 - i);
            end loop;
            wait until falling_edge(SCLK);
            ADIN_SDOUT <= '0';
        end loop;

        --        while (true) loop
        --            -- First word data
        --            wait until falling_edge(LRCK) or rising_edge(LRCK); -- trigger on LRCK edge
        --            ADIN_SDOUT <= '0';          -- set SDIN to blank for 1st period
        --            TEST_WORD  <= x"2bfc7b";    --set data for this LRCK period
        --            for i in 1 to 24 loop       -- iterates and serially export TEST_WORD for 24 periods of SCLK (on falling edge)
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- Second word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"d89866";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- third word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"e3a4d0";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- fourth word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"d76106";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- fifth word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"081b62";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- sixth word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"c0e348";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- seventh word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"1f7c21";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --
        --            -- eighth word
        --            wait until falling_edge(LRCK) or rising_edge(LRCK);
        --            ADIN_SDOUT <= '0';
        --            TEST_WORD  <= x"f45f1d";
        --            for i in 1 to 24 loop
        --                wait until falling_edge(SCLK);
        --                ADIN_SDOUT <= TEST_WORD(24 - i);
        --            end loop;
        --            wait until falling_edge(SCLK);
        --            ADIN_SDOUT <= '0';
        --        end loop;

    end process;
end architecture sim;
