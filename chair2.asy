settings.outformat="pdf";
size(300);

import mosaic;

path[] chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle^^shift(2/5,2/5)*scale(1/5)*unitcircle;

Tile C1=Tile(scale(1/2),chair,white);
Tile C2=Tile(shift(1/2,1/2)*scale(1/2),chair,orange);
Tile C3=Tile(shift(2,0)*rotate(90)*scale(1/2),chair,blue);
Tile C4=Tile(shift(0,2)*rotate(270)*scale(1/2),chair,blue);

int n=5;
Tile[] Ts={C1,C2,C3,C4};
Tile[] b=subTile(Ts,chair,n);
drawTiling(b);
