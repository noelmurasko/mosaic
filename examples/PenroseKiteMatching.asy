settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2; // inflation factor
inflation=tau;

real a=Sin(18), b=Cos(18), c=Tan(54);

pair kl=(-b,b*c), km=(0,b*c+a), kr=(b,b*c);
pair dl=(-b,1+a), dm=(0,1), dr=(b,1+a);

tile kite=tile((0,0)--kr--km--kl--cycle,lightgrey,"kite");
tile dart=tile((0,0)--dr--dm--dl--cycle,mediumgrey,"dart");

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

int n=6;
mosaic M=mosaic(n,dartRule,kiteRule);
//filldraw(M);

path[] matchingrule(real radlower, pair l, pair m, pair r) {
  pair rlower=radlower*r/abs(r);
  pair mlower=(0,radlower);
  pair llower=radlower*l/abs(l);
  path pathlower=rlower..mlower..llower;

  real radupper=m.y-radlower;
  pair rupper=radupper*(r-m)/abs(r-m)+m;
  pair mupper=m-(0,radupper);
  pair lupper=radupper*(l-m)/abs(l-m)+m;
  path pathupper=rupper..mupper..lupper;

  return new path[] {pathlower, pathupper};
}

real krad=1;
path[] kitematching=matchingrule(krad,kl,km,kr);

real drad=abs(kr)-krad;
path[] dartmatching=matchingrule(drad,dl,dm,dr);


M.addlayer();
M.updatelayer(kitematching[0],"kite");
M.updatelayer(dartmatching[0],"dart");

M.addlayer();
M.updatelayer(kitematching[1],"kite");
M.updatelayer(dartmatching[1],"dart");

draw(M,blue+1.5,layer=1);
draw(M,red+1.5,layer=2);
