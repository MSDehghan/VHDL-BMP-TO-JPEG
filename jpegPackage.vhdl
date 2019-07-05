library IEEE; use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

package jpeg_package is
    constant MAX_SIZE : integer := 640;

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

    constant MATH_SQRT1_2: real := 0.70710_67811_86547_52440; 
    constant MATH_PI :  real := 3.14159_26535_89793_23846;
    constant Y_Quantizer_Matrix : integer_MCU := ((16, 11, 10, 16, 24, 40, 51, 61),
                                                    (12, 12, 14, 19, 26, 58, 60, 55),
                                                    (14, 13, 16, 24, 40, 57, 69, 56),
                                                    (14, 17, 22, 29, 51, 87, 80, 62),
                                                    (18, 22, 37, 56, 68, 109, 103, 77),
                                                    (24, 35, 55, 64, 81, 104, 113, 92),
                                                    (49, 64, 78, 87, 103, 121, 120, 101),
                                                    (72, 92, 95, 98, 112, 100, 103, 99));

    function RGB2YUV (input : in pixel_type) return real_type;
    function Fourier (input : in integer_MCU) return real_MCU;
    function Quantizer (input : in real_MCU; Quantizer_Matrix : in integer_MCU) return integer_MCU;
    
end package;
package body jpeg_package is
    function RGB2YUV (input : in pixel_type) return real_type is
        variable output : real_type;
    begin
        output(0) := (0.299 * real(to_integer(unsigned(input(0))))) + (0.587 * real(to_integer(unsigned(input(1))))) + (0.114 * real(to_integer(unsigned(input(2)))));
        output(1) := (0.5 * real(to_integer(unsigned(input(0))))) - (0.418688 * real(to_integer(unsigned(input(1))))) - (0.081312 * real(to_integer(unsigned(input(2))))) + 128.0;
        output(2) := -(0.168736 * real(to_integer(unsigned(input(0))))) - (0.331264 * real(to_integer(unsigned(input(1))))) + (0.5 * real(to_integer(unsigned(input(2))))) + 128.0;
        return output;
    end;

    function Fourier (input : in integer_MCU) return real_MCU is
        variable output : real_MCU;
        variable res, temp_cos_1, temp_cos_2,inner_res: real;
    begin
        for u in 0 to 7 loop
            for v in 0 to 7 loop
                res := 0.0;
                for x in 0 to 7 loop
                    for y in 0 to 7 loop
                        inner_res := real(input(x,y));
                        temp_cos_1 := cos(((2.0 * real(x) + 1.0) * real(u) * MATH_PI) / 16.0);
                        temp_cos_2 := cos(((2.0 * real(y) + 1.0) * real(v) * MATH_PI) / 16.0);
                        res := res + (inner_res * temp_cos_1 * temp_cos_2);
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

    function Quantizer (input : in real_MCU; Quantizer_Matrix : in integer_MCU) return integer_MCU is
        variable output : integer_MCU;
        variable rounded_res : real;
    begin
        for u in 0 to 7 loop
            for v in 0 to 7 loop
                rounded_res :=  (input(u,v) / real(Quantizer_Matrix(u,v)));
                output(u,v) := integer(rounded_res);
            end loop;
        end loop;
        return output;
    end;
end package body jpeg_package;