settings.outformat="pdf";
size(300);

import mosaic;

// prototile
tile tri=(0,0)--(1,0)--(1/2,sqrt(3)/2)--cycle;

// inflation factor
inflation=2;

// number of iterations
int n=4;

// pinwheel substitution tiles
substitution triangleSub=substitution(tri);
triangleSub.addtile(identity);
triangleSub.addtile(shift(1,0));
triangleSub.addtile(shift(1/2,sqrt(3)/2));
triangleSub.addtile(shift(3/2,sqrt(3)/2)*rotate(180));

// build the patch
mosaic M=mosaic(n,triangleSub);

// draw the patch
draw(M);
