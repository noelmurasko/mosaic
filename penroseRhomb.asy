settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;		// inflation factor

real a=Sin(18);
real b=Cos(18);
real c=Sin(36);
real d=Cos(36);

path rhomb1=(0,0)--(c,d)--(0,2*d)--(-c,d)--cycle;
path rhomb2=(0,0)--(b,a)--(0,2*a)--(-b,a)--cycle;

// rhomb1 substitution
mtile R1=mtile(shift(0,2*d)*rotate(180)*scale(1/tau),rhomb1,lightyellow);
mtile R2=mtile(shift(-c,d)*rotate(216)*scale(1/tau),rhomb1,lightyellow);
mtile R3=mtile(shift(c,d)*rotate(144)*scale(1/tau),rhomb1,lightyellow);
mtile R4=mtile(shift(-c,d)*rotate(-36)*scale(1/tau),rhomb1,rhomb2,heavyblue);
mtile R5=mtile(shift(c,d)*rotate(36)*scale(1/tau),rhomb1,rhomb2,heavyblue);

// rhomb2 substitution
mtile S1=mtile(shift(0,2*a)*rotate(108)*scale(1/tau),rhomb2,heavyblue);
mtile S2=mtile(shift(0,2*a)*rotate(-108)*scale(1/tau),rhomb2,heavyblue);
mtile S3=mtile(shift(-b,a)*rotate(-108)*scale(1/tau),rhomb2,rhomb1,lightyellow);
mtile S4=mtile(shift(b,a)*rotate(108)*scale(1/tau),rhomb2,rhomb1,lightyellow);


mtile[] rhombRule={R1,R2,R3,R4,R5,S1,S2,S3,S4};

int nmax=7;
mtile[] rhomb=substitute(rhombRule,rhomb2,nmax);
draw(rhomb);