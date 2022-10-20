settings.outformat="pdf";
size(300);

import mosaic;

path[] triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

inflation=2;

mtile T1=mtile(triangle,black);
mtile T2=mtile(shift(1,sqrt(3)),triangle,black);
mtile T3=mtile(shift(2,0),triangle,black);

int n=5;
mtile[] Ts={T1,T2,T3};
mtile[] b=substitute(Ts,triangle,n);
draw(b);
