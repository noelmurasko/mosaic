settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
real h=sqrt(3)/2;
real H=sqrt(3);
tile sphinx=tile((0,0)--(3,0)--(2.5,h)--(1.5,h)--(1,H)--cycle, lightgray);

// substitution rule
substitution sphinxRule=substitution(sphinx);
sphinxRule.addtile(shift(2,2H)*rotate(-120),mediumgray);
sphinxRule.addtile(shift(3)*rotate(180)*reflect(0,1),orange);
sphinxRule.addtile(shift(2,2h)*reflect(0,1),orange);
sphinxRule.addtile(shift(6)*rotate(180)*reflect(0,1),orange);
//filldraw(sphinxRule, drawboundary=true);

// draw patch
int n=2;
mosaic M=mosaic(n,sphinxRule);
filldraw(M);
