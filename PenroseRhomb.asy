settings.outformat="pdf";
size(300);

import mosaic;

inflation=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Sin(36);
real d=Cos(36);

tile rhomb1=tile((0,0)--(c,d)--(0,2*d)--(-c,d)--cycle,lightyellow);
tile rhomb2=tile((0,0)--(b,a)--(0,2*a)--(-b,a)--cycle,heavyblue);

a*=inflation; b*=inflation; c*=inflation; d*=inflation;

substitution rhomb1Rule=substitution(rhomb1);  // rhomb1 substitution rule

rhomb1Rule.addtile(shift(0,2*d)*rotate(180),rhomb1);
rhomb1Rule.addtile(shift(-c,d)*rotate(216),rhomb1);
rhomb1Rule.addtile(shift(c,d)*rotate(144),rhomb1);
rhomb1Rule.addtile(shift(-c,d)*rotate(-36),rhomb2);
rhomb1Rule.addtile(shift(c,d)*rotate(36),rhomb2);

substitution rhomb2Rule=substitution(rhomb2);  // rhomb2 substitution rule

rhomb2Rule.addtile(shift(0,2*a)*rotate(108),rhomb2);
rhomb2Rule.addtile(shift(0,2*a)*rotate(-108),rhomb2);
rhomb2Rule.addtile(shift(-b,a)*rotate(-108),rhomb1);
rhomb2Rule.addtile(shift(b,a)*rotate(108),rhomb1);

int n=4;
mosaic M=mosaic(rhomb1,n,rhomb1Rule,rhomb2Rule);
pair dot=(0,1/2);
M.addlayer(dot,black+10);
filldraw(M);
