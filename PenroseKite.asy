settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor
inflation=tau;

real a=Sin(18);
real b=Cos(18);
real c=Tan(54);

tile dart=tile((0,0)--(b,1+a)--(0,1)--(-b,1+a)--cycle,red);
tile dart2=tile((0,0)--(b,1+a)--(0,1)--(-b,1+a)--cycle,green);
tile kite=tile((0,0)--(b,b*c)--(0,b*c+a)--(-b,b*c)--cycle,lightyellow);

real A=b*tau;
real B=(1+a)*tau;

substitution dartRule=substitution(dart); // dart substitution rule

dartRule.addtile(shift(A,B)*rotate(144), dart);
dartRule.addtile(shift(-A,B)*rotate(-144),dart);
dartRule.addtile(kite);

substitution kiteRule=substitution(kite); // kite substitution rule

kiteRule.addtile(rotate(36),dart);
kiteRule.addtile(rotate(-36),dart);
kiteRule.addtile(shift(A,A*c)*rotate(108),kite);
kiteRule.addtile(shift(-A,A*c)*rotate(-108),kite);

int n=4;
mosaic M=mosaic(kite,n,dartRule,kiteRule);

filldraw(M);
