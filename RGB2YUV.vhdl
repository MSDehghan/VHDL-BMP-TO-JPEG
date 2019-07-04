entity RGB2YUV is
    port(R, G, B: in NATURAL range 0 to 255;
         Y, U, V: out REAL);
  end RGB2YUV;
  
  architecture ARC of RGB2YUV is
  begin
    Y <=  (0.257 * REAL(R)) + (0.504 * REAL(G)) + (0.098 * REAL(B)) + 16.0;
    V <=  (0.439 * REAL(R)) - (0.368 * REAL(G)) - (0.071 * REAL(B)) + 128.0;
    U <= -(0.148 * REAL(R)) - (0.291 * REAL(G)) + (0.439 * REAL(B)) + 128.0;
  end ARC;