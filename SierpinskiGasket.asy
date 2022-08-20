settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

path[] equiTriangle=(0,0)--(1,sqrt(3))--(2,0)--cycle;
Tile protoTile=Tile(equiTriangle,black);

Tile[] rule(Tile B) {
	Tile b1=scale(1/2)*B;
	Tile b2=shift(1/2,sqrt(3)/2)*b1;
	Tile b3=shift(1,0)*b1;
	Tile[] A={b1,b2,b3};
	return A;
}

int N=3;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
B.fillColour();
draw(B, linewidth(w));
