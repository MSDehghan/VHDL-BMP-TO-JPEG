library IEEE; use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package jpeg_package is
    constant MAX_SIZE : integer := 640;
    type pixel_type is array (0 to 2) of std_logic_vector(7 downto 0);
    type YUV_type is array (0 to 2) of REAL;
    type pixel_row_type is array (0 to MAX_SIZE) of pixel_type;
    type pixel_data_type is array (0 to MAX_SIZE) of pixel_row_type;
    type bmp_header is array (0 to 53) of std_logic_vector(7 downto 0);
end package;
package body jpeg_package is
    function RGB2YUV (input : pixel_type) return YUV_type is
        variable output: YUV_type;
    variable temp_y, temp_u, temp_v: REAL;
    begin
        output(0) :=  (0.257 * real(to_integer(unsigned(input(0))))) + (0.504 * real(to_integer(unsigned(input(1))))) + (0.098 * real(to_integer(unsigned(input(2))))) + 16.0;
        output(1):=  (0.439 * real(to_integer(unsigned(input(0))))) - (0.368 * real(to_integer(unsigned(input(1))))) - (0.071 * real(to_integer(unsigned(input(2))))) + 128.0;
        output(2) := -(0.148 * real(to_integer(unsigned(input(0))))) - (0.291 * real(to_integer(unsigned(input(1))))) + (0.439 * real(to_integer(unsigned(input(2))))) + 128.0;
    	return output;
    end;
end package body jpeg_package;

