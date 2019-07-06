library IEEE; library WORK; use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_TEXTIO.ALL; use STD.TEXTIO.all;
use ieee.numeric_std.all ;
use work.jpeg_Package.all;

entity testbench is
end;

architecture sim of testbench is
    component bmp_to_jpeg is port (clk, reset : in STD_LOGIC;
            in_mem        : in pixel_data_type;
            width, height : in integer);
    end component;
    signal clk, reset : STD_LOGIC;
    signal data       : pixel_data_type := (others => (others => (others => (others => '0'))));
    signal w,h        : integer;
begin

    process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    process begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

    process
        variable byte                                                 : character;
        variable temp_int32_width,temp_int32_height,temp_int32_offset : std_logic_vector(31 downto 0);
        variable counter                                              : integer := 0;
        variable header                                               : bmp_header;
        variable height,width,image_offset                            : integer;
        type char_file is file of character;
        file fp : char_file;
    begin
        file_open(fp,"tiger.bmp", READ_MODE);

        -- Reading bmp header into an array
        for i in 0 to 53 loop
            read(fp, byte);
            header(i) := std_logic_vector(to_unsigned(natural(character'pos(byte)), 8));
            counter   := counter + 1;
        end loop;

        -- Extract header information
        temp_int32_width  := header(21) & header(20) & header(19) & header(18);
        width             := to_integer(signed(temp_int32_width));
        temp_int32_height := header(25) & header(24) & header(23) & header(22);
        height            := to_integer(signed(temp_int32_height));
        temp_int32_offset := header(13) & header(12) & header(11) & header(10);
        image_offset      := to_integer(signed(temp_int32_offset));

        -- skip metadata
        while ( counter < image_offset) loop
            read(fp, byte);
            counter := counter + 1;
        end loop ;

        read_row : for i in height-1 downto 0 loop
            read_col : for j in 0 to width-1 loop

                --Blue
                read(fp, byte);
                data(i)(j)(2) <= std_logic_vector(to_unsigned(natural(character'pos(byte)), 8));

                --Green
                read(fp, byte);
                data(i)(j)(1) <= std_logic_vector(to_unsigned(natural(character'pos(byte)), 8));

                --Red
                read(fp, byte);
                data(i)(j)(0) <= std_logic_vector(to_unsigned(natural(character'pos(byte)), 8));

                counter := counter + 3;
            end loop read_col;
            read(fp, byte);
            read(fp, byte);
            counter := counter + 3;
        end loop read_row;

        report "end!";
        report INTEGER'image(counter);
        file_close(fp);
        w <= width;
        h <= height;
        wait;
    end process;

        top : bmp_to_jpeg port map(clk,reset,data,w,h);

    process 
        type char_file is file of character;
        file fp, fpr: char_file;
        variable byte: character;
        variable w : integer:=630;
        variable h : integer:=534;
        variable wlv, hlv: std_logic_vector(15 downto 0);
    begin
        file_open(fpr, "part1.hex", read_mode);
        file_open(fp, "output_results.txt", write_mode);
        while not endfile(fpr) loop
        read(fpr, byte);
        write(fp,byte);
        end loop;
        file_close(fpr);

        hlv:= std_logic_vector(to_unsigned(h, 16));
        wlv:= std_logic_vector(to_unsigned(w, 16));
        write(fp, character'val(to_integer(unsigned(hlv(15 downto 8)))));
        write(fp, character'val(to_integer(unsigned(hlv(7 downto 0)))));
        write(fp, character'val(to_integer(unsigned(wlv(15 downto 8)))));
        write(fp, character'val(to_integer(unsigned(wlv(7 downto 0)))));
        
        file_open(fpr, "part2.hex", read_mode);
        while not endfile(fpr) loop
        read(fpr, byte);
        write(fp,byte);
        end loop;
        file_close(fpr);
        file_close(fp);
        wait;
    end process;

end architecture;