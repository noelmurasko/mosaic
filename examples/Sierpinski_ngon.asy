settings.outformat="pdf";
size(300);

import mosaic;

int n=3;

// scaling ratio
real r=2;
for(int i=1; i <= n#4; ++i) 
	r=r+2*cos(2*i*pi/n);
real r1=(r-1)/r;

// n-gon vertices
path ngon=polygon(n);
pair[] v;
for(int i=0; i < n; ++i)
	v.push((point(ngon,i)));

tile ngon=tile(ngon,fillpen=black);

// ifs
substitution nsub=substitution(ngon);
for(int i=0; i < n; ++i)
	nsub.addtile(shift(r1*v[i])*scale(1/r));

// attractor
int k=5;
mosaic Sierpinski=mosaic(k, nsub);
fill(Sierpinski);