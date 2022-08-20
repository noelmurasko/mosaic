settings.outformat="png";
int pix=300;
size(pix);
settings.render=16;

import mosaic;


Tile squareTile;
squareTile.border=box((0,0),(1,1));
pen[] col={blue};
squareTile.id=col;

Tile rectTile;
rectTile.border=box((0,0),(2,1));
pen[] col={red};
rectTile.id=col;

Tile[] protoTiles={squareTile,rectTile};

Tile[][] rule(Tile[] B){
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

int N=4;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth
Tile[] B=subTile(protoTiles, rule, N);
draw(B[0].border);
/*
path[] square0=protoTiles[0];
draw(shift(1/2,0)*square0);

path[] rect0=protoTiles[1];
draw(shift(0,-3/2)*rect0);

int M=3;
int m=1;
real ns=3;
real nr=5/2;
while(m < M) {
	real lambda=2;    // expansion constant
	real w=0.5/lambda^(m-1);    // scaled linewidth
	draw(shift(ns,0)*subTile(protoTiles, rule, colours, m)[0],linewidth(w));
	draw(shift(nr,-3/2)*subTile(protoTiles, rule, colours, m)[1],linewidth(w));
	m+=1;
	ns+=5/2;
	nr+=5/2;
}

draw(box((-1/2,-2),(15/2,3/2)),invisible);
*/