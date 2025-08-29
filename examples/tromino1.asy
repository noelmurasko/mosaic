settings.outformat="pdf";
size(300);

import mosaic;

currentinflation=2;

// prototiles
tile chair=tile((0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle,paleyellow);
tile rect=tile((0,0)--(3,0)--(3,1)--(0,1)--cycle,lightred);

substitution chairRule=substitution(chair);  // chair substitution rule

chairRule.addtile(shift(2,2)*rotate(180),chair);
chairRule.addtile(shift(2,1),chair);
chairRule.addtile(shift(4,4)*rotate(180),chair);
chairRule.addtile(shift(1,0),rect);

substitution rectRule=substitution(rect);  // rectangle substitution rule

rectRule.addtile(shift(4,0),chair);
rectRule.addtile(shift(2,2)*rotate(180),chair);
rectRule.addtile(shift(1,0),rect);
rectRule.addtile(shift(2,1),rect);


// draw patch
int n=4;
mosaic M=mosaic(n,chairRule,rectRule);
filldraw(M);
