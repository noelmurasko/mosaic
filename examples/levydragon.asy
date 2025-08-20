settings.outformat="pdf";
size(300);

import mosaic;

tile t=tile((0,0)--(1,0)--(1/2,1/2)--cycle);

substitution tsub=substitution(t);
real s2=sqrt(2);
tsub.addtile(scale(s2/2)*rotate(45));
tsub.addtile(shift(1/2,1/2)*scale(s2/2)*rotate(-45));

int n=14;
mosaic M=mosaic(n, tsub);
draw(M);