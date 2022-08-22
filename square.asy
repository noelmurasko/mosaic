settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

pen[] colours={};
Tile protoTile=Tile(box((0,0),(1,1)),colours);
protoTile.name="square";
assert(point(protoTile.border[0],0)==(0,0)); // WE MUST START AT (0,0)

Tile[] rule(Tile B,int i) {
	Tile[] A;
	real lambda=1/2;
	if(B.name == "square"){
		Tile b1=Tile(B,green);
		Tile b2=Tile(shift(lambda^i,0)*b1,blue);
	  Tile b3=Tile(shift(lambda^i,lambda^i)*b1,green);
		Tile b4=Tile(shift(0,lambda^i)*b1,blue);
		Tile[] As={b1,b2,b3,b4};
		A=As;
	}
	return A;
}

int N=5;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
//write(B.colour);
B.fillColour();

draw(B, linewidth(w));
