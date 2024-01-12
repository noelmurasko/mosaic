settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
tile square=box((0,0),(1,1));

substitution squareRule=substitution(square); // substitution rule

// substitution tiles
squareRule.addtile(square,red);
squareRule.addtile(shift(1,0),square,green);
squareRule.addtile(shift(1,1),square,blue);
squareRule.addtile(shift(0,1),square,yellow);

// draw patch
int n=4;
mosaic M=mosaic(square,n,squareRule);
draw(M);
