settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle, blue);

// substitution rule
substitution chairRule=substitution(chair);

chairRule.addtile(lightred);
chairRule.addtile(shift(1,1),lightblue);
chairRule.addtile(shift(4,0)*rotate(90),lightgreen);
chairRule.addtile(shift(0,4)*rotate(270),lightyellow);

// draw patch
int n=4;
mosaic M=mosaic(n,chairRule);
filldraw(M);
