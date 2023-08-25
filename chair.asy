settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

// chair substitution tiles
mtile C1=mtile(white);
mtile C2=mtile(shift(1,1),orange);
mtile C3=mtile(shift(4,0)*rotate(90),lightblue);
mtile C4=mtile(shift(0,4)*rotate(270),lightblue);

mrule chairRule=mrule(C1,C2,C3,C4); // chair substitution rule

// draw patch
int n=6;
mosaic M=mosaic(chair,n,chairRule);
draw(M);
