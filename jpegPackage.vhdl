library IEEE; use IEEE.STD_LOGIC_1164.all;
package jpeg_package is
    constant MAX_SIZE : integer := 640;
    type pixel_type is array (0 to 2) of std_logic_vector(7 downto 0);
    type YUV_type is array (0 to 2) of REAL;
    type pixel_row_type is array (0 to MAX_SIZE) of pixel_type;
    type pixel_data_type is array (0 to MAX_SIZE) of pixel_row_type;
    type bmp_header is array (0 to 53) of std_logic_vector(7 downto 0);
    function RGB2YUV (input : pixel_type) return YUV_type is
        signal output: YUV_type;
    begin
        output(0) <=  (0.257 * REAL(input(0))) + (0.504 * REAL(input(1))) + (0.098 * REAL(input(2))) + 16.0;
        output(1) <=  (0.439 * REAL(input(0))) - (0.368 * REAL(input(1))) - (0.071 * REAL(input(2))) + 128.0;
        output(2) <= -(0.148 * REAL(input(0))) - (0.291 * REAL(input(1))) + (0.439 * REAL(input(2))) + 128.0;
    end
end package;