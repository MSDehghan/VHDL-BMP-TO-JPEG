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
    type huffman_tuple is array (0 to 1) of integer;
    type huffman_array is array (0 to 255) of huffman_tuple;
    type real_MCU is array (0 to 7 , 0 to 7) of real;
    type integer_array is array (0 to 63) of integer;
    type BYTE is array(7 downto 0) of BIT;
    type state is (YUV,DCT,FINISHED);

    function RGB2YUV (input     : in pixel_type) return real_type;
    function Fourier (input     : in real_MCU) return real_MCU;
    function Quantizer (input   : in real_MCU; Quantizer_Matrix : in integer_MCU) return integer_MCU;
    function Zigzag (input : in integer_MCU) return integer_array;
    function CalcBits (input : in integer) return huffman_tuple;

    constant Jpeg_Header_1      :    String      :="";
    constant Jpeg_Header_2      :    String      :="";
    constant UVDC_HT            :    huffman_array := ( (0,2),(1,2),(2,2),(6,3),(14,4),(30,5),(62,6),(126,7),(254,8),(510,9),(1022,10),(2046,11), others => (0,0));
    constant YDC_HT             :    huffman_array := ( (0,2),(2,3),(3,3),(4,3),(5,3),(6,3),(14,4),(30,5),(62,6),(126,7),(254,8),(510,9) , others => (0,0));
    constant YAC_HT             :    huffman_array := ( 
		(10,4),(0,2),(1,2),(4,3),(11,4),(26,5),(120,7),(248,8),(1014,10),(65410,16),(65411,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(12,4),(27,5),(121,7),(502,9),(2038,11),(65412,16),(65413,16),(65414,16),(65415,16),(65416,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(28,5),(249,8),(1015,10),(4084,12),(65417,16),(65418,16),(65419,16),(65420,16),(65421,16),(65422,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(58,6),(503,9),(4085,12),(65423,16),(65424,16),(65425,16),(65426,16),(65427,16),(65428,16),(65429,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(59,6),(1016,10),(65430,16),(65431,16),(65432,16),(65433,16),(65434,16),(65435,16),(65436,16),(65437,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(122,7),(2039,11),(65438,16),(65439,16),(65440,16),(65441,16),(65442,16),(65443,16),(65444,16),(65445,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(123,7),(4086,12),(65446,16),(65447,16),(65448,16),(65449,16),(65450,16),(65451,16),(65452,16),(65453,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(250,8),(4087,12),(65454,16),(65455,16),(65456,16),(65457,16),(65458,16),(65459,16),(65460,16),(65461,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(504,9),(32704,15),(65462,16),(65463,16),(65464,16),(65465,16),(65466,16),(65467,16),(65468,16),(65469,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(505,9),(65470,16),(65471,16),(65472,16),(65473,16),(65474,16),(65475,16),(65476,16),(65477,16),(65478,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(506,9),(65479,16),(65480,16),(65481,16),(65482,16),(65483,16),(65484,16),(65485,16),(65486,16),(65487,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(1017,10),(65488,16),(65489,16),(65490,16),(65491,16),(65492,16),(65493,16),(65494,16),(65495,16),(65496,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(1018,10),(65497,16),(65498,16),(65499,16),(65500,16),(65501,16),(65502,16),(65503,16),(65504,16),(65505,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(2040,11),(65506,16),(65507,16),(65508,16),(65509,16),(65510,16),(65511,16),(65512,16),(65513,16),(65514,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(65515,16),(65516,16),(65517,16),(65518,16),(65519,16),(65520,16),(65521,16),(65522,16),(65523,16),(65524,16),(0,0),(0,0),(0,0),(0,0),(0,0),
        (2041,11),(65525,16),(65526,16),(65527,16),(65528,16),(65529,16),(65530,16),(65531,16),(65532,16),(65533,16),(65534,16),(0,0),(0,0),(0,0),(0,0),(0,0)
        , others => (0,0)
    );
    constant UVAC_HT             :    huffman_array := ( 
		(0,2),(1,2),(4,3),(10,4),(24,5),(25,5),(56,6),(120,7),(500,9),(1014,10),(4084,12),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(11,4),(57,6),(246,8),(501,9),(2038,11),(4085,12),(65416,16),(65417,16),(65418,16),(65419,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(26,5),(247,8),(1015,10),(4086,12),(32706,15),(65420,16),(65421,16),(65422,16),(65423,16),(65424,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(27,5),(248,8),(1016,10),(4087,12),(65425,16),(65426,16),(65427,16),(65428,16),(65429,16),(65430,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(58,6),(502,9),(65431,16),(65432,16),(65433,16),(65434,16),(65435,16),(65436,16),(65437,16),(65438,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(59,6),(1017,10),(65439,16),(65440,16),(65441,16),(65442,16),(65443,16),(65444,16),(65445,16),(65446,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(121,7),(2039,11),(65447,16),(65448,16),(65449,16),(65450,16),(65451,16),(65452,16),(65453,16),(65454,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(122,7),(2040,11),(65455,16),(65456,16),(65457,16),(65458,16),(65459,16),(65460,16),(65461,16),(65462,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(249,8),(65463,16),(65464,16),(65465,16),(65466,16),(65467,16),(65468,16),(65469,16),(65470,16),(65471,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(503,9),(65472,16),(65473,16),(65474,16),(65475,16),(65476,16),(65477,16),(65478,16),(65479,16),(65480,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(504,9),(65481,16),(65482,16),(65483,16),(65484,16),(65485,16),(65486,16),(65487,16),(65488,16),(65489,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(505,9),(65490,16),(65491,16),(65492,16),(65493,16),(65494,16),(65495,16),(65496,16),(65497,16),(65498,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(506,9),(65499,16),(65500,16),(65501,16),(65502,16),(65503,16),(65504,16),(65505,16),(65506,16),(65507,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(2041,11),(65508,16),(65509,16),(65510,16),(65511,16),(65512,16),(65513,16),(65514,16),(65515,16),(65516,16),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
		(16352,14),(65517,16),(65518,16),(65519,16),(65520,16),(65521,16),(65522,16),(65523,16),(65524,16),(65525,16),(0,0),(0,0),(0,0),(0,0),(0,0),
		(1018,10),(32707,15),(65526,16),(65527,16),(65528,16),(65529,16),(65530,16),(65531,16),(65532,16),(65533,16),(65534,16),(0,0),(0,0),(0,0),(0,0),(0,0)
        , others => (0,0)
        );
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
    constant UV_Quantizer_Matrix :    integer_MCU := ((17, 18, 24, 47, 99, 99, 99, 99),
                                                    (18, 21, 26, 66, 99, 99, 99, 99),
                                                    (24, 26, 56, 99, 99, 99, 99, 99),
                                                    (47, 66, 99, 99, 99, 99, 99, 99),
                                                    (99, 99, 99, 99, 99, 99, 99, 99),
                                                    (99, 99, 99, 99, 99, 99, 99, 99),
                                                    (99, 99, 99, 99, 99, 99, 99, 99),
                                                    (99, 99, 99, 99, 99, 99, 99, 99));
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
        variable output      : integer_MCU;
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

    function CalcBits (input : in integer) return huffman_tuple is
        variable output :huffman_tuple;
        variable temp : integer;
        variable absin : integer;
    begin
        if input < 0 then
            temp := input - 1;
            absin := -input;
        else
            temp := input;
            absin := input;
        end if;
        output(1) := integer(ceil(log2(real(absin))));
        output(0) := temp;
        return output;
    end;
    
end package body jpeg_package;
