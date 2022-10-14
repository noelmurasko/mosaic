settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;
import gargoyle;


//Tile protoTile=Tile(box((0,0),(1,1)),colours);
/*
path s=box((0,0),(1,1));
transform T1=scale(1/2);
transform T2=shift(1/2,0)*T1;
transform T3=shift(1/2,1/2)*T1;
transform T4=shift(0,1/2)*T1;

int nmax=3;
int n=0;
transform[] T={T1,T2,T3,T4};
transform[] subTiling={};
loop(s,identity,T,n,nmax);

path c=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

Tile T1=Tile(scale(1/2),c);
Tile T2=Tile(shift(1/2,1/2)*scale(1/2),c);
Tile T3=Tile(shift(2,0)*rotate(90)*scale(1/2),c);
Tile T4=Tile(shift(0,2)*rotate(270)*scale(1/2),c);

int n=2;
Tile[] Ts={T1,T2,T3,T4};

Tiling T=Tiling(Ts);
transform[] subTiling={};

loop(T,Tile(identity,c),0,n);
*/

path chair=(0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle;
path rect=(0,0)--(3,0)--(3,1)--(0,1)--cycle;

// chair transforms
Tile C1=Tile(shift(1,1)*rotate(180)*scale(1/2),chair,chair,yellow);
Tile C2=Tile(shift(1,1/2)*scale(1/2),chair,chair,yellow);
Tile C3=Tile(shift(1,1)*shift(1,1)*rotate(180)*scale(1/2),chair,chair,yellow);
Tile C4=Tile(shift(2,0)*scale(1/2),rect,chair,yellow);
Tile C5=Tile(shift(1,1)*rotate(180)*scale(1/2),rect,chair,yellow);

// rectangle transforms
Tile R1=Tile(shift(1/2,0)*scale(1/2),chair,rect,red);
Tile R2=Tile(shift(1/2,0)*scale(1/2),rect,rect,red);
Tile R3=Tile(shift(1/2,1/2)*shift(1/2,0)*scale(1/2),rect,rect,red);

int n=5;
Tile[] Ts={C1,C2,C3,C4,C5,R1,R2,R3};
loop(Ts,Tile(identity,chair,chair),0,n);
