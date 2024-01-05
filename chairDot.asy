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

int n=4;
mosaic M=mosaic(chair,n,chairRule);
draw(M);

// Add black dot
pair dot=(1/2,1/2);
M.set(dot);
draw(M,black+10);

// Add more complicated decorations
path pentagon=shift(7/5,1/2)*rotate(30)*scale(1/5)*polygon(5);
path hexagon=shift(1/2,7/5)*rotate(30)*scale(1/5)*polygon(6);
path[] decorate=pentagon^^hexagon;

M.set(decorate,lightblue,"A");
M.set(decorate,white,"B");
M.set(decorate,orange,"C","D");
draw(M);
