settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototiles
path chair=(0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle;
path rect=(0,0)--(3,0)--(3,1)--(0,1)--cycle;

// chair substitution tiles
mtile C1=mtile(shift(2,2)*rotate(180),chair,yellow);
mtile C2=mtile(shift(2,1),chair,yellow);
mtile C3=mtile(shift(4,4)*rotate(180),chair,yellow);
mtile C4=mtile(shift(1,0),rect,red);

mrule chairRule=mrule(chair,C1,C2,C3,C4);  // chair substitution rule

// rectangle substitution tiles
mtile R1=mtile(shift(4,0),chair,yellow);
mtile R2=mtile(shift(2,2)*rotate(180),chair,yellow);
mtile R3=mtile(shift(1,0),rect,red);
mtile R4=mtile(shift(2,1),rect,red);

mrule rectRule=mrule(rect,R1,R2,R3,R4);  // rectangle substitution rule

// draw patch
int n=6;
mosaic M=mosaic(rect,n,chairRule,rectRule);
draw(M);
