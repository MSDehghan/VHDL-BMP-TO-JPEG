library IEEE; library WORK;
use work.jpeg_Package.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity bmp_to_jpeg is port (clk,reset : in std_logic;
        in_mem        : in pixel_data_type;
        width, height : in integer);
end bmp_to_jpeg;
architecture behavioral of bmp_to_jpeg is
    signal yuv_mem                           : real_data_type;
    signal next_i,next_j,current_i,current_j : integer := 0;
    signal current_state, next_state         : state;
begin
    process(clk) begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= YUV;
                current_i     <= 0;
                current_j     <= 0;
            else
                current_state <= next_state;
                current_i     <= next_i;
                current_j     <= next_j;
            end if;
        end if;
    end process;

    process(current_state, next_state,next_i,next_j,current_i,current_j)
        variable x,y : integer;
    begin
        case current_state is
            when YUV =>
                x := current_i;
                y := current_j;

                for i in x to (x+7) loop
                    for j in y to (y+7) loop
                        yuv_mem(i)(j) <= RGB2YUV(in_mem(i)(j));
                    end loop ;
                end loop ;

                y := y + 8;
                if y >= width then
                    y := 0;
                    x := x + 8;
                    if x >= height then next_state <= DCT; else next_state <= YUV; end if;
                else
                    next_state <= YUV;
                end if;

                next_i <= x;
                next_j <= y;
            when DCT =>
                next_state <= DCT;
            when others =>
                next_state <= YUV;
        end case;
    end process;

end behavioral ;

