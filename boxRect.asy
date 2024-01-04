settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototiles
path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));


mrule squareRule=mrule(square);  // square substitution rule

squareRule.addtile(shift(0,1),square,pink);
squareRule.addtile(shift(1,1),square,pink);
squareRule.addtile(rect,heavygreen);

mrule rectRule=mrule(rect);  // rectangle substitution rule

rectRule.addtile(shift(1,1),square,pink);
rectRule.addtile(shift(3,0),square,pink);
rectRule.addtile(shift(1,0)*rotate(90),rect,heavygreen);
rectRule.addtile(shift(1,0),rect,heavygreen);
rectRule.addtile(shift(2,1),rect,heavygreen);


// draw patch
int n=5;
mosaic M=mosaic(rect,n,squareRule,rectRule);
draw(M);
