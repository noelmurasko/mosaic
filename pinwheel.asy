settings.outformat="pdf";
size(300);

import mosaic;

path pinwheel=(0,0)--(2,0)--(2,1)--cycle;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

mtile P1=mtile(T,paleyellow);
mtile P2=mtile(T*shift(2,1),paleyellow);
mtile P3=mtile(T*reflect((2,0),(2,1)),heavyred);
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1),paleblue);
mtile P5=mtile(T*shift(4,2)*rotate(-90),brown);

int n=5;
mosaic M=mosaic(pinwheel,n,P1,P2,P3,P4,P5);
draw(M);
