settings.outformat="pdf";
size(300);

import mosaic;

path[] triangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;

Tile T1=Tile(scale(1/2),triangle,black);
Tile T2=Tile(shift(1/2,sqrt(3)/2)*scale(1/2),triangle,black);
Tile T3=Tile(shift(1,0)*scale(1/2),triangle,black);

int n=5;
Tile[] Ts={T1,T2,T3};
Tile[] b=subTile(Ts,triangle,n);
drawTiling(b);
