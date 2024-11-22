settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototile
tile square=box((0,0),(1,1));

substitution squareRule=substitution(square); // substitution rule

// substitution tiles
squareRule.addtile(square,brown);
squareRule.addtile(shift(1,0),square,paleyellow);
squareRule.addtile(shift(1,1),square,brown);
squareRule.addtile(shift(0,1),square,paleyellow);

// draw patch
int n=4;
mosaic M=mosaic(n,squareRule);

filldraw(M);
