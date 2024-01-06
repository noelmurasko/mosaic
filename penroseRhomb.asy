settings.outformat="pdf";
size(300);

import mosaic;

inflation=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Sin(36);
real d=Cos(36);

path rhomb1=(0,0)--(c,d)--(0,2*d)--(-c,d)--cycle;
path rhomb2=(0,0)--(b,a)--(0,2*a)--(-b,a)--cycle;

a*=inflation; b*=inflation; c*=inflation; d*=inflation;

substitution rhomb1Rule=substitution(rhomb1);  // rhomb1 substitution rule

rhomb1Rule.addtile(shift(0,2*d)*rotate(180),rhomb1,lightyellow);
rhomb1Rule.addtile(shift(-c,d)*rotate(216),rhomb1,lightyellow);
rhomb1Rule.addtile(shift(c,d)*rotate(144),rhomb1,lightyellow);
rhomb1Rule.addtile(shift(-c,d)*rotate(-36),rhomb2,heavyblue);
rhomb1Rule.addtile(shift(c,d)*rotate(36),rhomb2,heavyblue);

substitution rhomb2Rule=substitution(rhomb2);  // rhomb2 substitution rule

rhomb2Rule.addtile(shift(0,2*a)*rotate(108),rhomb2,heavyblue);
rhomb2Rule.addtile(shift(0,2*a)*rotate(-108),rhomb2,heavyblue);
rhomb2Rule.addtile(shift(-b,a)*rotate(-108),rhomb1,lightyellow);
rhomb2Rule.addtile(shift(b,a)*rotate(108),rhomb1,lightyellow);

int n=1;
mosaic M=mosaic(rhomb1,n,rhomb1Rule,rhomb2Rule);
draw(M);
