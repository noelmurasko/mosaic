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

substitution rhombusRule=substitution(rhombus); // rhombus substitution rule

rhombusRule.addtile(rhombus,deepblue);
rhombusRule.addtile(shift(-sr,sr)*R45^6,rhombus,deepblue);
rhombusRule.addtile(shift(-sqrt2,2+sqrt2),rhombus,deepblue);
rhombusRule.addtile(shift(-sr,sr),square,yellow);
rhombusRule.addtile(shift(-sr,sr)*R45^5,square,yellow);
rhombusRule.addtile(shift(0,2+sqrt2)*R45^4,square,yellow);
rhombusRule.addtile(shift(0,2+sqrt2)*R45,square,yellow);


substitution squareRule=substitution(square); // square substitution rule

squareRule.addtile(rhombus,deepblue);
squareRule.addtile(R45^7,rhombus,deepblue);
squareRule.addtile(shift(-sr,sr)*R45^6,rhombus,deepblue);
squareRule.addtile(shift(0,2+sqrt2)*R45^5,rhombus,deepblue);
squareRule.addtile(shift(0,2+sqrt2)*R45^4,square,yellow);
squareRule.addtile(shift(-sr,sr)*R45^5,square,yellow);
squareRule.addtile(shift(sr,sr)*R45^3,square,yellow);
squareRule.addtile(shift(0,2sr)*R45^3,square,yellow);
squareRule.addtile(shift(0,2sr)*R45^5,square,yellow);

// draw patch
int n=4;
mosaic M=mosaic(rhombus,n,rhombusRule,squareRule);
draw(M);
