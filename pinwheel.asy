settings.outformat="pdf";
size(300);

import mosaic;

path[] pinwheel=(0,0)--(2,0)--(2,1)--cycle;

real sf=1/sqrt(5);
transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
mtile P1=mtile(T*scale(sf),pinwheel,paleyellow);
mtile P2=mtile(T*shift(2/sqrt(5),1/sqrt(5))*scale(sf),pinwheel,paleyellow);
mtile P3=mtile(T*reflect((2/sqrt(5), 0),(2/sqrt(5),1))*scale(sf),pinwheel,heavyred);
mtile P4=mtile(T*reflect((0,1/sqrt(5)),(1,1/sqrt(5)))*shift(2/sqrt(5),1/sqrt(5))*scale(sf),pinwheel,paleblue);
mtile P5=mtile(T*shift(4/sqrt(5),2/sqrt(5))*rotate(-90)*scale(sf),pinwheel,brown);

int n=3;
mtile[] Ts={P1,P2,P3,P4,P5};
mtile[] b=substitute(Ts,pinwheel,n);
drawTiling(b);
