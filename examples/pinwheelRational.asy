settings.outformat="pdf";
size(300);

import mosaic;

// pinwheel triangle
tile tri=(0,0)--(2,0)--(2,1)--cycle;

// inflation factor
currentinflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

// pinwheel substitution tiles
substitution pinSub=substitution(tri);

// define the substitution rule
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, paleyellow);
pinSub.addtile(T*shift(2,1), paleyellow);
pinSub.addtile(shift(2*Cos(varphi),2*Sin(varphi))*rotate(180)*shift(-sqrt(5),0)*T, lightred);  // different from pinwheel
pinSub.addtile(shift(2*Cos(varphi),2*Sin(varphi))*T, paleblue);  // different from pinwheel
pinSub.addtile(T*shift(4,2)*rotate(-90), heavyred);

// number of iterations
int n=1;
mosaic M=mosaic(n,pinSub);

// draw the patch
filldraw(M);
