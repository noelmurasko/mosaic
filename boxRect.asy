settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

// prototiles
path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));

// square substitution tiles
mtile S1=mtile(shift(0,1),square,pink);
mtile S2=mtile(shift(1,1),square,pink);
mtile S3=mtile(rect,heavygreen);

mrule squareRule=mrule(square,S1,S2,S3);  // square substitution rule

// rectangle substitution tiles
mtile R1=mtile(shift(1,1),square,pink);
mtile R2=mtile(shift(3,0),square,pink);
mtile R3=mtile(shift(1,0)*rotate(90),rect,heavygreen);
mtile R4=mtile(shift(1,0),rect,heavygreen);
mtile R5=mtile(shift(2,1),rect,heavygreen);

mrule rectRule=mrule(rect,R1,R2,R3,R4,R5);  // rectangle substitution rule

// draw patch
int n=5;
mosaic M=mosaic(rect,n,squareRule,rectRule);
draw(M);
