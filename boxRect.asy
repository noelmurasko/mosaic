settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));

// square transforms
mtile S1=mtile(shift(0,1),square,pink);
mtile S2=mtile(shift(1,1),square,pink);
mtile S3=mtile(square,rect,heavygreen);

// rectangle transforms
mtile R1=mtile(shift(1,1),rect,square,pink);
mtile R2=mtile(shift(3,0),rect,square,pink);
mtile R3=mtile(shift(1,0)*rotate(90),rect,heavygreen);
mtile R4=mtile(shift(1,0),rect,heavygreen);
mtile R5=mtile(shift(2,1),rect,heavygreen);


int n=7;
mosaic M=mosaic(rect,n,S1,S2,S3,R1,R2,R3,R4,R5);
draw(M);
