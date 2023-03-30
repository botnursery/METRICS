library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_signed.ALL;

    entity mysterie is
        port (

            clk  : in  std_logic;

            a    : in  std_logic_vector (7 downto 0);

            zero : in  std_logic;

            y    : out std_logic_vector (15 downto 0)

        );

    end entity;


    architecture simple of mysterie is

        signal s1, s2, s3 : std_logic_vector (15 downto 0);

    begin

        process (clk)

        begin

            if clk'event and clk = '1' then

                s1 <= s2;

                y <= s1;

            end if;

        end process;


        s2 <= (others => '0') when zero = '0' else s3;

        s3 <= ("00000000" & a) + s1;

    end simple;