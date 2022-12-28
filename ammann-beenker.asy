settings.outformat="pdf";
size(300);

import mosaic;

real sqrt2=sqrt(2);
real sr=1+sqrt2; // silver ratio

// prototiles
path rhombus=(0,0)--(-1,1)--(-1,sr)--(0,sqrt2)--cycle;
path square=(0,0)--(-1,1)--(0,2)--(1,1)--cycle;
path[] prototiles={rhombus,square};

inflation=sr;  // inflation factor

transform R45=rotate(45);

// rhombus substitution rule ===

// rhombi
ptransform RR1=ptransform(rhombus,deepblue);
ptransform RR2=ptransform(shift(-sr,sr)*R45^6,rhombus,deepblue);
ptransform RR3=ptransform(shift(-sqrt2,2+sqrt2),rhombus,deepblue);

// squares 
ptransform RS1=ptransform(shift(-sr,sr),square,yellow);
ptransform RS2=ptransform(shift(-sr,sr)*R45^5,square,yellow);
ptransform RS3=ptransform(shift(0,2+sqrt2)*R45^4,square,yellow);
ptransform RS4=ptransform(shift(0,2+sqrt2)*R45,square,yellow);

mrule rhombusRule=mrule(rhombus,RR1,RR2,RR3,RS1,RS2,RS3,RS4); // rhombus substitution rule

// square substitution rule ===

// rhombi
ptransform SR1=ptransform(rhombus,deepblue);
ptransform SR2=ptransform(R45^7,rhombus,deepblue);
ptransform SR3=ptransform(shift(-sr,sr)*R45^6,rhombus,deepblue);
ptransform SR4=ptransform(shift(0,2+sqrt2)*R45^5,rhombus,deepblue);

//squares
ptransform SS1=ptransform(shift(0,2+sqrt2)*R45^4,square,yellow);
ptransform SS2=ptransform(shift(-sr,sr)*R45^5,square,yellow);
ptransform SS3=ptransform(shift(sr,sr)*R45^3,square,yellow);
ptransform SS4=ptransform(shift(0,2sr)*R45^3,square,yellow);
ptransform SS5=ptransform(shift(0,2sr)*R45^5,square,yellow);

mrule squareRule=mrule(square,SR1,SR2,SR3,SR4,SS1,SS2,SS3,SS4,SS5); // square substitution rule

// the mosaic ===

int n=5;
mosaic M=mosaic(rhombus,n,rhombusRule,squareRule);
draw(M,white);
