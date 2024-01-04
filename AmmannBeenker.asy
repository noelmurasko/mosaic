settings.outformat="pdf";
size(300);

import mosaic;

real sqrt2=sqrt(2);
real sr=1+sqrt2; // silver ratio
transform R45=rotate(45);

inflation=sr;  // inflation factor

// prototiles
path rhombus=(0,0)--(-1,1)--(-1,sr)--(0,sqrt2)--cycle;
path square=(0,0)--(-1,1)--(0,2)--(1,1)--cycle;
path[] prototiles={rhombus,square};


// rhombus substitution tiles
mtile RR1=mtile(rhombus,deepblue);
mtile RR2=mtile(shift(-sr,sr)*R45^6,rhombus,deepblue);
mtile RR3=mtile(shift(-sqrt2,2+sqrt2),rhombus,deepblue);
mtile RS1=mtile(shift(-sr,sr),square,yellow);
mtile RS2=mtile(shift(-sr,sr)*R45^5,square,yellow);
mtile RS3=mtile(shift(0,2+sqrt2)*R45^4,square,yellow);
mtile RS4=mtile(shift(0,2+sqrt2)*R45,square,yellow);

mrule rhombusRule=mrule(rhombus,RR1,RR2,RR3,RS1,RS2,RS3,RS4); // rhombus substitution rule

// square substitution tiles
mtile SR1=mtile(rhombus,deepblue);
mtile SR2=mtile(R45^7,rhombus,deepblue);
mtile SR3=mtile(shift(-sr,sr)*R45^6,rhombus,deepblue);
mtile SR4=mtile(shift(0,2+sqrt2)*R45^5,rhombus,deepblue);
mtile SS1=mtile(shift(0,2+sqrt2)*R45^4,square,yellow);
mtile SS2=mtile(shift(-sr,sr)*R45^5,square,yellow);
mtile SS3=mtile(shift(sr,sr)*R45^3,square,yellow);
mtile SS4=mtile(shift(0,2sr)*R45^3,square,yellow);
mtile SS5=mtile(shift(0,2sr)*R45^5,square,yellow);

mrule squareRule=mrule(square,SR1,SR2,SR3,SR4,SS1,SS2,SS3,SS4,SS5); // square substitution rule

// draw patch 
int n=5;
mosaic M=mosaic(rhombus,n,rhombusRule,squareRule);
draw(M, white);
