library IEEE; library WORK;
use work.jpeg_Package.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity bmp_to_jpeg is port (clk,reset : in std_logic;
                            in_mem: in pixel_data_type;
                             width, height: in integer);
end bmp_to_jpeg;
architecture behavioral of bmp_to_jpeg is
signal yuv_mem: real_data_type;
signal i,j:     integer := 0;
signal current_state, next_state : state;
begin
    --process
    --begin
     --   read_row : for i in height-1 downto 0 loop
       --     read_col : for j in 0 to width-1 loop
		 --   yuv_mem(i)(j) <= RGB2YUV(in_mem(i)(j));
           -- end loop read_col;
        --end loop read_row; 
    --end process;
    process(clk) begin
        if rising_edge(clk) then
            if reset = '1'  then
                current_state <= YUV;
                i <= height-1;
                j <= 0;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    process(current_state, next_state,j,i)
        variable x,y : integer;
        begin
        case current_state is
            when YUV =>
                y := j;
                x := i;
                if y >= width then 
                    y := 0;
                    x := x + 1;
                        if x = 0 then next_state <= DCT; else next_state <= YUV; end if;
                else
                    yuv_mem(x)(y) <= RGB2YUV(in_mem(x)(y));
                    y := y + 1;
                    next_state <= YUV;
                end if;
            when DCT =>
                next_state <= DCT;
            when others =>
            	next_state <= YUV;
        end case;
    end process;

end behavioral ;

