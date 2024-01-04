settings.outformat="pdf";
size(300);

import mosaic;

// prototile
pair u=(2,0); 
pair v=(2,1); 
pair w=(0,0); 
path triangle=u--v--w--cycle;

// inflation factor
inflation=sqrt(5);  

// substitution rule
transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));
mtile P1=mtile(T);
mtile P2=mtile(T*shift(2,1));
mtile P3=mtile(T*reflect((2,0),(2,1)));
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1));
mtile P5=mtile(T*shift(4,2)*rotate(-90));
mrule pinRule=mrule(P1,P2,P3,P4,P5);  

// number of iterations
int n=4;  

// options
bool draw_CPs=true;  // draw critical points in each triangle
bool rotate_patch=true; // rotate the patch by arctan(1/2)
bool draw_FP=true;  // draw the fixed point of the tiling
bool clip_patch=false;  // clip the patch 

// clip settings (rectangle)
real boxW=(inflation)^(n-2);  // clip width
real boxL=boxW;  // clip length 

// build patch
mosaic M=mosaic(triangle,n,pinRule);

// reorient patch
transform R90=rotate(-90);
transform phi=rotate(aTan(-1/2));
transform R=(phi^n)*R90;
if(rotate_patch) M = R*M;

// draw patch
draw(M,p=currentpen+0.25,scalelinewidth=false);  

// build control points
pair CP=(u+2*v+w)/4;  // control point
path CP_dot=shift(CP)*scale(1/20)*unitcircle;
mtile P1=mtile(T, black);
mtile P2=mtile(T*shift(2,1), black);
mtile P3=mtile(T*reflect((2,0),(2,1)), black);
mtile P4=mtile(T*reflect((0,1),(1,1))*shift(2,1), black);
mtile P5=mtile(T*shift(4,2)*rotate(-90), black);

// add critical points to patch
mrule pinRule=mrule(P1,P2,P3,P4,P5);
mosaic CPs=mosaic(CP_dot,n,pinRule);
if(rotate_patch) CPs = R*CPs;
if(draw_CPs) draw(CPs);  // set scalelinewidth=false for unscaled dots

// add fixed point to patch
pair FP=(inflation^n)*CP;
if(rotate_patch) FP=R*FP;
real dotscale=(1/20)*2+0.5/(inflation^(n-1));
if(draw_FP) draw(FP,p=red+dotscale);  

// clip the patch
pair bottomLeft=(CP.x-boxL/2,CP.y-boxW/2);
pair bottomRight=(CP.x+boxL/2,CP.y-boxW/2);
pair topRight=(CP.x+boxL/2,CP.y+boxW/2);
pair topLeft=(CP.x-boxL/2,CP.y+boxW/2);
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clip_patch) clip(g=box);

