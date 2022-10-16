settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Sin(36);
real d=Cos(36);

path rhomb1=(0,0)--(c,d)--(0,2*d)--(-c,d)--cycle;
path rhomb2=(0,0)--(b,a)--(0,2*a)--(-b,a)--cycle;

// rhomb1 substitution
Tile R1=Tile(shift(0,2*d)*rotate(180)*scale(1/tau),rhomb1,lightyellow);
Tile R2=Tile(shift(-c,d)*rotate(216)*scale(1/tau),rhomb1,lightyellow);
Tile R3=Tile(shift(c,d)*rotate(144)*scale(1/tau),rhomb1,lightyellow);
Tile R4=Tile(shift(-c,d)*rotate(-36)*scale(1/tau),rhomb1,rhomb2,heavyblue);
Tile R5=Tile(shift(c,d)*rotate(36)*scale(1/tau),rhomb1,rhomb2,heavyblue);

// rhomb2 substitution
Tile S1=Tile(shift(0,2*a)*rotate(108)*scale(1/tau),rhomb2,heavyblue);
Tile S2=Tile(shift(0,2*a)*rotate(-108)*scale(1/tau),rhomb2,heavyblue);
Tile S3=Tile(shift(-b,a)*rotate(-108)*scale(1/tau),rhomb2,rhomb1,lightyellow);
Tile S4=Tile(shift(b,a)*rotate(108)*scale(1/tau),rhomb2,rhomb1,lightyellow);


Tile[] rhombRule={R1,R2,R3,R4,R5,S1,S2,S3,S4};

int nmax=7;
Tile[] rhomb=subTile(rhombRule,rhomb2,nmax);
drawTiling(rhomb);
