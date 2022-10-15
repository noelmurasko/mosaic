settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

pen[] colours={paleyellow,paleyellow,heavyred,paleblue,brown};

path[] pinwheel=(0,0)--(2,0)--(2,1)--cycle;

Tile protoTile=Tile(pinwheel,colours);

Tile[] rule(Tile B) {

	Tile b1=scale(1/sqrt(5))*B;
	Tile b2=shift(2/sqrt(5),1/sqrt(5))*b1;
	Tile b3=reflect((2/sqrt(5), 0),(2/sqrt(5),1))*b1;
	Tile b4=reflect((0,1/sqrt(5)),(1,1/sqrt(5)))*b2;
	Tile b5=shift(4/sqrt(5),2/sqrt(5))*rotate(-90)*b1;
	Tile[] A={b1,b2,b3,b4,b5};

	//Transform back to original position
	for(int i=0; i < A.length; ++i)
		A[i]=reflect((0,0),(0,1))*rotate(90+aTan(2))*A[i];

	return A;
}

int N=3;
real lambda=sqrt(5);    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile B=subTile(protoTile, rule, N);
B.fillColour();
draw(B, linewidth(w));
