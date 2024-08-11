settings.outformat="pdf";
size(300);

import mosaic;

inflation=(1+sqrt(5))/2; // inflation factor

real a=Sin(18), b=Cos(18), c=Sin(36), d=Cos(36);

pair r1l=(-c,d), r1m=(0,2*d), r1r=(c,d);
pair r2l=(-b,a), r2m=(0,2*a), r2r=(b,a);

tile rhomb1=tile((0,0)--r1r--r1m--r1l--cycle,lightgray,"rhomb1");
tile rhomb2=tile((0,0)--r2r--r2m--r2l--cycle,mediumgray,"rhomb2");

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
filldraw(M);
