settings.outformat="pdf";
size(300);

import mosaic;

real sqrt3=sqrt(3);

path hexagon=(0,sqrt3/3)--(1/2,sqrt3/2)--(1,sqrt3/3)--(1,0)--(1/2,-sqrt3/6)--(0,0)--cycle;

inflation=sqrt3;

transform R30=rotate(30);

mrule ifs=mrule(hexagon);

ifs.addtile(R30,heavygray);
ifs.addtile(shift(sqrt3/2,1/2)*R30,heavygray);
ifs.addtile(shift(sqrt3/2,-1/2)*R30,heavygray);

int n=3;
mosaic M=mosaic(hexagon,n,ifs);
draw(M,white);
