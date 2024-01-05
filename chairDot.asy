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

int n=3;
mosaic M=mosaic(chair,n,chairRule);
draw(M);

path dot=(1/2,1/2);
M.update(dot);
draw(M,black+10);

path pentagon=shift(7/5,1/2)*rotate(30)*scale(1/5)*polygon(5);
path hexagon=shift(1/2,7/5)*rotate(30)*scale(1/5)*polygon(6);
path[] decorate=pentagon^^hexagon;

M.update(decorate,lightblue,"A");
M.update(decorate,white,"B");
M.update(decorate,orange,"C","D");
draw(M);
