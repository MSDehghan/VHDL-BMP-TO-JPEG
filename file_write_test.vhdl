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
        variable written_byte     : character;
      begin
        file_open(file_RESULTS, "output_results.txt", write_mode);
        written_byte := 'k';
        write(file_RESULTS, written_byte);
        written_byte := 'i';
        write(file_RESULTS, written_byte);
        written_byte := 'r';
        write(file_RESULTS, written_byte);
        file_close(file_RESULTS);
        wait;
      end process;
     
    end behave;