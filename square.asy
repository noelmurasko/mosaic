settings.outformat="pdf";
size(300);

import mosaic;

path square=box((0,0),(1,1));

mtile S1=mtile(scale(1/2),square,white);
mtile S2=mtile(shift(1/2,0)*scale(1/2),square,red);
mtile S3=mtile(shift(1/2,1/2)*scale(1/2),square,white);
mtile S4=mtile(shift(0,1/2)*scale(1/2),square,red);

int n=5;
mtile[] Ts={S1,S2,S3,S4};
mtile[] b=substitute(Ts,square,n);
draw(b);
