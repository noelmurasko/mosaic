settings.outformat="pdf";
size(300);

import mosaic;

path triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

inflation=2;

ptransform T1=ptransform(black);
ptransform T2=ptransform(shift(1,sqrt(3)),black);
ptransform T3=ptransform(shift(2,0),black);

mrule ifs=mrule(T1,T2,T3);

int n=5;
mosaic M=mosaic(triangle,n,ifs);
draw(M);
