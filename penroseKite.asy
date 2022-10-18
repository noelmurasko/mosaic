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
mtile D1=mtile(shift(b,1+a)*rotate(144)*scale(1/tau),dart,red);
mtile D2=mtile(shift(-b,1+a)*rotate(-144)*scale(1/tau),dart,red);
mtile D3=mtile(scale(1/tau),dart,kite,lightyellow);

// kite substitution
mtile K1=mtile(rotate(36)*scale(1/tau),kite,dart,red);
mtile K2=mtile(rotate(-36)*scale(1/tau),kite,dart,red);
mtile K3=mtile(shift(b,b*c)*rotate(108)*scale(1/tau),kite,lightyellow);
mtile K4=mtile(shift(-b,b*c)*rotate(-108)*scale(1/tau),kite,lightyellow);

mtile[] kiteDartRule={D1,D2,D3,K1,K2,K3,K4};

int nmax=3;
mtile[] kiteDart=substitute(kiteDartRule,kite,nmax);
draw(kiteDart);
