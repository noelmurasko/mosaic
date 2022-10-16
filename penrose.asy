settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Tan(54);
real d=Sin(36);
real e=Cos(36);

path dart=(0,0)--(b,1+a)--(0,1)--(-b,1+a)--cycle;
path kite=(0,0)--(b,b*c)--(0,b*c+a)--(-b,b*c)--cycle;

path rhomb1=(0,0)--(d,e)--(0,2*e)--(-d,e)--cycle;
path rhomb2=(0,0)--(b,a)--(0,2*a)--(-b,a)--cycle;


// dart substitution
Tile D1=Tile(shift(b,1+a)*rotate(144)*scale(1/tau),dart,red);
Tile D2=Tile(shift(-b,1+a)*rotate(-144)*scale(1/tau),dart,red);
Tile D3=Tile(scale(1/tau),dart,kite,lightyellow);

// kite substitution
Tile K1=Tile(rotate(36)*scale(1/tau),kite,dart,red);
Tile K2=Tile(rotate(-36)*scale(1/tau),kite,dart,red);
Tile K3=Tile(shift(b,b*c)*rotate(108)*scale(1/tau),kite,lightyellow);
Tile K4=Tile(shift(-b,b*c)*rotate(-108)*scale(1/tau),kite,lightyellow);

// rhomb1 substitution
//Tile R1=Tile(shift(0,1/tau)*scale(1/tau),rhomb1,lightyellow);
//Tile R2=Tile(rotate(36)*scale(1/tau),rhomb1,lightyellow);
//Tile R3=Tile(rotate(-36)*scale(1/tau),rhomb1,lightyellow);
//Tile R4=Tile(shift(-d,e)*rotate(-36)*scale(1/tau),rhomb1,rhomb2,heavyblue);
//Tile R5=Tile(shift(d,e)*rotate(36)*scale(1/tau),rhomb1,rhomb2,heavyblue);
Tile R1=Tile(scale(1/tau),rhomb1,lightyellow);
Tile R2=Tile(shift(0,1/tau*(1+2*e))*rotate(144)*scale(1/tau),rhomb1,lightyellow);
Tile R3=Tile(shift(0,1/tau*(1+2*e))*rotate(-144)*scale(1/tau),rhomb1,lightyellow);
Tile R4=Tile(shift(-d,e)*rotate(-144)*scale(1/tau),rhomb1,rhomb2,heavyblue);
Tile R5=Tile(shift(d,e)*rotate(144)*scale(1/tau),rhomb1,rhomb2,heavyblue);

// rhomb2 substitution
Tile S1=Tile(shift(0,2*a)*rotate(108)*scale(1/tau),rhomb2,heavyblue);
Tile S2=Tile(shift(0,2*a)*rotate(-108)*scale(1/tau),rhomb2,heavyblue);
Tile S3=Tile(rotate(144)*scale(1/tau),rhomb2,rhomb1,lightyellow);
Tile S4=Tile(rotate(-144)*scale(1/tau),rhomb2,rhomb1,lightyellow);

Tile[] kiteDartRule={D1,D2,D3,K1,K2,K3,K4};
Tile[] rhombRule={R1,R2,R3,R4,R5,S1,S2,S3,S4};


int nmax=2;
Tile[] kiteDart=subTile(kiteDartRule,kite,nmax);
Tile[] rhomb=subTile(rhombRule,rhomb1,nmax);

//drawTiling(kiteDart);
drawTiling(rhomb);









