settings.outformat="pdf";
size(300);

import mosaic;

int theta=18;
int alpha=90-theta;
real s=2*Sin(theta);
real x=s*Sin(alpha);
real y=s*Cos(alpha);
tile bowtie=(0,0)--(x,y)--(2x,0)--(2x,s)--(x,s-y)--(0,s)--cycle;
tile decagon=polygon(10);

transform T=shift(Cos(2theta),Sin(2theta))*rotate(-alpha-theta);
draw(T*bowtie);
draw(decagon);
