settings.outformat="pdf";
size(300);

import mosaic;

// pinwheel triangle
pair u=(2,0);
pair v=(2,1);
pair w=(0,0);
tile tri=u--v--w--cycle;

// inflation factor
inflation=sqrt(5);

// number of iterations
int n=3;

// options
bool drawTiles=true;  // draw the tiles
bool drawCPs=false;  // draw critical points in each triangle
bool drawFP=false;  // draw the fixed point of the tiling
bool colourTiles=false;  // colour tiles by chirality
bool colourBorders=false;  // colour tile borders by chirality
bool colourCPs=false;  // colour critical points by chirality
bool rotatePatch=true; // rotate the patch by arctan(1/2) each iteration
bool reorientPatch=true;  // rotate the final patch by 90 degrees
bool overlaySupertiles=true;  // overlay supertile borders
bool colourSupertiles=true;  // colour supertile borders by chirality
bool clipPatch=false;  // clip the patch with a box

// dot size/colour settings
pen tilePen=defaultpen;  // tile borders
pen posTiles=paleblue;  // tiles of positive chirality
pen negTiles=paleyellow;  // tiles of negative chirality
pen CP_pen=black+5;  // critical points when colourCPs=false
pen posCP_pen=blue+5;  // critical points of positive chirality
pen negCP_pen=orange+5;  // critical points of negative chirality
pen posBorders=blue+2;  // borders of tiles of positive chirality
pen negBorders=orange+2;  // borders of tiles of negative chirality
pen FP_pen=heavymagenta+6;  // fixed point
pen overlay=black+1;  // supertile borders (TODO: broken)
pen posOverlay=blue+1;  // supertile borders of positive chirality
pen negOverlay=orange+4;  // supertile borders of negative chirality

// overlay level n-k supertiles
int k=2;

// clip settings (rectangle centered at the fixed point)
real boxW=inflation^(max(n-2,0));  // clip box width
real boxL=((1+sqrt(5))/2)*boxW;  // clip box length
real boxShiftX=0;  // shift clip box horizontally
real boxShiftY=0;  // shift clip box vertically

// initialize a substitution rule
substitution pinSub=substitution(tri);

// define the substitution rule
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, id="1");
pinSub.addtile(T*shift(2,1), id="2");
pinSub.addtile(T*reflect((2,0),(2,1)), id="3");
pinSub.addtile(T*reflect((0,1),(1,1))*shift(2,1), id="4");
pinSub.addtile(T*shift(4,2)*rotate(-90), id="5");

// create the patch
mosaic M=mosaic(n,pinSub);

// colour tiles by chirality
if(colourTiles) {
	M.set(posTiles, "3", "4");  // positive chirality
	M.set(negTiles, "1", "2", "5");  // negative chirality
}

// colour tile borders by chirality (with positive on top)
M.set(drawpen=tilePen);
M.addlayer();
M.set(tri, drawpen=negBorders, "1", "2", "5");  // negative chirality
M.addlayer();
M.set(tri, drawpen=posBorders, "3", "4");  // positive chirality

// add control points
pair CP=(u+2*v+w)/4;
M.addlayer(CP, CP_pen);

if(colourCPs) {
	M.set(posCP_pen, "3", "4");  // positive chirality
	M.set(negCP_pen, "1", "2", "5");  // negative chirality
}

// rotate/reorient patch
transform RotVarphi=rotate(-varphi)^n;
transform Rot90=rotate(-90);
if(rotatePatch) M=RotVarphi*M;
if(reorientPatch) M=Rot90*M;

// draw the patch
if(drawTiles) filldraw(M, layer=0);
if(colourBorders){
		draw(M, layer=1);  // negative chirality tiles
		draw(M, layer=2);  // positive chirallity tiles
	}
if(drawCPs) draw(M, layer=3);

// draw fixed point
pair FP=(inflation^n)*CP;
if(rotatePatch) FP=RotVarphi*FP;
if(reorientPatch) FP=Rot90*FP;
if(drawFP) draw(FP, p=FP_pen);

// overlay level n-k supertiles
mosaic superM=mosaic(max(n-k,0),pinSub);
superM.set(invisible, layer=0);
if(superM.layers>1) superM.set(invisible, layer=1);
if(colourSupertiles) {
	superM.addlayer();
	superM.set(tri, drawpen=negOverlay, "1", "2", "5");
	superM.addlayer();
	superM.set(tri, drawpen=posOverlay, "3", "4");
}
superM=scale(inflation^k)*superM;
if(rotatePatch) superM=RotVarphi*superM;
if(reorientPatch) superM=Rot90*superM;
if(overlaySupertiles && n>=k) draw(superM);

// clip the patch
pair boxShift=(boxShiftX,boxShiftY);
pair bottomLeft=(FP.x-boxL/2,FP.y-boxW/2)+boxShift;
pair bottomRight=(FP.x+boxL/2,FP.y-boxW/2)+boxShift;
pair topRight=(FP.x+boxL/2,FP.y+boxW/2)+boxShift;
pair topLeft=(FP.x-boxL/2,FP.y+boxW/2)+boxShift;
path box=bottomLeft--bottomRight--topRight--topLeft--cycle;
if(clipPatch) clip(g=box);


