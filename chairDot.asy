settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

mrule chairRule=mrule(chair); // chair substitution rule

chairRule.addtile(white,id="A");
chairRule.addtile(shift(1,1),orange,id="B");
chairRule.addtile(shift(4,0)*rotate(90),lightblue,id="C");
chairRule.addtile(shift(0,4)*rotate(270),lightblue,id="D");

// draw patch
int n=5;
mosaic M=mosaic(chair,n,chairRule);
draw(M);

path dot=shift(2/5,2/5)*scale(1/5)*unitcircle;
M.updateTesserae(dot,"B");
M.updateColour(lightblue,"B");
draw(M);

// decoration
/*
mrule dotRule=mrule(dot); // chair substitution rule

dotRule.addtile(lightblue);
dotRule.addtile(shift(1,1),white);
dotRule.addtile(shift(4,0)*rotate(90),orange);
dotRule.addtile(shift(0,4)*rotate(270),orange);

mosaic M=mosaic(n,dotRule);

draw(M);
*/
