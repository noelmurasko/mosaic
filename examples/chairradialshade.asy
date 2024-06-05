settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle,lightgrey,(0,0),0,darkgrey,(0,0),2);

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile();
chairRule.addtile(shift(1,1));
chairRule.addtile(shift(4,0)*rotate(90));
chairRule.addtile(shift(0,4)*rotate(270));

// draw patch
int n=4;
mosaic M=mosaic(chair,n,chairRule);
radialshade(M);
draw(M);
