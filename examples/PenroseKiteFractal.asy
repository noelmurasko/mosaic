settings.outformat="pdf";
size(300);

import mosaic;

real tau=(1+sqrt(5))/2;
real a=Sin(18), b=Cos(18), c=Tan(54);

pair kl=(-b,b*c), km=(0,b*c+a), kr=(b,b*c);
pair dl=(-b,1+a), dm=(0,1), dr=(b,1+a);

tile kite=tile((0,0)--kr--km--kl--cycle);
tile dart=tile((0,0)--dr--dm--dl--cycle);

real A=b*tau;
real B=(1+a)*tau;

// kite substitution
substitution kiteRule=substitution(kite);
transform t1=scale(1/tau)*rotate(36);
transform t2=scale(1/tau)*shift(A,A*c)*rotate(108);
transform t3=scale(1/tau)*shift(-A,A*c)*rotate(-108);
kiteRule.addtile(t1,dart);
kiteRule.addtile(t2,kite);
kiteRule.addtile(t3,kite);

// dart substitution
substitution dartRule=substitution(dart);
transform t4=scale(1/tau)*shift(A,B)*rotate(144);
transform t5=scale(1/tau);
dartRule.addtile(t4,dart);
dartRule.addtile(t5,kite);

int n=10;
mosaic kiteM=mosaic(n,kiteRule,dartRule);  // kite fractal
mosaic dartM=mosaic(n,dartRule,kiteRule);  // dart fractal

real h=1;
fill(shift(-h)*t1*dartM, p=red);
fill(shift(-h)*t2*kiteM, p=blue);
fill(shift(-h)*t3*kiteM, p=lightolive);
fill(shift(h)*t4*dartM, p=red);
fill(shift(h)*t5*kiteM, p=lightolive);


