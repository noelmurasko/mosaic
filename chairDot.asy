settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

substitution chairRule=substitution(chair); // chair substitution rule

chairRule.addtile(white,id="A");
chairRule.addtile(shift(1,1),orange,id="B");
chairRule.addtile(shift(4,0)*rotate(90),lightblue,id="C");
chairRule.addtile(shift(0,4)*rotate(270),lightblue,id="D");

pair dot=(1/2,1/2);
chairRule.addlayer(dot,black+2);

// Add more complicated decorations
path pentagon=shift(7/5,1/2)*rotate(30)*scale(1/5)*polygon(5);
path hexagon=shift(1/2,7/5)*rotate(30)*scale(1/5)*polygon(6);
path[] decorate=pentagon^^hexagon;

chairRule.addlayer(decorate);
chairRule.set(lightblue,"A");
chairRule.set(white,"B");
chairRule.set(orange,"C","D");

int n=4;
mosaic M=mosaic(chair,n,chairRule);
draw(M);
