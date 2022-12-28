settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

ptransform C1=ptransform(white);
ptransform C2=ptransform(shift(1,1),orange);
ptransform C3=ptransform(shift(4,0)*rotate(90),blue);
ptransform C4=ptransform(shift(0,4)*rotate(270),blue);

mrule chairRule=mrule(C1,C2,C3,C4);

int n=4;
mosaic M=mosaic(chair,n,chairRule);
draw(M);
