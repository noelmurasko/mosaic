settings.outformat="pdf";
size(300);

import mosaic;

real sqrt2=sqrt(2);
real sr=1+sqrt2; // silver ratio
transform R45=rotate(45);

inflation=sr;  // inflation factor

// prototiles
tile rhombus=tile((0,0)--(-1,1)--(-1,sr)--(0,sqrt2)--cycle,deepblue);
tile square=tile((0,0)--(-1,1)--(0,2)--(1,1)--cycle,yellow);

substitution rhombusRule=substitution(rhombus); // rhombus substitution rule

rhombusRule.addtile(rhombus);
rhombusRule.addtile(shift(-sr,sr)*R45^6,rhombus);
rhombusRule.addtile(shift(-sqrt2,2+sqrt2),rhombus);
rhombusRule.addtile(shift(-sr,sr),square);
rhombusRule.addtile(shift(-sr,sr)*R45^5,square);
rhombusRule.addtile(shift(0,2+sqrt2)*R45^4,square);
rhombusRule.addtile(shift(0,2+sqrt2)*R45,square);

substitution squareRule=substitution(square); // square substitution rule

squareRule.addtile(rhombus);
squareRule.addtile(R45^7,rhombus);
squareRule.addtile(shift(-sr,sr)*R45^6,rhombus);
squareRule.addtile(shift(0,2+sqrt2)*R45^5,rhombus);
squareRule.addtile(shift(0,2+sqrt2)*R45^4,square);
squareRule.addtile(shift(-sr,sr)*R45^5,square);
squareRule.addtile(shift(sr,sr)*R45^3,square);
squareRule.addtile(shift(0,2sr)*R45^3,square);
squareRule.addtile(shift(0,2sr)*R45^5,square);

// draw patch
int n=4;
mosaic M=mosaic(rhombus,n,rhombusRule,squareRule);
filldraw(M);
