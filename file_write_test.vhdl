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
        constant header : string := "man mikonamet sadegh!";
    begin
      process
        variable written_byte: character;
      begin
        file_open(file_RESULTS, "output_results.txt", write_mode);
        for i in 1 to 21 loop
        written_byte := header(i);
        write(file_RESULTS, written_byte);
        end loop;
        file_close(file_RESULTS);
        wait;
      end process;
     
    end behave;