settings.outformat="pdf";
int pix=300;
size(pix);
settings.render=16;

import mosaic;

pen[] colours={purple,yellow};

void loop(path s, transform T, transform[] Ts, int n, int nmax) {
	if(n < nmax) {
		int imax=Ts.length;
		for(int i; i < imax; ++i) {
			transform TTi=T*Ts[i];
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
transform T1=scale(1/2);
transform T2=shift(1/2,1/2)*T1;
transform T3=shift(2,0)*rotate(90)*T1;
transform T4=shift(0,2)*rotate(270)*T1;

int n=3;
transform[] T={T1,T2,T3,T4};
transform[] subTiling={};
loop(s,identity,T,0,n);
