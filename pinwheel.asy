settings.outformat="pdf";
size(300);

import mosaic;

path[] pinwheel=(0,0)--(2,0)--(2,1)--cycle;

real sf=1/sqrt(5);
transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
Tile P1=Tile(T*scale(sf),pinwheel,paleyellow);
Tile P2=Tile(T*shift(2/sqrt(5),1/sqrt(5))*scale(sf),pinwheel,paleyellow);
Tile P3=Tile(T*reflect((2/sqrt(5), 0),(2/sqrt(5),1))*scale(sf),pinwheel,heavyred);
Tile P4=Tile(T*reflect((0,1/sqrt(5)),(1,1/sqrt(5)))*shift(2/sqrt(5),1/sqrt(5))*scale(sf),pinwheel,paleblue);
Tile P5=Tile(T*shift(4/sqrt(5),2/sqrt(5))*rotate(-90)*scale(sf),pinwheel,brown);

int n=3;
Tile[] Ts={P1,P2,P3,P4,P5};
Tile[] b=subTile(Ts,pinwheel,n);
drawTiling(b);
