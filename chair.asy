settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

// substitution rule
substitution chairRule=substitution(chair); 
chairRule.addtile(white);
chairRule.addtile(shift(1,1),orange);
chairRule.addtile(shift(4,0)*rotate(90),lightblue);
chairRule.addtile(shift(0,4)*rotate(270),lightblue);

// draw patch
int n=2;
mosaic M=mosaic(chair,n,chairRule);

mosaic N=duplicate2(M);
M.substitute(1);
draw(M);
M.set(green);
//N.substitute(1);
//draw(N);
