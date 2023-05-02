settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));

// square substitution rule
ptransform S1=ptransform(shift(0,1),square,pink);
ptransform S2=ptransform(shift(1,1),square,pink);
ptransform S3=ptransform(rect,heavygreen);

mrule squareRule=mrule(square,S1,S2,S3);

// rectangle substitution rule
ptransform R1=ptransform(shift(1,1),square,pink);
ptransform R2=ptransform(shift(3,0),square,pink);
ptransform R3=ptransform(shift(1,0)*rotate(90),rect,heavygreen);
ptransform R4=ptransform(shift(1,0),rect,heavygreen);
ptransform R5=ptransform(shift(2,1),rect,heavygreen);

mrule rectRule=mrule(rect,R1,R2,R3,R4,R5);

int n=2;
mosaic M=mosaic(rect,n,squareRule,rectRule);
draw(M);
