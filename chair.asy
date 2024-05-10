settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=1;

// prototile
tile chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile(scale(0.5),white);
chairRule.addtile(scale(0.5)*shift(1,1),orange);
chairRule.addtile(scale(0.5)*shift(4,0)*rotate(90),lightblue);
chairRule.addtile(scale(0.5)*shift(0,4)*rotate(270),lightblue);

// draw patch
int n=3;
mosaic M=mosaic(chair,n,true,chairRule);
filldraw(M);
