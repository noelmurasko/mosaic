settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;
// starting set
path triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

substitution ifs=substitution(triangle); // ifs substitution rule

ifs.addtile(black);
ifs.addtile(shift(1,sqrt(3)),black);
ifs.addtile(shift(2,0),black);

// draw patch
int n=8;
mosaic M=mosaic(triangle,n,ifs);
//draw(M);
