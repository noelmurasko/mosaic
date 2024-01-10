settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

substitution chairRule=substitution(chair); // chair substitution rule

chairRule.addtile(white);
chairRule.addtile(shift(1,1),orange);
chairRule.addtile(shift(4,0)*rotate(90),lightblue);
chairRule.addtile(shift(0,4)*rotate(270),lightblue);

path dot=(1/2,1/2);
chairRule.addlayer(dot,drawpen=blue+2);
write(chairRule.patch[0].fillpen[1]);
//chairRule.set(green+3);

// draw patch
int n=2;
mosaic M=mosaic(n,chairRule);
draw(M);
