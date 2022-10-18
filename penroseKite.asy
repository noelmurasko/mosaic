settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Tan(54);

path dart=(0,0)--(b,1+a)--(0,1)--(-b,1+a)--cycle;
path kite=(0,0)--(b,b*c)--(0,b*c+a)--(-b,b*c)--cycle;


// dart substitution
Tile D1=Tile(shift(b,1+a)*rotate(144)*scale(1/tau),dart,red);
Tile D2=Tile(shift(-b,1+a)*rotate(-144)*scale(1/tau),dart,red);
Tile D3=Tile(scale(1/tau),dart,kite,lightyellow);

// kite substitution
Tile K1=Tile(rotate(36)*scale(1/tau),kite,dart,red);
Tile K2=Tile(rotate(-36)*scale(1/tau),kite,dart,red);
Tile K3=Tile(shift(b,b*c)*rotate(108)*scale(1/tau),kite,lightyellow);
Tile K4=Tile(shift(-b,b*c)*rotate(-108)*scale(1/tau),kite,lightyellow);

Tile[] kiteDartRule={D1,D2,D3,K1,K2,K3,K4};

int nmax=3;
Tile[] kiteDart=subTile(kiteDartRule,kite,nmax);
drawTiling(kiteDart);
