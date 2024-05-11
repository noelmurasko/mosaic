settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototiles
tile square=tile(box((0,0),(1,1)),pink);
tile rect=tile(box((0,0),(2,1)),heavygreen);


substitution squareRule=substitution(square);  // square substitution rule

squareRule.addtile(shift(0,1),square);
squareRule.addtile(shift(1,1),square);
squareRule.addtile(rect);

substitution rectRule=substitution(rect);  // rectangle substitution rule

rectRule.addtile(shift(1,1),square);
rectRule.addtile(shift(3,0),square);
rectRule.addtile(shift(1,0)*rotate(90),rect);
rectRule.addtile(shift(1,0),rect);
rectRule.addtile(shift(2,1),rect);


// draw patch
int n=4;
mosaic M=mosaic(rect,n,squareRule,rectRule);
filldraw(M);
