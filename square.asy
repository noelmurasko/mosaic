settings.outformat="pdf";
size(300);

import mosaic;
inflation=2;
path square=box((0,0),(1,1));

ptransform S1=ptransform(square,red);
ptransform S2=ptransform(shift(1,0),square,green);
ptransform S3=ptransform(shift(1,1),square,blue);
ptransform S4=ptransform(shift(0,1),square,yellow);

mrule squareRule=mrule(square,S1,S2,S3,S4);

int n=3;
mosaic M=mosaic(square,n,squareRule);
draw(M);
