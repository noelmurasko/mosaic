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
int n=2;

// options
bool drawTiles=true;  // draw the tiles
bool drawCPs=true;  // (TODO) draw critical points in each triangle
bool drawFP=true;  // draw the fixed point of the tiling
bool colourTiles=true;  // colour tiles by chirality
bool colourBorders=false;  // (TODO) colour tile borders by chirality
bool colourCPs=true;  // colour critical points by chirality
bool rotatePatch=true; // rotate the patch by arctan(1/2) each iteration
bool reorientPatch=true;  // rotate the final patch by 90 degrees
bool overlaySupertiles=true;  // overlay supertile borders
bool colourSupertiles=false;  // (TODO) colour supertile borders by chirality
bool clipPatch=false;  // clip the patch with a box

// dot size/colour settings
pen tilePen=green+2;  // tile borders
pen posTiles=paleblue;  // tiles of positive chirality
pen negTiles=paleyellow;  // tiles of negative chirality
pen CP_pen=black+5;  // critical points when colourCPs=false
pen posCP_pen=blue+5;  // critical points of positive chirality
pen negCP_pen=orange+5;  // critical points of negative chirality
pen FP_pen=heavymagenta+6;  // fixed point

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

// set tile colours
pen[] tileColours;
if(colourTiles) {
	tileColours[0]=posTiles;
	tileColours[1]=negTiles;
}else{
	tileColours=array(2,invisible);
}

// define the substitution rule
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, tileColours[1], id="1");
pinSub.addtile(T*shift(2,1), tileColours[1], id="2");
pinSub.addtile(T*reflect((2,0),(2,1)), tileColours[0], id="3");
pinSub.addtile(T*reflect((0,1),(1,1))*shift(2,1), tileColours[0], id="4");
pinSub.addtile(T*shift(4,2)*rotate(-90), tileColours[1], id="5");

// build patch
mosaic M=mosaic(n,pinSub);

// add control points
pair CP=(u+2*v+w)/4;
M.addlayer(CP, CP_pen);
if(colourCPs) {
	M.set(negCP_pen, "1");
	M.set(negCP_pen, "2");
	M.set(posCP_pen, "3");
	M.set(posCP_pen, "4");
	M.set(negCP_pen, "5");
}

// rotate/reorient patch
transform RotVarphi=rotate(-varphi)^n;
transform Rot90=rotate(-90);
if(rotatePatch) M=RotVarphi*M;
if(reorientPatch) M=Rot90*M;

// set the tile borders
M.set(drawpen=posCP_pen, ids="3");

// draw patch
if(drawTiles) draw(M, tilePen);

// draw fixed point
pair FP=(inflation^n)*CP;
if(rotatePatch) FP=RotVarphi*FP;
if(reorientPatch) FP=Rot90*FP;
if(drawFP) draw(FP, p=FP_pen);

// overlay level n-k supertiles
mosaic superM=mosaic(max(n-k,0),pinSub);
superM.set(invisible, layer=0); 
superM.set(invisible, layer=1);
superM=scale(inflation^k)*superM;
if(rotatePatch) superM=RotVarphi*superM;
if(reorientPatch) superM=Rot90*superM;
if(overlaySupertiles && n>=k) draw(superM,overlayLine);


// clip the patch
pair boxShift=(boxShiftX,boxShiftY);
pair bottomLeft=(FP.x-boxL/2,FP.y-boxW/2)+boxShift;
pair bottomRight=(FP.x+boxL/2,FP.y-boxW/2)+boxShift;
pair topRight=(FP.x+boxL/2,FP.y+boxW/2)+boxShift;
pair topLeft=(FP.x-boxL/2,FP.y+boxW/2)+boxShift;
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clipPatch) clip(g=box);
