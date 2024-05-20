settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle,shadepena=lightgrey, shadepointa=(0,0), shaderadiusa=0, shadepenb=darkgrey,shadepointb=(0,0),shaderadiusb=2);

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile(white);
chairRule.addtile(shift(1,1),orange);
chairRule.addtile(shift(4,0)*rotate(90),lightblue);
chairRule.addtile(shift(0,4)*rotate(270),lightblue);

// draw patch
int n=4;
mosaic M=mosaic(chair,n,chairRule);
radialshade(M);
draw(M);
