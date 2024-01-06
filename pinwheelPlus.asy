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

// options
bool drawTiles=true;  // draw the tiles
bool drawCPs=false;  // draw critical points in each triangle
bool drawFP=false;  // draw the fixed point of the tiling
bool rotatePatch=true; // rotate the patch by arctan(1/2) each iteration
bool reorientPatch=true;  // rotate the final patch by 90 degrees
bool overlaySupertiles=true;  // overlay supertiles 
bool clipPatch=false;  // clip the patch with a box

// dot size/colour settings
pen CP_pen=black+5;  // critical points
pen FP_pen=heavymagenta+4;  // fixed point

// supertile settings
int k=1;  // overlay level n-k supertiles
pen overlayLine=black+2;

// clip settings (rectangle centered at the fixed point)
real boxW=inflation^(max(n-2,0));  // clip box width
real boxL=boxW;  // clip box length
real boxShiftX=0;  // shift clip box horizontally
real boxShiftY=0;  // shift clip box vertically

// initialize a substitution rule 
substitution pinSub=substitution(tri);

// define the substitution rule 
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, paleyellow, id="1");
pinSub.addtile(T*shift(2,1), paleyellow, id="2");  
pinSub.addtile(T*reflect((2,0),(2,1)), paleblue, id="3");  
pinSub.addtile(T*reflect((0,1),(1,1))*shift(2,1), paleblue, id="4");  
pinSub.addtile(T*shift(4,2)*rotate(-90), paleyellow, id="5");  

// build patch
mosaic M=mosaic(n,pinSub);

// rotate/reorient patch
transform RotVarphi=rotate(-varphi)^n;
transform Rot90=rotate(-90);
if(rotatePatch) M=RotVarphi*M;
if(reorientPatch) M=Rot90*M;

// draw patch
if(drawTiles) draw(M);

// draw control points
pair CP=(u+2*v+w)/4;
M.set(CP);
if(drawCPs) draw(M, CP_pen);


// draw fixed point
pair FP=(inflation^n)*CP;
if(rotatePatch) FP=RotVarphi*FP;
if(reorientPatch) FP=Rot90*FP;
if(drawFP) draw(FP, p=FP_pen);

// overlay level n-k supertiles
mosaic superM=mosaic(max(n-k,0),pinSub);
superM.set(invisible);
superM=scale(inflation^k)*superM;
if(rotatePatch) superM=RotVarphi*superM;
if(reorientPatch) superM=Rot90*superM;
if(overlaySupertiles && n>=k) draw(superM,p=overlayLine);
	
	
// clip the patch
pair boxShift=(boxShiftX,boxShiftY);
pair bottomLeft=(FP.x-boxL/2,FP.y-boxW/2)+boxShift;
pair bottomRight=(FP.x+boxL/2,FP.y-boxW/2)+boxShift;
pair topRight=(FP.x+boxL/2,FP.y+boxW/2)+boxShift;
pair topLeft=(FP.x-boxL/2,FP.y+boxW/2)+boxShift;
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clipPatch) clip(g=box);

