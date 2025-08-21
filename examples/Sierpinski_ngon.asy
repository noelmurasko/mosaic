settings.outformat="pdf";
size(300);

import mosaic;

int n=7;

// scaling ratio
real r=2;
for(int i=1; i <= n#4; ++i)
	r+=2*cos(2*i*pi/n);
real r1=(r-1)/r;

tile ngon=tile(polygon(n),fillpen=black);

// ifs
substitution nsub=substitution(ngon);
for(int i=0; i < n; ++i)
	nsub.addtile(shift(r1*point(ngon.path[0],i))*scale(1/r));

// attractor
int k=5;
mosaic Sierpinski=mosaic(k, nsub);
fill(Sierpinski);
