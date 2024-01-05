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
int n=6;  

// options
bool drawCPs=true;  // draw critical points in each triangle
bool drawFP=true;  // draw the fixed point of the tiling
bool rotatePatch=true; // rotate the patch by arctan(1/2) each time
bool clipPatch=true;  // clip the patch with a box

// pen settings
pen CP_pen=black+0.05;  // pen for drawing critical points
pen FP_pen=heavymagenta+5;  // pen for drawing the fixed point

// clip settings (rectangle centered at the fixed point)
real boxW=inflation^(max(n-2,0));  // clip box width
real boxL=boxW;  // clip box length 
real boxShiftX=0;  // shift clip box horizontally
real boxShiftY=0;  // shift clip box vertically

// build patch
mosaic M=mosaic(n,pinRule);

// rotate patch
transform R90=rotate(-90);
transform phi=rotate(aTan(-1/2));
transform R=(phi^n)*R90;
if(rotatePatch) M = R*M;

// draw patch
draw(M);  

// build control points
pair CP=(u+2*v+w)/4;  // control point
path CP_dot=shift(CP)*scale(linewidth(CP_pen))*unitcircle;
mrule CP_rule=mrule(CP_dot);
CP_rule.addtile(T,CP_pen);
CP_rule.addtile(T*shift(2,1),CP_pen);
CP_rule.addtile(T*reflect((2,0),(2,1)),CP_pen);
CP_rule.addtile(T*reflect((0,1),(1,1))*shift(2,1),CP_pen);
CP_rule.addtile(T*shift(4,2)*rotate(-90),CP_pen);
mosaic CPs=mosaic(n,CP_rule);
if(rotatePatch) CPs = R*CPs;  

// add critical points to patch
if(drawCPs) draw(CPs, scalelinewidth=false); 

// add fixed point to patch
pair FP=(inflation^n)*CP;
if(rotatePatch) FP=R*FP;
if(drawFP) draw(FP,p=FP_pen); 

// clip the patch
pair boxShift=(boxShiftX,boxShiftY);
pair bottomLeft=(FP.x-boxL/2,FP.y-boxW/2)+boxShift;
pair bottomRight=(FP.x+boxL/2,FP.y-boxW/2)+boxShift;
pair topRight=(FP.x+boxL/2,FP.y+boxW/2)+boxShift;
pair topLeft=(FP.x-boxL/2,FP.y+boxW/2)+boxShift;
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clipPatch) clip(g=box);


