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

path[] matchingrule(real radlower, real radupper, pair l, pair m, pair r) {

  pair rlower=radlower*r/abs(r);
  pair mlower=(0,radlower);
  pair llower=radlower*l/abs(l);
  path pathlower=rlower..mlower..llower;

  pair rupper=radupper*(r-m)/abs(r-m)+m;
  pair mupper=m-(0,radupper);
  pair lupper=radupper*(l-m)/abs(l-m)+m;
  path pathupper=rupper..mupper..lupper;

  return new path[] {pathlower, pathupper};
}

real r1radlower=1/4;
real r1radupper=abs(r2m-r2r)-r1radlower;
path[] rhomb1matching=matchingrule(r1radlower,r1radupper,r1l,r1m,r1r);

real r2radlower=r1radlower;
real r2radupper=r1radlower;
path[] rhomb2matching=matchingrule(r2radlower,r2radupper,r2l,r2m,r2r);

M.addlayer();
M.updatelayer(rhomb1matching[0],"rhomb1");
M.updatelayer(rhomb2matching[0],"rhomb2");

M.addlayer();
M.updatelayer(rhomb1matching[1],"rhomb1");
M.updatelayer(rhomb2matching[1],"rhomb2");

draw(M,blue+1.5,layer=1);
draw(M,red+1.5,layer=2);
