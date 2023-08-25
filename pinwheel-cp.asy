settings.outformat="pdf";
size(300);

import mosaic;

path triangle=(0,0)--(2,0)--(2,1)--cycle;

inflation=sqrt(5);

int n=0;

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
//transform reorient=rotate(-90-inflation^(n)*atan(1/2)-0.67);

mtile P1=mtile(T);
mtile P2=mtile(T*shift(2,1));
mtile P3=mtile(T*reflect((2,0),(2,1)));
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1));
mtile P5=mtile(T*shift(4,2)*rotate(-90));

mrule pinRule=mrule(P1,P2,P3,P4,P5);

mosaic M=mosaic(triangle,n,pinRule);
//M = reorient*M;
draw(M);

// decoration ===

pair CP=((2,0)+2*(2,1)+(0,0))/4;  // control point
path[] dot=shift(CP)*scale(1)*unitcircle;

mosaic CPs=mosaic(dot,n,pinRule);
//CPs = reorient*CPs;
draw(CPs);
