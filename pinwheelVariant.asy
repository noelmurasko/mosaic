settings.outformat="pdf";
size(300);

import mosaic;

// pinwheel triangle
pair u=(2,0);
pair v=(2,1);
pair w=(0,0);
path tri=u--v--w--cycle;

// inflation factor
inflation=sqrt(5);

// number of iterations
int n=6;

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

// create the patch
mosaic M=mosaic(tri,n,pinSub);

// draw the patch
draw(M);
