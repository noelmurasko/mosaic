settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=1;

// prototile
tile tri=tile(polygon(3),black);
tile hex=tile(polygon(6),black);

transform s=scale(1/3);

// substitution rule
substitution kochRule=substitution(tri);
kochRule.addtile(scale(1/sqrt(3))*hex);

kochRule.addtile(shift(1/sqrt(3),1/3)*rotate(60)*s);
kochRule.addtile(shift(-1/sqrt(3),1/3)*rotate(-60)*s);

kochRule.addtile(shift(-1/sqrt(3),-1/3)*rotate(120)*s);
kochRule.addtile(shift(1/sqrt(3),-1/3)*rotate(120)*s);

kochRule.addtile(shift(0,2/3)*s);
kochRule.addtile(shift(0,-2/3)*rotate(180)*s);

// draw patch
int n=4;
mosaic M=mosaic(n,kochRule);
filldraw(M);
