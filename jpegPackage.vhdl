library IEEE; use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

package jpeg_package is
    constant MAX_SIZE : integer := 640;
    constant  MATH_SQRT1_2: real := 0.70710_67811_86547_52440; 
    constant  MATH_PI :  real := 3.14159_26535_89793_23846;
    type pixel_type is array (0 to 2) of std_logic_vector(7 downto 0);
    type real_type is array (0 to 2) of REAL;
    type pixel_row_type is array (0 to MAX_SIZE) of pixel_type;
    type real_row_type is array (0 to MAX_SIZE) of real_type;
    type pixel_data_type is array (0 to MAX_SIZE) of pixel_row_type;
    type real_data_type is array (0 to MAX_SIZE) of real_row_type;
    type bmp_header is array (0 to 53) of std_logic_vector(7 downto 0);
    type integer_MCU is array (0 to 7 , 0 to 7) of integer;
    type real_MCU is array (0 to 7 , 0 to 7) of real;
    type state is (YUV,DCT);
    function RGB2YUV (input : in pixel_type) return real_type;
    function Fourier (input : in integer_MCU) return real_MCU;
end package;
package body jpeg_package is
    function RGB2YUV (input : in pixel_type) return real_type is
        variable output : real_type;
    begin
        output(0) := (0.257 * real(to_integer(unsigned(input(0))))) + (0.504 * real(to_integer(unsigned(input(1))))) + (0.098 * real(to_integer(unsigned(input(2))))) + 16.0;
        output(1) := (0.439 * real(to_integer(unsigned(input(0))))) - (0.368 * real(to_integer(unsigned(input(1))))) - (0.071 * real(to_integer(unsigned(input(2))))) + 128.0;
        output(2) := -(0.148 * real(to_integer(unsigned(input(0))))) - (0.291 * real(to_integer(unsigned(input(1))))) + (0.439 * real(to_integer(unsigned(input(2))))) + 128.0;
        return output;
    end;

    function Fourier (input : in integer_MCU) return real_MCU is
        variable output : real_MCU;
        variable res, temp_cos_1, temp_cos_2: real;
    begin
        for u in 0 to 7 loop
            for v in 0 to 7 loop
                res := 0.0;
                for x in 0 to 7 loop
                    for y in 0 to 7 loop
                        temp_cos_1 := cos(((2.0 * real(x) + 1.0) * real(u) * MATH_PI) / 16.0);
                        temp_cos_2 := cos(((2.0 * real(y) + 1.0) * real(v) * MATH_PI) / 16.0);
                        res := res + temp_cos_1 * temp_cos_2;
                    end loop;
                end loop;
                if v = 0 then
                    res := res * MATH_SQRT1_2;
                end if;
                if u = 0 then
                    res := res * MATH_SQRT1_2;
                end if;
                output(u,v) := res * 0.25;
            end loop ;
        end loop ;
        return output;
    end;
end package body jpeg_package;