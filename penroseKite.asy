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

substitution dartRule=substitution(dart); // dart substitution rule

dartRule.addtile(shift(A,B)*rotate(144),dart,red);
dartRule.addtile(shift(-A,B)*rotate(-144),dart,red);
dartRule.addtile(kite,lightyellow);

substitution kiteRule=substitution(kite); // kite substitution rule

kiteRule.addtile(rotate(36),dart,red);
kiteRule.addtile(rotate(-36),dart,red);
kiteRule.addtile(shift(A,A*c)*rotate(108),kite,lightyellow);
kiteRule.addtile(shift(-A,A*c)*rotate(-108),kite,lightyellow);

int n=3;
mosaic M=mosaic(dart,n,dartRule,kiteRule);

draw(M);
