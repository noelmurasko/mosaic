settings.outformat="pdf";
size(300);

import mosaic;

bool draw_CPs=false;
bool draw_FP=false;

pair u=(2,0); // vertex at the right angle
pair v=(2,1); // terminal vertex of the short leg
pair w=(0,0); // remaining vertex

path triangle=u--v--w--cycle;

inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

// pinwheel substitution tiles
mtile P1=mtile(T);
mtile P2=mtile(T*shift(2,1));
mtile P3=mtile(T*reflect((2,0),(2,1)));
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1));
mtile P5=mtile(T*shift(4,2)*rotate(-90));

mrule pinRule=mrule(P1,P2,P3,P4,P5);  // pinwheel substitution rule

// build patch
int n=6;
mosaic M=mosaic(triangle,n,pinRule);

// reorient patch
transform R90=rotate(-90);
transform phi=rotate(aTan(-1/2));
transform reorient=(phi^n)*R90;
M = reorient*M;

draw(M,p=currentpen+0.25,scalelinewidth=false);  // draw patch

// add decoration 
pair CP=(u+2*v+w)/4;  // control point
path dot=shift(CP)*scale(1/20)*unitcircle;

mtile P1=mtile(T, black);
mtile P2=mtile(T*shift(2,1), black);
mtile P3=mtile(T*reflect((2,0),(2,1)), black);
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1), black);
mtile P5=mtile(T*shift(4,2)*rotate(-90), black);

// overlay decorations
mrule pinRule=mrule(P1,P2,P3,P4,P5);
mosaic CPs=mosaic(dot,n,pinRule);
CPs = reorient*CPs;
if(draw_CPs) draw(CPs);

// label fixed point
CP=reorient*(inflation^n)*CP;
if(draw_FP) draw(CP,p=red+2);  

// define clip box
real tau=(1+sqrt(5))/2;
real boxW=(inflation)^(n-2);
//real boxL=boxW*tau; // golden ratio crop
real boxL=boxW;  // square crop
pair bottomLeft=(CP.x-boxL/2,CP.y-boxW/2);
pair bottomRight=(CP.x+boxL/2,CP.y-boxW/2);
pair topRight=(CP.x+boxL/2,CP.y+boxW/2);
pair topLeft=(CP.x-boxL/2,CP.y+boxW/2);


// clip the patch
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
clip(g=box);

