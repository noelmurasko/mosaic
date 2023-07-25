settings.outformat="pdf";
size(300);

import mosaic;

inflation=2;

path[] chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--
              cycle;

mtile C1=mtile(white);
mtile C2=mtile(shift(1,1),orange);
mtile C3=mtile(shift(4,0)*rotate(90),blue);
mtile C4=mtile(shift(0,4)*rotate(270),blue);

mrule chairRule=mrule(C1,C2,C3,C4);

int n=4;
mosaic M=mosaic(chair,n,chairRule);
draw(M);

path[] dot=shift(2/5,2/5)*scale(1/5)*unitcircle;

mtile D1=mtile(blue);
mtile D2=mtile(shift(1,1),white);
mtile D3=mtile(shift(4,0)*rotate(90),orange);
mtile D4=mtile(shift(0,4)*rotate(270),orange);

mrule dotRule=mrule(D1,D2,D3,D4);

int n=4;
mosaic M=mosaic(dot,n,dotRule);
draw(M);
