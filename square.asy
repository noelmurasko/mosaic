settings.outformat="pdf";
size(300);

import mosaic;
inflation=2;
path square=box((0,0),(1,1));

mtile S1=mtile(square,red);
mtile S2=mtile(shift(1,0),square,green);
mtile S3=mtile(shift(1,1),square,blue);
mtile S4=mtile(shift(0,1),square,yellow);

mrule squareRule=mrule(square,S1,S2,S3,S4);

int n=3;
mosaic M=mosaic(square,n,squareRule);
draw(M);
