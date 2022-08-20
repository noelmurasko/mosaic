settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

int N=5;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile protoTile;
protoTile.border=box((0,0),(1,1));
pen[] col={purple,yellow};
protoTile.id=col;

Tile[] rule(Tile B){
	Tile b1=scale(1/2)*B;
	Tile b2=shift(1/2,0)*b1;
  Tile b3=shift(1/2,1/2)*b1;
	Tile b4=shift(0,1/2)*b1;
	Tile[] A={b1,b2,b3,b4};
	return A;
}
pen[] colours={purple,yellow};

Tile B=subTile(protoTile, rule, N);
draw(B.border, linewidth(w));