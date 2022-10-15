settings.outformat="pdf";
size(300);

import mosaic;

path square=box((0,0),(1,1));

Tile S1=Tile(scale(1/2),square,white);
Tile S2=Tile(shift(1/2,0)*scale(1/2),square,red);
Tile S3=Tile(shift(1/2,1/2)*scale(1/2),square,white);
Tile S4=Tile(shift(0,1/2)*scale(1/2),square,red);

int n=5;
Tile[] Ts={S1,S2,S3,S4};
Tile[] b=subTile(Ts,square,n);
drawTiling(b);
