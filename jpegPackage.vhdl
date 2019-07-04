library IEEE; use IEEE.STD_LOGIC_1164.all;
package jpeg_package is
    constant MAX_SIZE : integer := 640;
    type pixel_type is array (0 to 2) of std_logic_vector(7 downto 0);
    type pixel_row_type is array (0 to MAX_SIZE) of pixel_type;
    type pixel_data_type is array (0 to MAX_SIZE) of pixel_row_type;
    type bmp_header is array (0 to 53) of std_logic_vector(7 downto 0);
end package;