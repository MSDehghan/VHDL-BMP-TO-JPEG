library IEEE; use IEEE.STD_LOGIC_1164.all;
package jpeg_package is
    signal max_size : integer := 64 * 64;
    type pixelType is array (2 downto 0) of std_logic_vector(7 downto 0);
    type pixelArrayType is array (max_size downto 0) of pixelType;
end package ;