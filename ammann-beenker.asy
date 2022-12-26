settings.outformat="pdf";
size(300);

import mosaic;

path rhombus=(0,0)--(-1,1)--(-1,1+sqrt(2))--(0,sqrt(2))--cycle;
path square=(0,0)--(-1,1)--(0,2)--(1,1)--cycle;

inflation=1+sqrt(2);

// rhombus substitution
mtile RR1=mtile(rhombus,deepblue);
mtile RR2=mtile(shift(-1-sqrt(2),1+sqrt(2))*rotate(-90),rhombus,deepblue);
mtile RR3=mtile(shift(-sqrt(2),2+sqrt(2)),rhombus,deepblue);
mtile RS1=mtile(shift(-1-sqrt(2),1+sqrt(2)),rhombus,square,yellow);
mtile RS2=mtile(shift(-1-sqrt(2),1+sqrt(2))*rotate(-135),rhombus,square,yellow);
mtile RS3=mtile(shift(0,2+sqrt(2))*rotate(180),rhombus,square,yellow);
mtile RS4=mtile(shift(0,2+sqrt(2))*rotate(45),rhombus,square,yellow);

// square substitution
mtile SR1=mtile(square,rhombus,deepblue);
mtile SR2=mtile(rotate(-45),square,rhombus,deepblue);
mtile SR3=mtile(shift(-1-sqrt(2),1+sqrt(2))*rotate(-90),square,rhombus,deepblue);
mtile SR4=mtile(shift(0,2+sqrt(2))*rotate(-135),square,rhombus,deepblue);
mtile SS1=mtile(shift(0,2+sqrt(2))*rotate(180),square,yellow);
mtile SS2=mtile(shift(0,0)*rotate(-135),square,yellow);
mtile SS2=mtile(shift(-1-sqrt(2),1+sqrt(2))*rotate(-135),square,yellow);
mtile SS3=mtile(shift(1+sqrt(2),1+sqrt(2))*rotate(135),square,yellow);
mtile SS4=mtile(shift(0,2+2*sqrt(2))*rotate(135),square,yellow);
mtile SS5=mtile(shift(0,2+2*sqrt(2))*rotate(-135),square,yellow);

int n=5;
mosaic M=mosaic(rhombus,n,RR1,RR2,RR3,RS1,RS2,RS3,RS4,SR1,SR2,SR3,SR4,SS1,SS2,SS3,SS4,SS5);
draw(M);