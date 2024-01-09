settings.outformat="pdf";
size(300);

import mosaic;

path triangle=(0,0)--(2,0)--(2,1)--cycle;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
//transform reorient=rotate(-90-aTan(1/2));

// pinwheel substitution tiles
substitution pinRule=substitution(triangle);

pinRule.addtile(T, paleyellow);
pinRule.addtile(T*shift(2,1), paleyellow);
pinRule.addtile(T*reflect((2,0),(2,1)), lightred);
pinRule.addtile(T*reflect((0,1),(1,1))*shift(2,1),paleblue);
pinRule.addtile(T*shift(4,2)*rotate(-90),heavyred);

int n=4;
mosaic M=mosaic(triangle,n,pinRule);
draw(M);
