settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

struct Tile2 {
	transform tran;
	path border;

	void operator init(transform tran, path border) {
    this.tran=tran;
    this.border=border;
  }
}

struct Border {
	path border;
	string name;

	void operator init(path border, string name) {
    this.border=border;
    this.name=name;
  }
}

struct Tiling {
	Tile2[] tiles;

	void operator init(Tile2[] tiles) {
    this.tiles=tiles;
  }
}


Tile2 operator *(Tile2 t1, Tile2 t2) {
	Tile2 t3;
	t3.tran=t1.tran*t2.tran;
	t3.border=t2.border;
	return t3;
}

Tile operator *(Tile2 t1, Tile t2) {
	Tile t3=t1.tran*t2;
	return t3;
}

void loop(Tiling Ts, Tile2 T, int n, int nmax) {
	if(n < nmax) {
		Tile2[] tiles=Ts.tiles;
		int imax=tiles.length;
		for(int i; i < imax; ++i) {
			Tile2 TTi=T*tiles[i];
			loop(Ts, TTi, n+1, nmax);
		}
	} else {
		draw(T.tran*T.border);
	}
}

//Tile protoTile=Tile(box((0,0),(1,1)),colours);
/*
path s=box((0,0),(1,1));
transform T1=scale(1/2);
transform T2=shift(1/2,0)*T1;
transform T3=shift(1/2,1/2)*T1;
transform T4=shift(0,1/2)*T1;

int nmax=3;
int n=0;
transform[] T={T1,T2,T3,T4};
transform[] subTiling={};
loop(s,identity,T,n,nmax);
*/

path c=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;


Tile2 T1=Tile2(scale(1/2),c);
Tile2 T2=Tile2(shift(1/2,1/2)*scale(1/2),c);
Tile2 T3=Tile2(shift(2,0)*rotate(90)*scale(1/2),c);
Tile2 T4=Tile2(shift(0,2)*rotate(270)*scale(1/2),c);

int n=2;
Tile2[] Ts={T1,T2,T3,T4};

Tiling T=Tiling(Ts);
transform[] subTiling={};

loop(T,Tile2(identity,c),0,n);
