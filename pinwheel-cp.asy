settings.outformat="pdf";
size(300);

import mosaic;

path triangle=(0,0)--(2,0)--(2,1)--cycle;

path CP=((2,0)+2*(2,1)+(0,0))/4;

path triangleCP=triangle&CP;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

ptransform P1=ptransform(T);
ptransform P2=ptransform(T*shift(2,1));
ptransform P3=ptransform(T*reflect((2,0),(2,1)));
ptransform P4=ptransform(T*reflect((0,1),(1,1))*shift(2,1));
ptransform P5=ptransform(T*shift(4,2)*rotate(-90));

mrule pinRule=mrule(P1,P2,P3,P4,P5);
int n=5;
mosaic M=mosaic(triangleCP,n,pinRule);
transform reorient=rotate(-90-inflation^(n)*atan(1/2)-0.67);
draw(reorient*M);
