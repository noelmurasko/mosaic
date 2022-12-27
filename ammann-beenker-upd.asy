settings.outformat="pdf";
size(300);

import mosaic-upd;

// prototiles
path rhombus=(0,0)--(-1,1)--(-1,1+sqrt(2))--(0,sqrt(2))--cycle;
path square=(0,0)--(-1,1)--(0,2)--(1,1)--cycle;
prototiles={rhombus,square};

inflation=1+sqrt(2);  // inflation factor

// rhombus substitution rule ===

// rhombi
ptransform RR1=ptransform(rhombus,deepblue);
ptransform RR2=ptransform(shift(-1-sqrt(2),1+sqrt(2))*rotate(-90),rhombus,deepblue);
ptransform RR3=ptransform(shift(-sqrt(2),2+sqrt(2)),rhombus,deepblue);

// squares
ptransform RS1=ptransform(shift(-1-sqrt(2),1+sqrt(2),square,yellow);
ptransform RS2=ptransform(shift(-1-sqrt(2),1+sqrt(2))*rotate(-135),square,yellow);
ptransform RS3=ptransform(shift(0,2+sqrt(2))*rotate(180),square,yellow);
ptransform RS4=ptransform(shift(0,2+sqrt(2))*rotate(45),square,yellow);

mrule rhombusRule=mrule(rhombus,RR1,RR2,RR3,RS1,RS2,RS3,RS4); // rhombus substitution rule

// square substitution rule ===

// rhombi
ptransform SR1=ptransform(rhombus,deepblue);
ptransform SR2=ptransfrom(rotate(-45),rhombus,deepblue);
ptransform SR3=ptransform(shift(-1-sqrt(2),1+sqrt(2))*rotate(-90),rhombus,deepblue);
ptransform SR4=ptransform(shift(0,2+sqrt(2))*rotate(-135),rhombus,deepblue);

//squares
ptransform SS1=ptransform(shift(0,2+sqrt(2))*rotate(180),square,yellow);
ptransform SS2=ptransform(shift(-1-sqrt(2),1+sqrt(2)),square,yellow);
ptransform SS3=ptransform(shift(1+sqrt(2),1+sqrt(2))*rotate(135),square,yellow);
ptransform SS4=ptransform(shift(0,2+2*sqrt(2))*rotate(135),square,yellow);
ptransform SS5=ptransform(shift(0,2+2*sqrt(2))*rotate(-135),square,yellow);

mrule squareRule=mrule(square,SR1,SR2,SR3,SR4,SS1,SS2,SS3,SS4,SS5); // square substitution rule

// the mosaic ===

subRule={rhombusRule,squareRule}; // mosaic substitution rule

int n=1;
//mosaic M=mosaic(subRule,n);
//draw(M);
