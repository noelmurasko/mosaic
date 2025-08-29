settings.outformat="pdf";
size(300);

import mosaic;

currentinflation=2;

// prototile
tile chair=tile((0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle);

substitution chairRule=substitution(chair); // chair substitution rule

chairRule.addtile(white);
chairRule.addtile(shift(1,1),orange,"B");
chairRule.addtile(shift(4,0)*rotate(90),lightblue,"C");
chairRule.addtile(shift(0,4)*rotate(270),lightblue,"D");
int n=4;
mosaic M=mosaic(n,chairRule);

tile dot=(1/2,1/2);
M.addlayer();
M.updatelayer(dot,drawpen=black+10);

tile pentagon=shift(7/5,1/2)*rotate(30)*scale(1/5)*polygon(5);
tile hexagon=shift(1/2,7/5)*rotate(30)*scale(1/5)*polygon(6);
tile decorate=pentagon^^hexagon;

M.addlayer();
M.updatelayer(decorate);
M.updatelayer(lightblue);
M.updatelayer(white,"B");
M.updatelayer(orange,"C","D");
filldraw(M);
