settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

struct Tile2 {
	transform tran;
	string name;

	void operator init(transform tran, string name) {
    this.tran=tran;
    this.name=name;
  }
}

Tile2 operator *(Tile2 t1, Tile2 t2) {
	Tile2 t3;
	t3.tran=t1.tran*t2.tran;
	t3.name=t2.name;
	return t3;
}

Tile operator *(Tile2 t1, Tile t2) {
	Tile t3=t1.tran*t2;
	return t3;
}

void loop(Tile s, Tile2 T, Tile2[] Ts, int n, int nmax) {
	if(n < nmax) {
		int imax=Ts.length;
		for(int i; i < imax; ++i) {
			Tile2 TTi=T*Ts[i];
			loop(s, TTi, Ts, n+1, nmax);
		}
	} else {
		draw(T*s);
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

path s=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

Tile s=Tile(s,red);
s.name="square";

string name="chair";

Tile2 T1=Tile2(scale(1/2),name);
Tile2 T2=Tile2(shift(1/2,1/2)*scale(1/2),name);
Tile2 T3=Tile2(shift(2,0)*rotate(90)*scale(1/2),name);
Tile2 T4=Tile2(shift(0,2)*rotate(270)*scale(1/2),name);

int n=3;
Tile2[] T={T1,T2,T3,T4};
transform[] subTiling={};

loop(s,Tile2(identity,name),T,0,n);
