//settings.outformat="pdf";
size(400);

import mosaic;

// inflation factor
inflation=2;

// prototile
Label L=scale(0.2)*Label("L",(0.8,1));
tile chair=tile(texpath(L),black);
draw(chair);

// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile();
chairRule.addtile(shift(1,1));
chairRule.addtile(shift(4,0)*rotate(90));
chairRule.addtile(shift(0,4)*rotate(270));

// draw patch
int n=4;
mosaic M=mosaic(n,chairRule);
//filldraw(M);
