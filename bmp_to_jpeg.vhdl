library IEEE; library WORK;
use work.jpeg_Package.all;

entity bmp_to_jpeg is port (in_mem: in pixel_data_type;
                             width, height: in integer);
end bmp_to_jpeg;
architecture behavioral of bmp_to_jpeg is

begin
    process
    begin
        read_row : for i in height-1 downto 0 loop
            read_col : for j in 0 to width-1 loop
		-- code!
            end loop read_col;
        end loop read_row; 
    end process;
end behavioral ;