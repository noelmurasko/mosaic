settings.outformat="pdf";
size(300);

import mosaic;

path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));

// square transforms
mtile S1=mtile(shift(0,1/2)*scale(1/2),square,red);
mtile S2=mtile(shift(1/2,1/2)*scale(1/2),square,orange);
mtile S3=mtile(scale(1/2),square,rect,yellow);

// rectangle transforms
mtile R1=mtile(shift(1/2,1/2)*scale(1/2),rect,square,red);
mtile R2=mtile(shift(3/2,0)*scale(1/2),rect,square,orange);
mtile R3=mtile(shift(1/2,0)*rotate(90)*scale(1/2),rect,yellow);
mtile R4=mtile(shift(1/2,0)*scale(1/2),rect,green);
mtile R5=mtile(shift(1,1/2)*scale(1/2),rect,blue);


int nmax=3;
mtile[] Ts={S1,S2,S3,R1,R2,R3,R4,R5};
mtile[] b=substitute(Ts,rect,nmax);
drawTiling(b);
