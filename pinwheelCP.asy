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
mrule pinRule=mrule(triangle);
pinRule.addtile(T);
pinRule.addtile(T*shift(2,1));
pinRule.addtile(T*reflect((2,0),(2,1)));
pinRule.addtile(T*reflect((0,1),(1,1))*shift(2,1));
pinRule.addtile(T*shift(4,2)*rotate(-90));

// number of iterations
int n=3;  

// options
bool draw_CPs=true;  // draw critical points in each triangle
bool rotate_patch=true; // rotate the patch by arctan(1/2) each time
bool draw_FP=true;  // draw the fixed point of the tiling
bool clip_patch=true;  // clip the patch with a box

// clip settings (rectangle)
real boxW=(inflation)^(max(n,2)-2);  // clip width
real boxL=boxW;  // clip length 

// build patch
mosaic M=mosaic(n,pinRule);

// rotate patch
transform R90=rotate(-90);
transform phi=rotate(aTan(-1/2));
transform R=(phi^n)*R90;
if(rotate_patch) M = R*M;

// draw patch
draw(M);  

// build control points
pair CP=(u+2*v+w)/4;  // control point
path CP_dot=shift(CP)*scale(1/20)*unitcircle;
mrule CPRule=mrule(CP_dot);
CPRule.addtile(T,black);
CPRule.addtile(T*shift(2,1),black);
CPRule.addtile(T*reflect((2,0),(2,1)),black);
CPRule.addtile(T*reflect((0,1),(1,1))*shift(2,1),black);
CPRule.addtile(T*shift(4,2)*rotate(-90),black);
mosaic CPs=mosaic(n,CPRule);
if(rotate_patch) CPs = R*CPs;  

// add critical points to patch
if(draw_CPs) draw(CPs);  // set scalelinewidth=false for unscaled dots

// add fixed point to patch
pair FP=(inflation^n)*CP;
if(rotate_patch) FP=R*FP;
real dotscale=20*linewidth(currentpen)/inflation^(n-1);
if(draw_FP) draw(FP,p=magenta+dotscale);  

// clip the patch
pair bottomLeft=(CP.x-boxL/2,CP.y-boxW/2);
pair bottomRight=(CP.x+boxL/2,CP.y-boxW/2);
pair topRight=(CP.x+boxL/2,CP.y+boxW/2);
pair topLeft=(CP.x-boxL/2,CP.y+boxW/2);
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clip_patch) clip(g=box);

write(bottomLeft);
write(bottomRight);
write(topRight);
write(topLeft);

