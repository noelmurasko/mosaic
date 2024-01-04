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

// rhomb1 substitution tiles
mtile R1=mtile(shift(0,2*d)*rotate(180),rhomb1,lightyellow);
mtile R2=mtile(shift(-c,d)*rotate(216),rhomb1,lightyellow);
mtile R3=mtile(shift(c,d)*rotate(144),rhomb1,lightyellow);
mtile R4=mtile(shift(-c,d)*rotate(-36),rhomb2,heavyblue);
mtile R5=mtile(shift(c,d)*rotate(36),rhomb2,heavyblue);

mrule rhomb1Rule=mrule(rhomb1,R1,R2,R3,R4,R5);  // rhomb1 substitution rule

// rhomb2 substitution tiles
mtile S1=mtile(shift(0,2*a)*rotate(108),rhomb2,heavyblue);
mtile S2=mtile(shift(0,2*a)*rotate(-108),rhomb2,heavyblue);
mtile S3=mtile(shift(-b,a)*rotate(-108),rhomb1,lightyellow);
mtile S4=mtile(shift(b,a)*rotate(108),rhomb1,lightyellow);

mrule rhomb2Rule=mrule(rhomb2,S1,S2,S3,S4);  // rhomb2 substitution rule

int n=6;
mosaic M=mosaic(rhomb1,n,rhomb1Rule,rhomb2Rule);
draw(M);
