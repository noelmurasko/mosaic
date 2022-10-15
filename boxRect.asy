settings.outformat="pdf";
size(300);

import mosaic;

path square=box((0,0),(1,1));
path rect=box((0,0),(2,1));

// square transforms
Tile S1=Tile(shift(0,1/2)*scale(1/2),square,red);
Tile S2=Tile(shift(1/2,1/2)*scale(1/2),square,orange);
Tile S3=Tile(scale(1/2),square,rect,yellow);

// rectangle transforms
Tile R1=Tile(shift(1/2,1/2)*scale(1/2),rect,square,red);
Tile R2=Tile(shift(3/2,0)*scale(1/2),rect,square,orange);
Tile R3=Tile(shift(1/2,0)*rotate(90)*scale(1/2),rect,yellow);
Tile R4=Tile(shift(1/2,0)*scale(1/2),rect,green);
Tile R5=Tile(shift(1,1/2)*scale(1/2),rect,blue);


int nmax=3;
Tile[] Ts={S1,S2,S3,R1,R2,R3,R4,R5};
Tile[] b=subTile(Ts,rect,nmax);
drawTiling(b);
