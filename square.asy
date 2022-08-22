settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

pen[] colours={};
Tile protoTile=Tile(box((0,0),(1,1)),colours);
protoTile.name="square";

Tile[] rule(Tile B,int i) {
	Tile[] A;
	real lambda=1/2;
	if(B.name == "square"){
		pair start=point(B.border[0],0);
		pair correction=(1-lambda)*start;
		Tile b1=shift(correction)*scale(lambda)*B;
		Tile b2=shift(lambda^i,0)*b1;
	  Tile b3=shift(lambda^i,lambda^i)*b1;
		Tile b4=shift(0,lambda^i)*b1;
		pen[] g={green};
		pen[] b={blue};
		b1.colour=g;
		b2.colour=b;
		b3.colour=g;
		b4.colour=b;
		int s=1;
		Tile[] As={b1,b2,b3,b4};
		A=As;
	}
	return A;
}

int N=1;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
//write(B.colour);
B.fillColour();

draw(B, linewidth(w));
