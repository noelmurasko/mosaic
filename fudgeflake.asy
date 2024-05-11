settings.outformat="pdf";
size(300);

import mosaic;

real sqrt3=sqrt(3);
inflation=sqrt3;
transform R30=rotate(30);

tile hexagon=tile(R30*polygon(6),heavygray);

substitution ifs=substitution(hexagon);

ifs.addtile(shift(1/2,-sqrt3/2)*R30);
ifs.addtile(shift(1/2,sqrt3/2)*R30);
ifs.addtile(shift(-1,0)*R30);

int n=4;
mosaic M=mosaic(hexagon,n,ifs);

filldraw(M,white);
