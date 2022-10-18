settings.outformat="pdf";
size(300);

import mosaic;

path chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

mtile C1=mtile(scale(1/2),chair,white);
mtile C2=mtile(shift(1/2,1/2)*scale(1/2),chair,orange);
mtile C3=mtile(shift(2,0)*rotate(90)*scale(1/2),chair,blue);
mtile C4=mtile(shift(0,2)*rotate(270)*scale(1/2),chair,blue);

int n=5;
mtile[] Ts={C1,C2,C3,C4};
mtile[] b=substitute(Ts,chair,n);
drawTiling(b);
