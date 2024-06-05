settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;
// starting set
tile triangle=tile((0,0)--(1,sqrt(3))--(2,0)--cycle,black);

substitution ifs=substitution(triangle); // ifs substitution rule

ifs.addtile();
ifs.addtile(shift(1,sqrt(3)));
ifs.addtile(shift(2,0));

// draw patch
int n=4;
mosaic M=mosaic(triangle,n,ifs);
filldraw(M);
