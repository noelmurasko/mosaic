settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
currentinflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle,white, (0,0), grey,(1,1));

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile();
chairRule.addtile(shift(1,1));
chairRule.addtile(shift(4,0)*rotate(90));
chairRule.addtile(shift(0,4)*rotate(270));

// draw patch
int n=5;
mosaic M=mosaic(n,chairRule);
axialshade(M);
draw(M);
