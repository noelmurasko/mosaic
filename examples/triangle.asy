settings.outformat="pdf";
size(300);

import mosaic;

// prototile
tile tri=(0,0)--(1,sqrt(3))--(2,0)--cycle;

// inflation factor
currentinflation=2;

// number of iterations
int n=4;

// pinwheel substitution tiles
substitution triangleSub=substitution(tri);
triangleSub.addtile(identity);
triangleSub.addtile(shift(2,0));
triangleSub.addtile(shift(1,sqrt(3)));
triangleSub.addtile(shift(3,sqrt(3))*rotate(180));

// build the patch
mosaic M=mosaic(n,triangleSub);

// draw the patch
draw(M);
