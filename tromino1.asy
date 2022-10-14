settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

path chair=(0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle;
path rect=(0,0)--(3,0)--(3,1)--(0,1)--cycle;

// chair transforms
Tile C1=Tile(shift(1,1)*rotate(180)*scale(1/2),chair,yellow);
Tile C2=Tile(shift(1,1/2)*scale(1/2),chair,yellow);
Tile C3=Tile(shift(1,1)*shift(1,1)*rotate(180)*scale(1/2),chair,yellow);
Tile C4=Tile(shift(2,0)*scale(1/2),rect,chair,yellow);
Tile C5=Tile(shift(1,1)*rotate(180)*scale(1/2),rect,chair,yellow);

// rectangle transforms
Tile R1=Tile(shift(1/2,0)*scale(1/2),chair,rect,red);
Tile R2=Tile(shift(1/2,0)*scale(1/2),rect,red);
Tile R3=Tile(shift(1/2,1/2)*shift(1/2,0)*scale(1/2),rect,red);

int nmax=5;
Tile[] Ts={C1,C2,C3,C4,C5,R1,R2,R3};
subTile(Ts,chair,nmax);
