settings.outformat="pdf";
size(300);

import mosaic;

inflation=sqrt(3);
transform R30=rotate(30);

tile hexagon=tile(R30*polygon(6),heavygray,white);

substitution ifs=substitution(hexagon);

ifs.addtile(shift(1/2,-sqrt(3)/2)*R30);
ifs.addtile(shift(1/2,sqrt(3)/2)*R30);
ifs.addtile(shift(-1,0)*R30);

int n=1;
mosaic M=mosaic(n,ifs);
filldraw(M);
