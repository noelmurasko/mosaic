settings.outformat="pdf";
size(300);

import mosaic;

path[] pinwheel=(0,0)--(2,0)--(2,1)--cycle;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

mtile P1=mtile(T,pinwheel,paleyellow);
mtile P2=mtile(T*shift(2,1),pinwheel,paleyellow);
mtile P3=mtile(T*reflect((2,0),(2,1)),pinwheel,heavyred);
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1),pinwheel,paleblue);
mtile P5=mtile(T*shift(4,2)*rotate(-90),pinwheel,brown);

int n=5;
mtile[] Ts={P1,P2,P3,P4,P5};
mtile[] b=substitute(Ts,pinwheel,n);
draw(b);
