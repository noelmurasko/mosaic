settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

mtile C1=mtile(chair,white);
mtile C2=mtile(shift(1,1),chair,orange);
mtile C3=mtile(shift(4,0)*rotate(90),chair,blue);
mtile C4=mtile(shift(0,4)*rotate(270),chair,blue);

int n=3;
mtile[] Ts={C1,C2,C3,C4};
mtile[] b=substitute(Ts,chair,n);
draw(b);
