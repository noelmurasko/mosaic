settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

pen[] colours={white,orange,blue,blue};
path[] chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

Tile protoTile=Tile(chair,colours);

Tile[] rule(Tile B) {
	Tile b1=scale(1/2)*B;
	Tile b2=shift(1/2,1/2)*b1;
	Tile b3=shift(2,0)*rotate(90)*b1;
	Tile b4=shift(0,2)*rotate(270)*b1;
	Tile[] A={b1,b2,b3,b4};
	return A;
}

int N=3;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
B.fillColour();
draw(B, linewidth(w));
