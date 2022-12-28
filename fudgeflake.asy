settings.outformat="pdf";
size(300);

import mosaic;

real sqrt3=sqrt(3);

path hexagon=(0,sqrt3/3)--(1/2,sqrt3/2)--(1,sqrt3/3)--(1,0)--(1/2,-sqrt3/6)--(0,0)--cycle;

inflation=sqrt3;

transform R30=rotate(30);

ptransform H1=ptransform(R30,heavygray);
ptransform H2=ptransform(shift(sqrt3/2,1/2)*R30,heavygray);
ptransform H3=ptransform(shift(sqrt3/2,-1/2)*R30,heavygray);

mrule ifs=mrule(H1,H2,H3);

int n=7;
mosaic M=mosaic(hexagon,n,ifs);
draw(M,white);
