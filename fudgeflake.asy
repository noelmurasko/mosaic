settings.outformat="pdf";
size(300);

import mosaic;

real sqrt3=sqrt(3);

tile hexagon=tile((0,sqrt3/3)--(1/2,sqrt3/2)--(1,sqrt3/3)--(1,0)--(1/2,-sqrt3/6)--(0,0)--cycle,heavygray);

inflation=sqrt3;

transform R30=rotate(30);

substitution ifs=substitution(hexagon);

ifs.addtile(R30);
ifs.addtile(shift(sqrt3/2,1/2)*R30);
ifs.addtile(shift(sqrt3/2,-1/2)*R30);

int n=4;
mosaic M=mosaic(hexagon,n,ifs);

filldraw(M,white);
