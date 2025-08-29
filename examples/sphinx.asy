settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
currentinflation=2;

// prototile
real h=sqrt(3)/2;
real H=sqrt(3);
tile sphinx=tile((0,0)--(3,0)--(2.5,h)--(1.5,h)--(1,H)--cycle, mediumgray);

// substitution rule
substitution sphinxRule=substitution(sphinx);
sphinxRule.addtile(shift(2,2H)*rotate(-120),mediumgray);
sphinxRule.addtile(shift(3)*rotate(180)*reflect(0,1),orange);
sphinxRule.addtile(shift(2,2h)*reflect(0,1),paleyellow);
sphinxRule.addtile(shift(6)*rotate(180)*reflect(0,1),lightblue);

// draw patch
int n=5;
mosaic M=mosaic(n,sphinxRule);
draw(M);

n=4;
M=mosaic(n,sphinxRule);
draw(scale(2)*M, p=black+3);


n=3;
M=mosaic(n,sphinxRule);
draw(scale(4)*M, p=black+6);
