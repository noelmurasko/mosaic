settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

Tile squareTile=Tile(box((0,0),(1,1)),blue);
Tile rectTile=Tile(box((0,0),(2,1)),red);

Tile[] protoTiles={squareTile,rectTile};

Tile[][] rule(Tile[] B) {
	Tile B0=scale(1/2)*B[0];
	Tile B1=scale(1/2)*B[1];

	Tile S1=shift(0,1/2)*B0;
	Tile S2=shift(1/2,1/2)*B0;
	Tile S3=B1;

	Tile R1=shift(1/2,0)*rotate(90)*B1;
	Tile R2=shift(1/2,0)*B1;
	Tile R3=shift(1,1/2)*B1;
	Tile R4=shift(1/2,1/2)*B0;
	Tile R5=shift(3/2,0)*B0;
	Tile[][] A={{S1,S2,S3},{R1,R2,R3,R4,R5}};
	return A;
}

int N=3;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Tile[] B=subTile(protoTiles, rule, N);

// We can draw and colour both tiles
// but they can't be on top of each other before we
// do so.
B[0]=shift(.5,0)*B[0];
B[0].fillColour();
draw(B[0],linewidth(w));

B[1]=shift(0,-1.5)*B[1];
B[1].fillColour();
draw(B[1],linewidth(w));
