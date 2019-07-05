library IEEE; library WORK;
use work.jpeg_Package.all;
use ieee.numeric_std.all;
entity tb is
end tb;
architecture simul of tb is
    signal input : integer_MCU;
    signal output : real_MCU;
begin   
    input (0,0) <= -76;
    input (0,1) <= -73;
    input (0,2) <= -67;
    input (0,3) <= -62;
    input (0,4) <= -58;
    input (0,5) <= -67;
    input (0,6) <= -64;
    input (0,7) <= -55;
    input (1,0) <= -65;
    input (1,1) <= -69;
    input (1,2) <= -73;
    input (1,3) <= -38;
    input (1,4) <= -19;
    input (1,5) <= -43;
    input (1,6) <= -59;
    input (1,7) <= -56;
    input (2,0) <= -66;
    input (2,1) <= -69;
    input (2,2) <= -60;
    input (2,3) <= -15;
    input (2,4) <= 16;
    input (2,5) <= -24;
    input (2,6) <= -62;
    input (2,7) <= -55;
    input (3,0) <= -65;
    input (3,1) <= -70;
    input (3,2) <= -57;
    input (3,3) <= -6;
    input (3,4) <= 26;
    input (3,5) <= -22;
    input (3,6) <= -58;
    input (3,7) <= -59;
    input (4,0) <= -61;
    input (4,1) <= -67;
    input (4,2) <= -60;
    input (4,3) <= -24;
    input (4,4) <= -2;
    input (4,5) <= -40;
    input (4,6) <= -60;
    input (4,7) <= -58;
    input (5,0) <= -49;
    input (5,1) <= -63;
    input (5,2) <= -68;
    input (5,3) <= -58;
    input (5,4) <= -51;
    input (5,5) <= -60;
    input (5,6) <= -70;
    input (5,7) <= -53;
    input (6,0) <= -43;
    input (6,1) <= -57;
    input (6,2) <= -64;
    input (6,3) <= -69;
    input (6,4) <= -73;
    input (6,5) <= -67;
    input (6,6) <= -63;
    input (6,7) <= -45;
    input (7,0) <= -41;
    input (7,1) <= -49;
    input (7,2) <= -59;
    input (7,3) <= -60;
    input (7,4) <= -63;
    input (7,5) <= -52;
    input (7,6) <= -50;
    input (7,7) <= -34;
    process begin
        output <=Fourier(input);
        wait;
    end process; 
end simul ;     