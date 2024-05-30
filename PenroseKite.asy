settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;   // inflation factor
inflation=tau;

real a=Sin(18);
real b=Cos(18);
real c=Tan(54);

pair kl=(-b,b*c), km=(0,b*c+a), kr=(b,b*c);
pair dl=(-b,1+a), dm=(0,1), dr=(b,1+a);

tile kite=tile((0,0)--kr--km--kl--cycle,lightgrey);
tile dart=tile((0,0)--dr--dm--dl--cycle,mediumgrey);

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
