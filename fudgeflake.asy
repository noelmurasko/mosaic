settings.outformat="pdf";
size(300);

import mosaic;

real s3=sqrt(3);

path hexagon=(0,s3/3)--(1/2,s3/2)--(1,s3/3)--(1,0)--(1/2,-s3/6)--(0,0)--cycle;
path[] prototiles={hexagon};

inflation=s3;

transform R=rotate(30);

ptransform H1=ptransform(R,hexagon,heavygray);
ptransform H2=ptransform(shift(s3/2,1/2)*R,hexagon,heavygray);
ptransform H3=ptransform(shift(s3/2,-1/2)*R,hexagon,heavygray);

mrule hexagonRule=mrule(hexagon,H1,H2,H3);

int n=9;
mosaic M=mosaic(hexagon,n,hexagonRule);
draw(M,white);
