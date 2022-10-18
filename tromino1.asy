settings.outformat="pdf";
size(300);

import mosaic;

path chair=(0,0)--(2,0)--(2,2)--(1,2)--(1,1)--(0,1)--cycle;
path rect=(0,0)--(3,0)--(3,1)--(0,1)--cycle;

// chair transforms
mtile C1=mtile(shift(1,1)*rotate(180)*scale(1/2),chair,yellow);
mtile C2=mtile(shift(1,1/2)*scale(1/2),chair,yellow);
mtile C3=mtile(shift(1,1)*shift(1,1)*rotate(180)*scale(1/2),chair,yellow);
mtile C4=mtile(shift(1/2,0)*scale(1/2),chair,rect,red);

// rectangle transforms
mtile R1=mtile(shift(2,0)*scale(1/2),rect,chair,yellow);
mtile R2=mtile(shift(1,1)*rotate(180)*scale(1/2),rect,chair,yellow);
mtile R3=mtile(shift(1/2,0)*scale(1/2),rect,red);
mtile R4=mtile(shift(1/2,1/2)*shift(1/2,0)*scale(1/2),rect,red);

int nmax=5;
mtile[] Ts={C1,C2,C3,C4,R1,R2,R3,R4};
mtile[] b=substitute(Ts,rect,nmax);
draw(b);
