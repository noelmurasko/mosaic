settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// starting set
path triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

// ifs substitution tiles
mtile T1=mtile(black);
mtile T2=mtile(shift(1,sqrt(3)),black);
mtile T3=mtile(shift(2,0),black);

mrule ifs=mrule(T1,T2,T3);  // ifs substitution rule

// draw patch
int n=8;
mosaic M=mosaic(triangle,n,ifs);
draw(M);
