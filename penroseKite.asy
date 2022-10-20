settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor
inflation=tau;

real a=Sin(18);
real b=Cos(18);
real c=Tan(54);

path dart=(0,0)--(b,1+a)--(0,1)--(-b,1+a)--cycle;
path kite=(0,0)--(b,b*c)--(0,b*c+a)--(-b,b*c)--cycle;

real A=b*tau;
real B=(1+a)*tau;

// dart substitution
mtile D1=mtile(shift(A,B)*rotate(144),dart,red);
mtile D2=mtile(shift(-A,B)*rotate(-144),dart,red);
mtile D3=mtile(dart,kite,lightyellow);

// kite substitution
mtile K1=mtile(rotate(36),kite,dart,red);
mtile K2=mtile(rotate(-36),kite,dart,red);
mtile K3=mtile(shift(A,A*c)*rotate(108),kite,lightyellow);
mtile K4=mtile(shift(-A,A*c)*rotate(-108),kite,lightyellow);

int n=7;
mosaic M=mosaic(kite,n,D1,D2,D3,K1,K2,K3,K4);
draw(M);
