settings.outformat="pdf";
size(300);

import mosaic;

tile X1=tile(polygon(4), fillpen=black);
tile X2=copy(X1);
tile X3=copy(X1);

transform A=scale(0.419)+scale(0.606)*rotate(90);
transform b=shift(1,0);

substitution X1rule=substitution(X1);
X1rule.addtile(A,X1);
X1rule.addtile(A,X2);
X1rule.addtile(A,X3);

substitution X2rule=substitution(X2);
X2rule.addtile(b*A,X1);

substitution X3rule=substitution(X3);
X3rule.addtile(b*A,X2);

int n=4;
mosaic m1=mosaic(n,X1rule,X2rule,X3rule);
mosaic m2=mosaic(n,X2rule,X1rule,X3rule);
m2=copy(m2);
m2.updatelayer(fillpen=blue);
mosaic m3=mosaic(n,X3rule,X2rule,X1rule);
m3=copy(m3);
m3.updatelayer(fillpen=red);
m1.updatelayer(fillpen=green);
filldraw(A*m1);
filldraw(A*m2);
filldraw(A*m3);
