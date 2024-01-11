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
int n=4;

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

// pinwheel substitution tiles
substitution pinSub=substitution(tri);

// define the substitution rule
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, paleyellow);
pinSub.addtile(T*shift(2,1), paleyellow);
pinSub.addtile(T*reflect((2,0),(2,1)), lightred);
pinSub.addtile(T*reflect((0,1),(1,1))*shift(2,1), paleblue);
pinSub.addtile(T*shift(4,2)*rotate(-90), heavyred);

// create the patch
mosaic M=mosaic(tri,n,pinSub);

// draw the patch
draw(M);
