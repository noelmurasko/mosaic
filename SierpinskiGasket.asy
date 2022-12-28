settings.outformat="pdf";
size(300);

import mosaic;

path triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;
path[] prototiles={triangle};

inflation=2;

ptransform T1=ptransform(triangle,black);
ptransform T2=ptransform(shift(1,sqrt(3)),triangle,black);
ptransform T3=ptransform(shift(2,0),triangle,black);

mrule triangleRule=mrule(triangle,T1,T2,T3);

int n=5;
mosaic M=mosaic(triangle,n,triangleRule);
draw(M);
