settings.outformat="pdf";
size(300);

import mosaic;

path[] triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

mtile T1=mtile(scale(1/2),triangle,black);
mtile T2=mtile(shift(1/2,sqrt(3)/2)*scale(1/2),triangle,black);
mtile T3=mtile(shift(1,0)*scale(1/2),triangle,black);

int n=5;
mtile[] Ts={T1,T2,T3};
mtile[] b=substitute(Ts,triangle,n);
draw(b);
