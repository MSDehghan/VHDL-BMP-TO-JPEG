library IEEE; use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

package jpeg_package is
    constant MAX_SIZE : integer := 640;

    type pixel_type is array (0 to 2) of std_logic_vector(7 downto 0);
    type pixel_row_type is array (0 to MAX_SIZE) of pixel_type;
    type pixel_data_type is array (0 to MAX_SIZE) of pixel_row_type;
    type real_type is array (0 to 2) of REAL;
    type real_row_type is array (0 to MAX_SIZE) of real_type;
    type real_data_type is array (0 to MAX_SIZE) of real_row_type;
    type bmp_header is array (0 to 53) of std_logic_vector(7 downto 0);
    type integer_MCU is array (0 to 7 , 0 to 7) of integer;
    type real_MCU is array (0 to 7 , 0 to 7) of real;
    type integer_array is array (0 to 63) of integer;
    type state is (YUV,DCT,FINISHED);

    function RGB2YUV (input     : in pixel_type) return real_type;
    function Fourier (input     : in real_MCU) return real_MCU;
    function Quantizer (input   : in real_MCU; Quantizer_Matrix : in integer_MCU) return integers_MCU;
    constant MATH_SQRT1_2       :    real        := 0.70710_67811_86547_52440;
    constant MATH_PI            :    real        := 3.14159_26535_89793_23846;
    constant Y_Quantizer_Matrix :    integer_MCU := ((16, 11, 10, 16, 24, 40, 51, 61),
                                                    (12, 12, 14, 19, 26, 58, 60, 55),
                                                    (14, 13, 16, 24, 40, 57, 69, 56),
                                                    (14, 17, 22, 29, 51, 87, 80, 62),
                                                    (18, 22, 37, 56, 68, 109, 103, 77),
                                                    (24, 35, 55, 64, 81, 104, 113, 92),
                                                    (49, 64, 78, 87, 103, 121, 120, 101),
                                                    (72, 92, 95, 98, 112, 100, 103, 99));
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

    function Fourier (input : in real_MCU) return real_MCU is
        variable output                                : real_MCU;
        variable res, temp_cos_1, temp_cos_2,inner_res : real;
    begin
        for u in 0 to 7 loop
            for v in 0 to 7 loop
                res := 0.0;
                for x in 0 to 7 loop
                    for y in 0 to 7 loop
                        inner_res  := input(x,y);
                        temp_cos_1 := cos(((2.0 * real(x) + 1.0) * real(u) * MATH_PI) / 16.0);
                        temp_cos_2 := cos(((2.0 * real(y) + 1.0) * real(v) * MATH_PI) / 16.0);
                        res        := res + (inner_res * temp_cos_1 * temp_cos_2);
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
        variable output      : real_MCU;
        variable rounded_res : real;
    begin
        for u in 0 to 7 loop
            for v in 0 to 7 loop
                rounded_res := (input(u,v) / real(Quantizer_Matrix(u,v)));
                output(u,v) := integer(rounded_res);
            end loop;
        end loop;
        return output;
    end;

    
    function Zigzag (input : in integer_MCU) return integer_array is
        variable output : integer_array;
    begin
        output(0) := input(0,0);
        output(1) := input(0,1);
        output(2) := input(1,0);
        output(3) := input(2,0);
        output(4) := input(1,1);
        output(5) := input(0,2);
        output(6) := input(0,3);
        output(7) := input(1,2);
        output(8) := input(2,1);
        output(9) := input(3,0);
        output(10) := input(4,0);
        output(11) := input(3,1);
        output(12) := input(2,2);
        output(13) := input(1,3);
        output(14) := input(0,4);
        output(15) := input(0,5);
        output(16) := input(1,4);
        output(17) := input(2,3);
        output(18) := input(3,2);
        output(19) := input(4,1);
        output(20) := input(5,0);
        output(21) := input(6,0);
        output(22) := input(5,1);
        output(23) := input(4,2);
        output(24) := input(3,3);
        output(25) := input(2,4);
        output(26) := input(1,5);
        output(27) := input(0,6);
        output(28) := input(0,7);
        output(29) := input(1,6);
        output(30) := input(2,5);
        output(31) := input(3,4);
        output(32) := input(4,3);
        output(33) := input(5,2);
        output(34) := input(6,1);
        output(35) := input(7,0);
        output(36) := input(7,1);
        output(37) := input(6,2);
        output(38) := input(5,3);
        output(39) := input(4,4);
        output(40) := input(3,5);
        output(41) := input(2,6);
        output(42) := input(1,7);
        output(43) := input(2,7);
        output(44) := input(3,6);
        output(45) := input(4,5);
        output(46) := input(5,4);
        output(47) := input(6,3);
        output(48) := input(7,2);
        output(49) := input(7,3);
        output(50) := input(6,4);
        output(51) := input(5,5);
        output(52) := input(4,6);
        output(53) := input(3,7);
        output(54) := input(4,7);
        output(55) := input(5,6);
        output(56) := input(6,5);
        output(57) := input(7,4);
        output(58) := input(7,5);
        output(59) := input(6,6);
        output(60) := input(5,7);
        output(61) := input(6,7);
        output(62) := input(7,6);
        output(63) := input(7,7);
        return output;
    end;
end package body jpeg_package;
