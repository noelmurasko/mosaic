settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle,shadepena=white, shadepointa=(0,0), shadepenb=grey,shadepointb=(1,1));

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile(white);
chairRule.addtile(shift(1,1),orange);
chairRule.addtile(shift(4,0)*rotate(90),lightblue);
chairRule.addtile(shift(0,4)*rotate(270),lightblue);

// draw patch
int n=5;
mosaic M=mosaic(chair,n,chairRule);
axialshade(M);
draw(M);
