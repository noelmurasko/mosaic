settings.outformat="pdf";
size(300);

import mosaic;

// prototile
real h=sqrt(15)/2;
tile tri=(0,0)--(1,0)--(1/2,h)--cycle;

// inflation factor
currentinflation=3;

// number of iterations
int n=4;

// initialize viper substitution
substitution viperSub=substitution(tri);

// define the substitution rule
real theta=-aCos(1/4);
transform R180=rotate(180);
transform T=shift(0,h)*R180;
viperSub.addtile(identity, lightgray);
viperSub.addtile(shift(1/2,h)*rotate(theta),brown);
viperSub.addtile(shift(5/2,h)*rotate(180+theta)*shift(-1,0),lightgray);
viperSub.addtile(shift(1,0)*rotate(theta)*shift(-1,0),brown);
viperSub.addtile(shift(3,0)*rotate(180+theta),lightgray);
viperSub.addtile(shift(1/2,h),brown);
viperSub.addtile(shift(2,2h)*rotate(180),lightgray);
viperSub.addtile(shift(3/2,h),brown);
viperSub.addtile(shift(1,2h),brown);

// build the patch
mosaic M=mosaic(n,viperSub);

// draw the patch
filldraw(M);
