settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototiles
path chair=(0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle;
path rect=(0,0)--(3,0)--(3,1)--(0,1)--cycle;


mrule chairRule=mrule(chair);  // chair substitution rule

chairRule.addtile(shift(2,2)*rotate(180),chair,yellow);
chairRule.addtile(shift(2,1),chair,yellow);
chairRule.addtile(shift(4,4)*rotate(180),chair,yellow);
chairRule.addtile(shift(1,0),rect,red);


mrule rectRule=mrule(rect);  // rectangle substitution rule

rectRule.addtile(shift(4,0),chair,yellow);
rectRule.addtile(shift(2,2)*rotate(180),chair,yellow);
rectRule.addtile(shift(1,0),rect,red);
rectRule.addtile(shift(2,1),rect,red);


// draw patch
int n=6;
mosaic M=mosaic(rect,n,chairRule,rectRule);
draw(M);
