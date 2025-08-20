settings.outformat="pdf";
size(300);

import mosaic;

tile L=tile((0,0)--(1,0));

substitution Lsub=substitution(L);
real s3=sqrt(3);
Lsub.addtile(shift(1/2,s3/6)*scale(1/s3)*rotate(-150));
Lsub.addtile(shift(1,0)*scale(1/s3)*rotate(150));

int n=6;
mosaic M=mosaic(2n, Lsub);
draw(M, p=black+0.2);


