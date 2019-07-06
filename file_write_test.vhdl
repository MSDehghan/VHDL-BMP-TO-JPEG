library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity example_file_io_tb is
 
    end example_file_io_tb;
     
    architecture behave of example_file_io_tb is

        type char_file is file of character;
        file file_RESULTS : char_file;
    begin
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
     
    end behave;