settings.outformat="pdf";
size(300);

import mosaic;

pair u=(2,0); // vertex at the right angle
pair v=(2,1); // terminal vertex of the short leg
pair w=(0,0); // remaining vertex

path triangle=(0,0)--(2,0)--(2,1)--cycle;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
//transform reorient=rotate(-90-aTan(1/2));

// pinwheel substitution tiles
mtile P1=mtile(T);
mtile P2=mtile(T*shift(2,1));
mtile P3=mtile(T*reflect((2,0),(2,1)));
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1));
mtile P5=mtile(T*shift(4,2)*rotate(-90));

mrule pinRule=mrule(P1,P2,P3,P4,P5);  // pinwheel substitution rule

// draw patch
int n=5;
mosaic M=mosaic(triangle,n,pinRule);
//M = reorient*M;
draw(M);

// decoration ===

pair CP=(u+2*v+w)/4;  // control point
path[] dot=shift(CP)*scale(1/20)*unitcircle;

mtile P1=mtile(T, black);
mtile P2=mtile(T*shift(2,1), black);
mtile P3=mtile(T*reflect((2,0),(2,1)), black);
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1), black);
mtile P5=mtile(T*shift(4,2)*rotate(-90), black);

// overlay decorations
mrule pinRule=mrule(P1,P2,P3,P4,P5);
mosaic CPs=mosaic(dot,n,pinRule);
//CPs = reorient*CPs;
draw(CPs);
