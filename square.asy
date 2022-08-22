settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

Tile protoTile=Tile(box((0,0),(1,1)),"square");

Tile[] rule(Tile B, real lambda) {
	Tile[] A;
	if(B.name == "square"){
		Tile b1=Tile(B,green);
		Tile b2=Tile(shift(lambda,0)*b1,blue);
	  Tile b3=Tile(shift(lambda,lambda)*b1,green);
		Tile b4=Tile(shift(0,lambda)*b1,blue);
		Tile[] As={b1,b2,b3,b4};
		A=As;
	}
	return A;
}

int N=2;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
//write(B.colour);
B.fillColour();

draw(B, linewidth(w));
