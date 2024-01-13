settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
tile chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;
substitution chairRule=substitution(chair); // chair substitution rule

chairRule.addtile(white,id="A");
chairRule.addtile(shift(1,1),orange,id="B");
chairRule.addtile(shift(4,0)*rotate(90),lightblue,id="C");
chairRule.addtile(shift(0,4)*rotate(270),lightblue,id="D");

int n=4;
mosaic M=mosaic(chair,n,chairRule);

pair dot=(1/2,1/2);
M.addlayer(dot,black+10);

path pentagon=shift(7/5,1/2)*rotate(30)*scale(1/5)*polygon(5);
path hexagon=shift(1/2,7/5)*rotate(30)*scale(1/5)*polygon(6);
tile decorate=pentagon^^hexagon;

M.addlayer(decorate);
M.set(lightblue,"A");
M.set(white,"B");
M.set(orange,"C","D");

draw(M);
